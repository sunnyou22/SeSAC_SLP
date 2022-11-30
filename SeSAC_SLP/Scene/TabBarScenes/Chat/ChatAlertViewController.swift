//
//  ChatAlertViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/30.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class ChatAlertViewController: BaseViewController {
    
    let viewModel = ChatViewModel() //test
    let bag = DisposeBag()
    
    let alertView: CustomAlertView = {
        let view = CustomAlertView()
        view.setattributeText(view: view.alertLbl, text: "스터디를 취소하시겠습니까?\n스터디를 취소하면 패널티가 부과됩니다", pointfont: .title1_M16!, subfont: .title4_R14!, location: 0, length: 11, baseColor: .setGray(color: .gray7), pointColor: .setBaseColor(color: .black))
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.backgroundColor = .setBaseColor(color: .white)
        return view
    }()
    
    override func configure() {
        view.addSubview(alertView)
    }
    
    override func setConstraints() {
        alertView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.center.equalToSuperview()
            make.height.equalToSuperview().dividedBy(4.4)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertView.okButton.addTarget(self, action: #selector(tapOkButton), for: .touchUpInside)
        alertView.okButton.addTarget(self, action: #selector(tapNoButton), for: .touchUpInside)
    }
    
    @objc func tapOkButton() {
        viewModel.dodge(otherID: "urCyfx9scGYW6hO7JUlsSeibxch1", idtoken: idToken)
    }
    
    @objc func tapNoButton() {
        dismiss(animated: true)
    }
}
