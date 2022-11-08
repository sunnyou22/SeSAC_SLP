//
//  GenderViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/09.
//

import Foundation

class GenderViewController: BaseViewController {

    var mainView = GenderView()

    override func loadView() {
        super.loadView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        mainView.nextButton.addTarget(self, action: #selector(goReceiveVerificationNumView), for: .touchUpInside)
    }

//    @objc func goReceiveVerificationNumView() {
//        let vc = Nick
//        transition(vc, .push)
//    }
}

