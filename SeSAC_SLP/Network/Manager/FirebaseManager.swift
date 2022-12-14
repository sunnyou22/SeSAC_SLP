//
//  FirebaseManager.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import Foundation

import FirebaseAuth
import RxSwift

final class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    private init() { }
    
    //idtoken ☑️
    func verifyPhoneNumber(_ num: String, resultMessage: @escaping ((AuthVerifyPhoneNumber) -> Void)) {
        Auth.auth().languageCode = "kr"
        PhoneAuthProvider.provider()
            .verifyPhoneNumber("+82\(num)", uiDelegate: nil) { (verificationID, error) in
                UserDefaults.phoneNumber = "+82\(num)"
                if let error = error {
                    switch error {
                        // 에러 종류별로 뱉
                    case AuthErrorCode.invalidPhoneNumber:
                        resultMessage(.invalidPhoneNumber)
                    case AuthErrorCode.tooManyRequests:
                        resultMessage(.tooManyRequests)
                    default:
                        resultMessage(.otherError)
                    }
                    print(error.localizedDescription, error, "🥲😡")
                    return
                } else {
                    UserDefaults.authVerificationID = verificationID!
                    print("success🥰🥰")
                    resultMessage(.success)
                }
            }
    }
    
    //idtoken ✅ Or ☑️
    func credential(text: String, autoResult: @escaping ((AuthCredentialText) -> Void)) {
        // error코드화면전화테스트
        let verificationID = UserDefaults.authVerificationID // 파베에서 번호인증을 먼저해야함
        let verificationCode = text
        print(verificationID,"✖️", verificationCode, "🔓", #function, UserDefaults.authVerificationID)
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        print("===========", #function)
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            
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
                
                self?.getIDTokenForcingRefresh() // 인증아이디와 코드 일치 -> 토큰 겟겟
                
                autoResult(.success)
                print(result)
                print("Phone Number user is signed in \(String(describing: result?.user.uid))  ☎️✅")
            }
            
        }
        //        UserDefaults.
    }
    
    @discardableResult
    func getIDTokenForcingRefresh() -> Single<String> {
        return Single<String>.create { (single) -> Disposable in
            let currentUser = Auth.auth().currentUser
            currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                guard let idToken = idToken else { return }
                if let error = error {
                    print(error, "idtoken 못 받아옴")
                    single(.failure(error))
                    return
                }
                UserDefaults.idtoken = idToken
                single(.success(idToken))
            }
            return Disposables.create()
        }
    }
    
}
