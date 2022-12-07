//
//  ShopViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/07.
//

import Foundation
import RxCocoa
import RxSwift

final class ShopViewModel {
    final  let shopMyInfoStatus = PublishSubject<UserSelectedItemStatus>()
//    final let myPurchaseInfo: BehaviorRelay<[ShopMyInfo]> = BehaviorRelay(value: [])
    
    func saveUserThunnail(sesec: Int, background: Int, idtoken: String) {
        let api = SeSACAPI.useritem(sesac: sesec, background: background)
        
        Network.shared.sendRequestSeSAC(url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { [weak self] statuscode in
            guard let status = UserSelectedItemStatus(rawValue: statuscode) else {
                print("스테이터스 코드 가져오기 실패 🔴", statuscode)
                return
            }
                    print("스테이터스 코드 가져오기", status, statuscode)
            self?.shopMyInfoStatus.onNext(status)
        }
    }
}
