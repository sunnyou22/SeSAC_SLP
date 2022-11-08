//
//  SignUPViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/07.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    let vc: Vc
    var mainView = SignUpView()
    var viewtype: BaseView
    
    init(viewtype: BaseView, vc: Vc) {
        self.viewtype = viewtype
        self.vc = vc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        switch vc {
        case .first:
            mainView.nextButton.addTarget(self, action: #selector(goReceiveVerificationNumView), for: .touchUpInside)
        case .second:
            mainView.nextButton.addTarget(self, action: #selector(goReceiveVerificationNickNameView), for: .touchUpInside)
        case .nickname:
            break
        case .birthDay:
            break
        case .email:
            break
        case .gender:
            break
        }
    }
    
    @objc func goReceiveVerificationNumView() {
        let vc = SignUpViewController(viewtype: .setCustomView(type: .second), vc: .second)
        vc.mainView.setcontents(type: .second, view: vc.mainView.titleLabel)
        transition(vc, .push)
    }
    
    @objc func goReceiveVerificationNickNameView() {
        let vc = SignUpViewController(viewtype: .setCustomView(type: .nickname), vc: .nickname)
        vc.mainView.setcontents(type: .nickname, view: vc.mainView.titleLabel)
        transition(vc, .push)
    }
}
