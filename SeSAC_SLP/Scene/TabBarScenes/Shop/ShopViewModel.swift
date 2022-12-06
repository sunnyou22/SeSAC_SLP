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

final class ShopViewModel {
    
    var vctype: ShopContainedViewController.Vctype
    
    init(vctype: ShopContainedViewController.Vctype) {
        self.vctype = vctype
    }
    
    typealias ProductArray = (ShopContainedViewController.Vctype?, Array<SKProduct>)
    
    // 클라에서 가지고있는 상품 정보
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
    let myPurchaseInfo = PublishSubject<ShopMyInfo>()
    
    var productArray: BehaviorRelay<ProductArray> = BehaviorRelay(value: (nil, [])) // 상품정보
    
    //    func postProduct(product: Int, )
    
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
            
            self?.myPurchaseInfo.onNext(data)
            //성공
            completion?(data)
        }
    }
}
