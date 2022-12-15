//
//  LacunchViewMoldel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/15.
//

import Foundation

import RxCocoa
import RxSwift
import Alamofire
import FirebaseAuth

//manager로 넣어줄건지 고민해보기

final class LacunchViewMoldel {
    
    let bag = DisposeBag()
    let commonSerVerModel = CommonServerManager()
        
    func checkIdtoken() -> Single<String> {
        return Single<String>.create { single -> Disposable in
            guard let idtoken = UserDefaults.idtoken else {
                single(.failure(UserStatus.FirebaseTokenError))
                return Disposables.create()
            }
            single(.success(idtoken))
            
            return Disposables.create()
        }
    }
    
    func refreshIdtoken() {
        checkIdtoken()
            .subscribe(with: self) { vc, statusCode in
                print("들어옴")
                vc.commonSerVerModel.UserInfoNetwork(idtoken: statusCode)
            } onFailure: { vc, error in
                print("들어옴2")
                FirebaseManager.shared.getIDTokenForcingRefresh()
                vc.checkIdtoken().retry(when: { error in
                    error.flatMap { _ in
                      Observable<Int>
                        .timer(.seconds(3), period: nil, scheduler: MainScheduler.asyncInstance)
                    }
                  })
                  .subscribe()
                  .disposed(by: vc.bag)
            }.disposed(by: bag)
        print("들어옴1")
    }
    
}
