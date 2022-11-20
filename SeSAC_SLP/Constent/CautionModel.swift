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
    
    func showDefaultToast(message: Message, completion: (() -> Void)? = nil) {
        var style = ToastStyle()
        style.backgroundColor = .systemGray3
        style.messageColor = .white
        
        switch message {
        case .AuthVerifyPhoneNumber(let phoneNum):
            view.makeToast(phoneNum.message, duration: 1, position: .center, style: style) { didTap in
                guard let tapCompletion = completion?() else {
                    return
                }
                tapCompletion
            }
        case .AuthCredentialText(let credential):
            view.makeToast(credential.message, duration: 1, position: .center, style: style) { didTap in
                guard let tapCompletion = completion?() else {
                    return
                }
                tapCompletion
            }
        case .QueueText(let error):
            view.makeToast(error.message, duration: 1, position: .center) { didTap in
                guard let tapCompletion = completion?() else {
                    return
                }
                tapCompletion
            }
      
        case .Signup(let error):
            view.makeToast(error.message, duration: 1, position: .center) { didTap in
                guard let tapCompletion = completion?() else {
                    return
                }
                tapCompletion
            }
            
        case .defaultQueueMessage(let error):
            view.makeToast(error.queuemessage, duration: 1, position: .center) { didTap in
                guard let tapCompletion = completion?() else {
                    return
                }
                tapCompletion
            }
            
        case .defaultSignupMessage(let error):
            view.makeToast(error.signupMessage, duration: 1, position: .center) { didTap in
                guard let tapCompletion = completion?() else {
                    return
                }
                tapCompletion
            }
        }
    }
    
    func showSelectedAlert(title: String?, message: String, okCompletion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "네", style: .default, handler: okCompletion)
        
        let cancel = UIAlertAction(title: "아니오", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
}


                            
