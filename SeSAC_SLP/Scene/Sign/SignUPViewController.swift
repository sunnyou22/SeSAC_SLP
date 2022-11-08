//
//  SignUPViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/07.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    var vc: Vc
    var viewtype: BaseView
    
    init(viewtype: BaseView, vc: Vc) {
        self.viewtype = BaseView.setCustomView(type: vc)
        self.vc = vc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = viewtype
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let first = Vc.first(viewtype)
        
        switch vc {
        case .first(let first)
            
            first.nextButton.addTarget(self, action: #selector(goReceiveVerificationNumView), for: .touchUpInside)
        case .second(let secondView):
            secondView.nextButton.addTarget(self, action: #selector(goReceiveVerificationNickNameView), for: .touchUpInside)
        case .nickname(let nickName):
            nickName.nextButton.addTarget(self, action: #selector(goSignUpBirthView), for: .touchUpInside)
        case .birthDay(let birthDay):
            birthDay.nextButton.addTarget(self, action: #selector(goSignUpEmailView), for: .touchUpInside)
        case .email(let emailView):
            emailView.nextButton.addTarget(self, action: #selector(goSignUpGenderView), for: .touchUpInside)
        case .gender(let gender):
            break
        }
    }
    
    @objc func goReceiveVerificationNumView() {
        let vc = SignUpViewController(viewtype: .setCustomView(type: .second), vc: .second)
        
        BaseView.setCustomView(type: vc)
        
        let view = viewtype.
        let view = viewtype as!
        
        vc.viewtype.setcontents(type: .second, view: vc.viewtype.titleLabel)
        transition(vc, .push)
    }
    
    @objc func goReceiveVerificationNickNameView() {
        let vc = SignUpViewController(viewtype: .setCustomView(type: .nickname), vc: .nickname)
        vc.mainView.setcontents(type: .nickname, view: vc.mainView.titleLabel)
        transition(vc, .push)
    }
    
    @objc func goSignUpBirthView() {
        let vc = SignUpViewController(viewtype: .setCustomView(type: .birthDay), vc: .birthDay)
        vc.mainView.setcontents(type: .birthDay, view: vc.mainView.titleLabel)
        transition(vc, .push)
    }
    
    @objc func goSignUpEmailView() {
        let vc = SignUpViewController(viewtype: .setCustomView(type: .email), vc: .email)
        vc.mainView.setcontents(type: .email, view: vc.mainView.titleLabel)
        transition(vc, .push)
    }
    
    @objc func goSignUpGenderView() {
        let vc = SignUpViewController(viewtype: .setCustomView(type: .gender), vc: .gender)
        vc.mainView.setcontents(type: .gender, view: vc.mainView.titleLabel)
        transition(vc, .push)
    }
}
