//
//  EmailViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/09.
//

import UIKit

class EmailViewController: BaseViewController {

    var mainView = EmailView()

    override func loadView() {
        super.loadView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.nextButton.addTarget(self, action: #selector(goReceiveVerificationNumView), for: .touchUpInside)
    }

    @objc func goReceiveVerificationNumView() {
        let vc = GenderViewController()
        transition(vc, .push)
    }
}

