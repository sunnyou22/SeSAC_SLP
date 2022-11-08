//
//  BirthDayViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/09.
//

import UIKit

class BirthDayViewController: BaseViewController {

    var mainView = PickerView()

    override func loadView() {
        super.loadView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.nextButton.addTarget(self, action: #selector(goReceiveVerificationNumView), for: .touchUpInside)
    }

    @objc func goReceiveVerificationNumView() {
        let vc = EmailViewController()
        transition(vc, .push)
    }
}

