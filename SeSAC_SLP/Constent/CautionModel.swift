//
//  CautionModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit
import Toast

//MARK: Toast 모델 만드려고했는데 다른 뷰컨에서 임포트를 안해도 잘 작도하네..?
//final class CustomToast {
//
//    static let shared = CustomToast()
//
//    private init() { }
//
//    func showDefaultToast(message: AuthVerifyPhoneNumber) {
//
//        let scenes = UIApplication.shared.connectedScenes
//        let windowScene = scenes.first as? UIWindowScene
//        guard let window = windowScene?.windows.first else { return }
//
//        guard let topView = window.subviews.first else {
//            print(#file, "토스트 메세지 띄울 수 없음 🔴")
//            return
//        }
//
//        topView.makeToast(message.message, duration: duration, position: position)
//    }
//}

extension UIViewController {
    func showDefaultToast(message: CustomAuth, completion: (() -> Void)? = nil) {
        var style = ToastStyle()
         style.backgroundColor = .systemGray3
         style.messageColor = .white
        
        switch message {
        case .AuthVerifyPhoneNumber(let phoneNum):
            view.makeToast(phoneNum.message, duration: 1, position: .center, style: style)
        case .AuthCredentialText(let credential):
            view.makeToast(credential.message, duration: 1, position: .center, style: style)
        case .SignUpError(let error):
            view.makeToast(error.message, duration: 1, position: .center)
        }
    }
}
