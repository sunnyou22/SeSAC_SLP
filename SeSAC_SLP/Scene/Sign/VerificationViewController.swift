//
//  VerificationViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/08.
//

import UIKit

//class VerificationViewController: BaseViewController {
//
//    var mainView = VerificationView()
//    var viewtype: BaseView
//
//    init(viewtype: BaseView) {
//        self.viewtype = viewtype
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func loadView() {
//        super.loadView()
//        view = mainView
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        mainView.nextButton.addTarget(self, action: #selector(goReceiveVerificationNumView), for: .touchUpInside)
//    }
//
//    @objc func goReceiveVerificationNumView() {
//        let vc = SignUpViewController(viewtype: .setCustomView(type: .nickname))
//        transition(vc, .push)
//    }
//}
//
