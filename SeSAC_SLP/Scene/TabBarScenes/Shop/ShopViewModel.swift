//
//  ShopViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/06.
//

import Foundation
import RxCocoa
import RxSwift

import StoreKit

final class ShopViewModel: NSObject {
    
    var vctype: ShopContainedViewController.Vctype
    var product: SKProduct?
    init(vctype: ShopContainedViewController.Vctype) {
        self.vctype = vctype
    }
    
    typealias ProductArray = (ShopContainedViewController.Vctype?, Array<SKProduct>)
    
    // 클라에서 가지고있는 상품 정보 ->
    var productIdentifiers: Set<String> {
        
        switch vctype {
        case .sesac:
           return [SesacProductIndex.one.SeSAC, SesacProductIndex.two.SeSAC, SesacProductIndex.three.SeSAC, SesacProductIndex.four.SeSAC] // 여줘보기
        case .backgruond:
            return [BackProductIndex.one.Background, BackProductIndex.two.Background, BackProductIndex.three.Background, BackProductIndex.four.Background,
                    BackProductIndex.five.Background,
                    BackProductIndex.six.Background,
                    BackProductIndex.seven.Background]
        }
    }
    
    // 인앱에서 가지고있는 상품 정보 -> 매칭이 안되는 물건이 있다면 어떻게 해결한건가
    let shopMyInfoStatus = PublishSubject<ShopMyInfoStatus>()
    let myPurchaseInfo: BehaviorRelay<[ShopMyInfo]> = BehaviorRelay(value: [])
    
    var productarray: BehaviorRelay<ProductArray> = BehaviorRelay(value: (nil, [])) // 상품정보
//    
////    //여기서 보유한 상품인지 확인하기, 어차피 에셋에 있는걸 사용자가 샀을 거니까
//    func postProduct(index: Character?) -> Bool {
//    let purchased = productIdentifiers.filter { product in
//            guard let num = Int(String(index ?? "0")) else {
//                print("Int로 변환할 수 없습니다", #function)
//                return false }
//        return (num)
//        }
//        return purchased.isEmpty
//    }
    
    func USerInfoNetwork(idtoken: String, completion: ((ShopMyInfo) -> Void)? = nil) {
        let api = SeSACAPI.shopmyinfo
        
        Network.shared.receiveRequestSeSAC(type: ShopMyInfo.self, url: api.url, parameter: nil, method: .get, headers: api.getheader(idtoken: idtoken)) { [weak self] data, statusCode  in
            guard let shopmyinfo = ShopMyInfoStatus(rawValue: statusCode) else { return }
            self?.shopMyInfoStatus.onNext(shopmyinfo)
            
            guard let data = data else {
                print("구매데이터 가져오기 실패 🔴")
                self?.shopMyInfoStatus.onNext(shopmyinfo)
                return
            }
            
            print("구매정보가져오기 성공 ✅", data)
            
            self?.myPurchaseInfo.accept([data])
            //성공
            completion?(data)
        }
    }
    
    func buy(index: Int) {
        let payment = SKPayment(product: productarray.value.1[index])
        SKPaymentQueue.default().add(payment)
        SKPaymentQueue.default().add(self)
    }
    
    // 서버가 있다면 서버가 해주고 없다면 이렇게 구매 영수증이 유효한지 확인해줘야함
    func receiptValidation(transaction: SKPaymentTransaction, productIdentifier: String) {
            // SandBox: “https://sandbox.itunes.apple.com/verifyReceipt”
            // iTunes Store : “https://buy.itunes.apple.com/verifyReceipt”

            //구매 영수증 정보
            let receiptFileURL = Bundle.main.appStoreReceiptURL
            let receiptData = try? Data(contentsOf: receiptFileURL!)
        let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))

            print(receiptString)
            //거래 내역(transaction)을 큐에서 제거
            SKPaymentQueue.default().finishTransaction(transaction)

        }
}

extension ShopViewModel: SKProductsRequestDelegate {
    //3. 인앱 상품 정보 조회
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let products = response.products
        
        var productArray = Array<SKProduct>()
        
        if products.count > 0 {
            
            for i in products {
                productArray.append(i)
                product = i //옵션: 셀에서 구매하기 버튼 클릭
                print(i.localizedTitle, i.price, i.priceLocale, i.productIdentifier, i.localizedDescription)
            }
          productarray.accept((vctype, productArray))
        } else {
            print("No Product Found") // 계약 업데이트, 유료 계약 ㄴㄴ .Capabilities ㄴㄴ 일때
        }
    }
}

// MARK: 결제 모델로 나중에 따로 빼기

extension ShopViewModel {
    
    // 상품조회 : productIdentifiers에 정의된 상품 ID에 대한 정보 가져오기 및 사용자의 디바이스가 인앱결제가 가능한지 여부 확인
    func requestProductData(productIdentifiers: Set<String>) {
        //인앱결제가능한지 확이
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: productIdentifiers)
            request.delegate = self
            request.start() //인앱 상품 조회
            print("인앱 결제 가능")
        } else {
            print("In App Purchase Not Enabled")
        }
    }
}

//거래를 담당하는 아이
extension ShopViewModel: SKPaymentTransactionObserver {
    
        func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
            
            for transaction in transactions {
                
                // transactionState -> 배열임
                switch transaction.transactionState {
                    
                case .purchased: //구매 승인 이후에 영수증 검증
                    
                    print("Transaction Approved. \(transaction.payment.productIdentifier)")
                    //영수증
                    receiptValidation(transaction: transaction, productIdentifier: transaction.payment.productIdentifier)
                    
                case .failed: //실패 토스트, transaction
                    
                    print("Transaction Failed")
                    SKPaymentQueue.default().finishTransaction(transaction)
                    
                default:
                    break
                }
            }
        }
        
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
            print("removedTransactions")
        }
}


