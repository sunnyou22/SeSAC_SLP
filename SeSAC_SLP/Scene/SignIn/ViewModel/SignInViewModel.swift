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
    let autoUserStaus = PublishRelay<SignUpError>()
    let transitionEvent = PublishRelay<SignUpError>()
    
    //MARK: 로그인화면 -
    
    //2. 텍스트필드 입력 이벤트 감지 -> 옵저버에게 알림
    func changePattern(num: String) {
        textfield.accept(num.applyPatternOnNumbers(pattern: "###-####-####", replacmentCharacter: "#"))
    }
    
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
        UserDefaults.phoneNumber = String(result)
        print(result, String(result), "😵‍💫😵‍💫😵‍💫😵‍💫")
       return String(result)
    }
    
    //MARK: 번호 인증 화면 -
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
        // error코드화면전화테스트
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
    
    func getNetwork() {
        guard let DBidtoken = UserDefaults.idtoken else {
            print("🔴 Idtoken 없음", #function)
            return
        }
       logInNetwork(idtoken: DBidtoken)
    }
    
    //MARK: 공유 메서드 -
    func networkWithFireBase(num: String) {
      let rawnum = changeTextfieldPattern(num: num)
        FirebaseManager.shared.verifyPhoneNumber(rawnum) { [weak self] response in
            switch response {
            case .success:
                self?.authPhoneNumResult.accept(.success)
            case .otherError:
                self?.authPhoneNumResult.accept(.otherError)
            case .invalidPhoneNumber:
                self?.authPhoneNumResult.accept(.invalidPhoneNumber)
            case .tooManyRequests:
                self?.authPhoneNumResult.accept(.tooManyRequests)
            }
        }
    }
    
    //MARK: 닉네임 - 파일매니저로 뺄건지 고민
    func signUpNetwork(nick: String, FCMtoken: String, phoneNumber: String, birth: Date, email: String, gender: Int, idtoken: String, completion: @escaping ((Error) -> Void)) {
        
        let api = SeSACAPI.signUp(phoneNumber: phoneNumber, FCMtoken: FCMtoken, nick: nick, birth: birth, email: email, gender: gender)
        
        Network.shared.requestSeSAC(type: SignUp.self, url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { response in
            LoadingIndicator.showLoading()
            switch response {
            case .success(let success):
                print(success)
                print("회원가입성공 ✅")
                LoadingIndicator.hideLoading()
//                self?.signup.onNext(success) // 구조체안에 데이터를 넣음
            case .failure(let failure):
                print("회원가입 에러 🔴")
                LoadingIndicator.hideLoading()
//                self?.signup.onError(failure) // 에러에 맞게 밷틈 SeSAC_SLP.SignUpError.InvaliedNickName
                completion(failure)
            }
        }
    }
    
    func logInNetwork(idtoken: String)  {
        let api = SeSACAPI.logIn
        
        Network.shared.requestSeSAC(type: LogIn.self, url: api.url, parameter: nil, method: .get, headers: api.getheader(idtoken: idtoken)) { [weak self] response in
            
            LoadingIndicator.showLoading()
            
            switch response {
            case .success(let success):
                print("로그인 성공 ✅", success)
                //                self?.login.onNext(success)
                LoadingIndicator.hideLoading()
                
                guard UserDefaults.phoneNumber != nil else {
                    self?.autoUserStaus.accept(.Success)
                    
                    return
                }
                self?.autoUserStaus.accept(.SignInUser)
                
            case .failure(let failure):
                
                switch failure {
                case SignUpError.FirebaseTokenError:
                    LoadingIndicator.hideLoading()
                    print(#function, "idtoken만료 🔴", failure)
                    guard let DBitoken = FirebaseManager.shared.getIDTokenForcingRefresh() else { return }
                    UserDefaults.idtoken = DBitoken
                    self?.autoUserStaus.accept(.FirebaseTokenError)
                    
                case SignUpError.NotsignUpUser:
                    LoadingIndicator.hideLoading()
                    guard let DBitoken = FirebaseManager.shared.getIDTokenForcingRefresh() else { return }
                    UserDefaults.idtoken = DBitoken
                    self?.autoUserStaus.accept(.NotsignUpUser)
                default:
                    LoadingIndicator.hideLoading()
                   print("🔴 기타 에러, \(failure)")
                }
                //                self?.login.onError(failure)
            }
        }
    }
}


