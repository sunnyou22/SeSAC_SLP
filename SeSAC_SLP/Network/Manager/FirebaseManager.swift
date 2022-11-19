//
//  FirebaseManager.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import Foundation

import FirebaseAuth

final class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    private init() { }
    
    //idtoken ☑️
    func verifyPhoneNumber(_ num: String, resultMessage: @escaping ((AuthVerifyPhoneNumber) -> Void)) {
        LoadingIndicator.showLoading()
        Auth.auth().languageCode = "kr"
        PhoneAuthProvider.provider()
            .verifyPhoneNumber("+82\(num)", uiDelegate: nil) { (verificationID, error) in
                UserDefaults.phoneNumber = "+82\(num)"
                if let error = error {
                    switch error {
                    case AuthErrorCode.invalidPhoneNumber:
                        LoadingIndicator.hideLoading()
                        resultMessage(.invalidPhoneNumber) // invalidPhoneNumber의 응답값이 들어오면 여기서 실행해줄고야~

                    case AuthErrorCode.tooManyRequests:
                        LoadingIndicator.hideLoading()
                        resultMessage(.tooManyRequests)
                        
                    default:
                        LoadingIndicator.hideLoading()
                        resultMessage(.otherError)
                    }
                    print(error.localizedDescription, error, "🥲😡")
                    return
                } else {
                    UserDefaults.authVerificationID = verificationID!
                    LoadingIndicator.hideLoading()
                    print("success🥰🥰")
                    resultMessage(.success)
                }
            }
    }
    
    //idtoken ✅
    func credential(text: String, autoResult: @escaping ((AuthCredentialText) -> Void)) {
        // error코드화면전화테스트
        let verificationID = UserDefaults.authVerificationID
        let verificationCode = text
        print(verificationID,"✖️", verificationCode, "🔓", #function)
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { result, error in
            
            if let error = error {
                
                switch error {
                case AuthErrorCode.missingVerificationID:
                    autoResult(.missingVerificationID)
                case AuthErrorCode.invalidVerificationID:
                    autoResult(.invalidVerificationID)
                case AuthErrorCode.invalidUserToken:
                    autoResult(.invalidUserToken)
                default:
                    autoResult(.missingVerificationID)
                }
                print("Unable to login with Phone : error[\(error)] 🔴")
                return
            } else {
                autoResult(.success)
                print("Phone Number user is signed in \(String(describing: result?.user.uid))  ☎️✅")
            }
            
        }
    }
    
    @discardableResult
    func getIDTokenForcingRefresh() -> String? {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print(error, "🔴 idtoken을 받아올 수 없습니다.")
                return
            } else {
                guard let idtoken = idToken else { return }
                UserDefaults.idtoken = idtoken
            }
        }
        return UserDefaults.idtoken
    }
}

