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
//뷰모델 분리하기
final class ShopContainerViewModel: NSObject {
 
    final var vctype: ShopContainedViewController.Vctype
    final var product: SKProduct?
    
    let sesacImg: BehaviorRelay<String> = BehaviorRelay(value: "")
    let backgroundImg: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    init(vctype: ShopContainedViewController.Vctype) {
        
        self.vctype = vctype
        super.init()
    }
    
    final let receiptValidationStatus = PublishSubject<ReceiptValidationStatus>()
    
    typealias ProductArray = (ShopContainedViewController.Vctype?, Array<SKProduct>)
    
    // 클라에서 가지고있는 상품 정보 ->
    final  var productIdentifiers: Set<String> {
        
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
    final  let shopMyInfoStatus = PublishSubject<ShopMyInfoStatus>()
    final let myPurchaseInfo: BehaviorRelay<[ShopMyInfo]> = BehaviorRelay(value: [])
    
    final var productarray: BehaviorRelay<ProductArray> = BehaviorRelay(value: (nil, [])) // 상품정보
    
//    func postUserItem(idtoken: String, completion: ((ShopMyInfo) -> Void)? = nil) {
//        let api = SeSACAPI.shopmyinfo
//
//        Network.shared.receiveRequestSeSAC(type: ShopMyInfo.self, url: api.url, parameter: nil, method: .get, headers: api.getheader(idtoken: idtoken)) { [weak self] data, statusCode  in
//            guard let shopmyinfo = ShopMyInfoStatus(rawValue: statusCode) else { return }
//            self?.shopMyInfoStatus.onNext(shopmyinfo)
//
//            guard let data = data else {
//                print("구매데이터 가져오기 실패 🔴")
//                self?.shopMyInfoStatus.onNext(shopmyinfo)
//                return
//            }
//
//            print("구매정보가져오기 성공 ✅", data)
//
//            self?.myPurchaseInfo.accept([data])
//
//            //성공
//            completion?(data)
//        }
//        }
    
    func myPurchaseInfo(idtoken: String) -> Single<ShopMyInfo> {
        let api = SeSACAPI.shopmyinfo
        return Single<ShopMyInfo>.create { (single) -> Disposable in
            
            Network.shared.receiveRequestSeSAC(type: ShopMyInfo.self, url: api.url, parameter: nil, method: .get, headers: api.getheader(idtoken: idtoken))
                .subscribe(onSuccess: { [weak self] (data, statusCode) in
                    guard let shopmyinfo = ShopMyInfoStatus(rawValue: statusCode) else { return }
                    self?.shopMyInfoStatus.onNext(shopmyinfo)
                    
                    guard let data = data else {
                        print("구매데이터 가져오기 실패 🔴")
                        self?.shopMyInfoStatus.onNext(shopmyinfo)
                        single(.failure(shopmyinfo))
                        return
                    }
                    
                    print("구매정보가져오기 성공 ✅", data)
                    
                    self?.myPurchaseInfo.accept([data])
                    single(.success(data))
                })
        }
    }
    
    func buy(index: Int) {
        let payment = SKPayment(product: productarray.value.1[index])
        SKPaymentQueue.default().add(payment)
        SKPaymentQueue.default().add(self)
        LoadingIndicator.hideLoading()
    }
    
    func checkreceiptValidation(receipt: String, product: String, idtoken: String) {
        let api = SeSACAPI.receiptVelidation(receipt: receipt, product: product)
        
        Network.shared.sendRequestSeSAC(url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { [weak self] statuscode in
            guard let status = ReceiptValidationStatus(rawValue: statuscode) else { return }
            print(status)
            self?.receiptValidationStatus.onNext(status)
        }
    }
    
    // 서버가 있다면 서버가 해주고 없다면 이렇게 구매 영수증이 유효한지 확인해줘야함
    fileprivate func receiptValidation(transaction: SKPaymentTransaction, productIdentifier: String) -> String? {
        // SandBox: “https://sandbox.itunes.apple.com/verifyReceipt”
        // iTunes Store : “https://buy.itunes.apple.com/verifyReceipt”
        
        //구매 영수증 정보
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        print(receiptString)
        //거래 내역(transaction)을 큐에서 제거
        SKPaymentQueue.default().finishTransaction(transaction)
        return receiptString
    }
}

extension ShopContainerViewModel: SKProductsRequestDelegate {
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

extension ShopContainerViewModel {
    
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
extension ShopContainerViewModel: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        guard let idtoken = UserDefaults.idtoken else {
            // 여기서 온보딩으로 보내주느 메서드 이벤트 방출해서 뷰컨과 연결해주기
            return
        }
        
        for transaction in transactions {
            LoadingIndicator.showLoading()
            // transactionState -> 배열임
            switch transaction.transactionState {
                
            case .purchased: //구매 승인 이후에 영수증 검증
                
                print("Transaction Approved. \(transaction.payment.productIdentifier)")
                //영수증
                let receipt = receiptValidation(transaction: transaction, productIdentifier: transaction.payment.productIdentifier)
                
                checkreceiptValidation(receipt: receipt!, product: transaction.payment.productIdentifier, idtoken: idtoken)
            case .failed: //실패 토스트, transaction
                
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
                LoadingIndicator.hideLoading()
            default:
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("removedTransactions")
    }
}


