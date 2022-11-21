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
    //✅
    func getIDTokenForcingRefresh() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            print("들어가기전")
            if let error = error {
                print(error, "🔴 idtoken을 받아올 수 없습니다.")
                return
            } else {
            print("itoken🐭🐭", idToken)
                UserDefaults.idtoken = idToken // 유저디폴츠에 새로운 토큰 담기
                print(UserDefaults.idtoken, "🐭🐭🐭🔴🔴🔴🔴🐭🐭")
            }
            print("나옴") //Currentuser가 없어
        }
    }
}

