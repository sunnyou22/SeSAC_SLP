//
//  SignInViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/09.
//

import Foundation

import RxCocoa
import RxSwift
import Alamofire
import FirebaseAuth

final class SignInViewModel {
    static var backToNicknameVC: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let textfield: BehaviorRelay<String> = BehaviorRelay(value: "")
    var buttonValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var nextbutton: ControlEvent<Void>?
    let authPhoneNumResult = PublishRelay<AuthVerifyPhoneNumber>()
    let authValidCode = PublishRelay<AuthCredentialText>()
    
    let userStatus = PublishRelay<UserStatus>()
    //    let transitionEvent = PublishRelay<SignUpError>()
    
    //MARK: 로그인화면 -
    
    //2. 텍스트필드 입력 이벤트 감지 -> 옵저버에게 알림
    func changePattern(num: String) {
        textfield.accept(num.applyPatternOnNumbers(pattern: "###-####-####", replacmentCharacter: "#"))
    }
    
    // 핸드폰번호 유효성검사
    func checkVaildPhoneNumber(text: String) {
        if (text.count == 13 && text.starts(with: "010")) || (text.count == 11 && text.starts(with: "011")) {
            buttonValid.accept(true)
        } else {
            buttonValid.accept(false)
        }
    }
    
  
    @discardableResult
    func changeTextfieldPattern(num: String) -> String {
        let rawnum = num.applyPatternOnNumbers(pattern: "###########", replacmentCharacter: "#")
        let result = rawnum.dropFirst(1)
        UserDefaults.phoneNumber = String(result) //+8210 형식으로 저장
        print(result, String(result), "😵‍💫😵‍💫😵‍💫😵‍💫")
        return String(result)
    }
    
    //MARK: - 번호 인증 화면
    // 6자리인 코드 확인
    func checkValidCode(text: String) {
        textfield.accept(text)
        if text.count == 6 {
            buttonValid.accept(true)
        } else {
            buttonValid.accept(false)
        }
    }
    
    func matchCredential() {
        // error코드화면전화테스트, 인증을 성공해야만 새로운 토큰값을 얻을 수 있음
        FirebaseManager.shared.credential(text: textfield.value) { response in
            switch response {
            case .missingVerificationID:
                self.authValidCode.accept(.missingVerificationID)
            case .invalidUserToken:
                self.authValidCode.accept(.invalidUserToken)
            case .invalidVerificationID:
                self.authValidCode.accept(.invalidVerificationID)
            case .otherError:
                self.authValidCode.accept(.otherError)
            case .success:
                self.authValidCode.accept(.success)
            }
        }
    }
    
    //MARK: 공유 메서드 -
    func networkWithFireBase(num: String) {
        let rawnum = changeTextfieldPattern(num: num)
        LoadingIndicator.showLoading()
        FirebaseManager.shared.verifyPhoneNumber(rawnum) { [weak self] response in
            switch response {
               
            case .success:
              
                self?.authPhoneNumResult.accept(.success)
            case .otherError:
                LoadingIndicator.hideLoading()
                self?.authPhoneNumResult.accept(.otherError)
            case .invalidPhoneNumber:
                LoadingIndicator.hideLoading()
                self?.authPhoneNumResult.accept(.invalidPhoneNumber)
            case .tooManyRequests:
                LoadingIndicator.hideLoading()
                self?.authPhoneNumResult.accept(.tooManyRequests)
            }
           
        }
    }
    
    
    func signUpNetwork(nick: String, FCMtoken: String, phoneNumber: String, birth: Date, email: String, gender: Int, idtoken: String) {
        
        let api = SeSACAPI.signUp(phoneNumber: phoneNumber, FCMtoken: FCMtoken, nick: nick, birth: birth, email: email, gender: gender)
        
        Network.shared.requestSeSAC(type: SignUp.self, url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { [weak self] data, statusCode  in
            
            guard let data = data else {
                print("회원가입 에러 🔴")
                guard let userStatus = UserStatus(rawValue: statusCode) else { return }
                
                switch userStatus {
                case .Success:
                    print("reponse를 정상적으로 받은 뒤 에러 🔴")
                    self?.userStatus.accept(.Success)
                case .SignInUser:
                    self?.userStatus.accept(.SignInUser)
                case .InvaliedNickName:
                    self?.userStatus.accept(.InvaliedNickName)
                case .FirebaseTokenError:
                    FirebaseManager.shared.getIDTokenForcingRefresh()
                    self?.userStatus.accept(.FirebaseTokenError)
                case .NotsignUpUser:
                    self?.userStatus.accept(.NotsignUpUser)
                case .ServerError:
                    self?.userStatus.accept(.ServerError)
                case .ClientError:
                    self?.userStatus.accept(.ClientError)
                }
                return
            }
            
            print(data)
            self?.userStatus.accept(.Success)
            print("회원가입성공 ✅")
        }
    }
}


