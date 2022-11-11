//
//  SignUpViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/09.
//

import RxCocoa
import RxSwift
import Alamofire
import Foundation

final class SignUpViewModel {
    static var test: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let signup = PublishSubject<SignUp>()
    let login = PublishSubject<LogIn>()
    let textfield: BehaviorRelay<String> = BehaviorRelay(value: "")
    var buttonValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var nextbutton: ControlEvent<Void>?
    
    //MARK: 닉네임
    
    
    func signUpNetwork(nick: String, FCMtoken: String, phoneNumber: String, birth: Date, email: String, gender: Int, idtoken: String, completion: @escaping ((Error) -> Void)) {
        
        let api = SeSACAPI.signUp(phoneNumber: phoneNumber, FCMtoken: FCMtoken, nick: nick, birth: birth, email: email, gender: gender)
        
        Network.shared.requestSeSAC(type: SignUp.self, url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { [weak self] response in
            
            switch response {
            case .success(let success):
                self?.signup.onNext(success) // 구조체안에 데이터를 넣음
            case .failure(let failure):
                self?.signup.onError(failure) // 에러에 맞게 밷틈 SeSAC_SLP.SignUpError.InvaliedNickName
                completion(failure)
            }
        }
    }
    
    func logInNetwork(phoneNumber: String, idtoken: String, completion: @escaping ((Error) -> Void)) {
        let api = SeSACAPI.logIn(phoneNumber: phoneNumber)
        
        Network.shared.requestSeSAC(type: LogIn.self, url: api.url, parameter: nil, method: .get, headers: api.getheader(idtoken: idtoken)) { [weak self] response in
            switch response {
            case .success(let success):
            print("나 성공")
                self?.login.onNext(success)
            case .failure(let failure):
                self?.login.onError(failure)
                completion(failure)
            }
        }
    }
}


