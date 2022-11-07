//
//  ViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/07.
//

import UIKit

import FirebaseAuth
import Messages

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") // 이 부분 이해하기
        let phoneNumber = "571552104"
        Auth.auth().languageCode = "kr"
        PhoneAuthProvider.provider()
            .verifyPhoneNumber("+82 \(phoneNumber)", uiDelegate: nil) { (verificationID, error) in
                if let id = verificationID {
                    UserDefaults.standard.set("\(id)", forKey: "authVerificationID")
                }
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
    }
}

