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
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    LoadingIndicator.hideLoading()
                    print("success🥰🥰")
                    resultMessage(.success)
                }
            }
    }
}

