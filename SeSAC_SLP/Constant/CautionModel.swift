//
//  CautionModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit
import Toast

extension UIViewController {
    
    func showDefaultToast(message: TestMessage, completion: (() -> Void)? = nil) {
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
            
            // massage 오타수정하기
        case .StudyRequestStatus(let status):
            view.makeToast(status.massage
                           , duration: 1, position: .bottom) { didTap in
                guard let tapCompletion = completion?() else {
                    return
                }
                tapCompletion
            }
        case .StudyAcceptedStatus(let status):
            view.makeToast(status.massage
                           , duration: 1, position: .bottom) { didTap in
                guard let tapCompletion = completion?() else {
                    return
                }
                tapCompletion
            }
        case .DeleteStatus(let status):
            view.makeToast(status.massage
                           , duration: 1, position: .bottom) { didTap in
                guard let tapCompletion = completion?() else {
                    return
                }
                tapCompletion
            }
        case .ReceiptValidationStatus(let status):
            view.makeToast(status.message
                           , duration: 1, position: .center) { didTap in
                guard let tapCompletion = completion?() else {
                    return
                }
                tapCompletion
            }
        }
    }
}



