//
//  VerificationViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/08.
//

import UIKit

class VerificationViewController: BaseViewController {

    var mainView = VerificationView()

    override func loadView() {
        super.loadView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.nextButton.addTarget(self, action: #selector(goReceiveVerificationNumView), for: .touchUpInside)
    }

    @objc func goReceiveVerificationNumView() {
        let vc = NicknameViewController()
        transition(vc, .push)
    }
}

