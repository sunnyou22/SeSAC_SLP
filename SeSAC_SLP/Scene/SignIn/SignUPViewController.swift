//
//  SignUPViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/07.
//

import UIKit

class SignUpViewController: BaseViewController {
    
  var mainView = SignUpView()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            mainView.nextButton.addTarget(self, action: #selector(goReceiveVerificationNumView), for: .touchUpInside)
//        case .second(let secondView):
//            secondView.nextButton.addTarget(self, action: #selector(goReceiveVerificationNickNameView), for: .touchUpInside)
//        case .nickname(let nickName):
//            nickName.nextButton.addTarget(self, action: #selector(goSignUpBirthView), for: .touchUpInside)
//        case .birthDay(let birthDay):
//            birthDay.nextButton.addTarget(self, action: #selector(goSignUpEmailView), for: .touchUpInside)
//        case .email(let emailView):
//            emailView.nextButton.addTarget(self, action: #selector(goSignUpGenderView), for: .touchUpInside)
//        case .gender(let gender):
//            break
        }

    
    @objc func goReceiveVerificationNumView() {
        let vc = VerificationViewController()
        transition(vc, .push)
    }
    
//    @objc func goReceiveVerificationNickNameView() {
//        let vc = SignUpViewController(viewtype: .setCustomView(type: .nickname), vc: .nickname)
//        vc.mainView.setcontents(type: .nickname, view: vc.mainView.titleLabel)
//        transition(vc, .push)
//    }
//
//    @objc func goSignUpBirthView() {
//        let vc = SignUpViewController(viewtype: .setCustomView(type: .birthDay), vc: .birthDay)
//        vc.mainView.setcontents(type: .birthDay, view: vc.mainView.titleLabel)
//        transition(vc, .push)
//    }
//
//    @objc func goSignUpEmailView() {
//        let vc = SignUpViewController(viewtype: .setCustomView(type: .email), vc: .email)
//        vc.mainView.setcontents(type: .email, view: vc.mainView.titleLabel)
//        transition(vc, .push)
//    }
//
//    @objc func goSignUpGenderView() {
//        let vc = SignUpViewController(viewtype: .setCustomView(type: .gender), vc: .gender)
//        vc.mainView.setcontents(type: .gender, view: vc.mainView.titleLabel)
//        transition(vc, .push)
//    }
}
