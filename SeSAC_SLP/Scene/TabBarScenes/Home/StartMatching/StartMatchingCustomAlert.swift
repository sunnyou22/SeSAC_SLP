//
//  StartMatchingCustomAlert.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/28.
//

import UIKit

import SnapKit

class StartMatchingCustomAlert: BaseViewController {

    var type: StartMatcingViewController.Vctype
    let alertView: CustomAlertView = {
        let view = CustomAlertView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.backgroundColor = .setBaseColor(color: .white)
        return view
    }()
    
    init(type: StartMatcingViewController.Vctype) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
}

class CustomAlertView: BaseView {
    let okButton: CutsomButton = {
        let view = CutsomButton(customtype: .defaultOk)
        view.defaultSetting()
        return view
    }()
    
    let noButton: CutsomButton = {
        let view = CutsomButton(customtype: .defaultNo)
        view.defaultSetting()
        return view
    }()
    
    lazy var alertLbl: UILabel = {
        let view = UILabel()
        return setattributeText(view: view, text: "스터디를 요청할게요!\n요청이 수락되면 30분 후에 리뷰를 남길 수 있어요", pointfont: .title1_M16!, subfont: .title4_R14!, location: 0, length: 11, baseColor: .setGray(color: .gray7), pointColor: .setBaseColor(color: .black))
    }()
    
    lazy var buttonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [noButton, okButton])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    
    lazy var totalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [alertLbl, buttonStackView])
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 16
        return view
    }()
    
    override func configure() {
        self.addSubview(totalStackView)
    }
    
    override func setConstraints() {
        totalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}
