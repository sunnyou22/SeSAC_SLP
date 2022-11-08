//
//  NicknameViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/09.
//

import UIKit

class NicknameViewController: BaseViewController {

    var mainView = SignUpView()

    override func loadView() {
        super.loadView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .setBaseColor(color: .white)
        mainView.setcontents(type: .first, label: mainView.titleLabel, button: mainView.nextButton, subtitle: nil)
        mainView.nextButton.addTarget(self, action: #selector(goReceiveVerificationNumView), for: .touchUpInside)
    }

    @objc func goReceiveVerificationNumView() {
        let vc = BirthDayViewController()
        transition(vc, .push)
    }
}

