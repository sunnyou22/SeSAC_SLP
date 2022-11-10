//
//  SignUpViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/09.
//

import RxCocoa
import RxSwift
import Alamofire

class SignUpViewModel {
    let signup = PublishSubject<SignUp>()
    let login = PublishSubject<LogIn>()
    let textfield: BehaviorRelay<String> = BehaviorRelay(value: "")
    var buttonValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var nextbutton: ControlEvent<Void>?
    
    func signUpNetwork(nick: String, phoneNumber: String, birth: String, email: String, gender: Int, idtoken: String) {
        
        let api = SeSACAPI.signUp(nick: nick, phoneNumber: phoneNumber, birth: birth, email: email, gender: gender)
        
        Network.shared.requestSeSAC(type: SignUp.self, url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { [weak self] response in
            
            switch response {
            case .success(let success):
                self?.signup.onNext(success)
            case .failure(let failure):
                self?.signup.onError(failure)
            }
        }
    }
    
    func logInNetwork(phoneNumber: String, idtoken: String, completion: @escaping (() -> Void)) {
        let api = SeSACAPI.logIn(phoneNumber: phoneNumber)
        
        Network.shared.requestSeSAC(type: LogIn.self, url: api.url, method: .get, headers: api.getheader(idtoken: idtoken)) { [weak self] response in
            switch response {
            case .success(let success):
            print("나 성공")
                self?.login.onNext(success)
            case .failure(let failure):
                self?.login.onError(failure)
                completion()
            }
        }
    }
}


