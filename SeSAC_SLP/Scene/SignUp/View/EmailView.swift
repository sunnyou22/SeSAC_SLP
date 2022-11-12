//
//  EmailView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/08.
//

import UIKit

import SnapKit

final class EmailView: BaseView {
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "테스트 타이틀입니다"
        view.numberOfLines = 0
        view.setBaseLabelStatus(fontsize: 20, font: .Display1_R20!, lineHeight: 1.6, view.text!)
        view.textAlignment = .center
        view.textColor = .setBaseColor(color: .black)
        return view
    }()
    
    let subTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "테스트 서브타이틀입니다"
        view.numberOfLines = 0
        view.setBaseLabelStatus(fontsize: 16, font: .title2_R16!, lineHeight: 1.6, view.text!)
        view.textAlignment = .center
        view.textColor = .setBaseColor(color: .black)
        return view
    }()
    
    let inputTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "SeSAC@email.com"
        view.textAlignment = .left
        view.keyboardType = .default
        view.textColor = .setBaseColor(color: .black)
        view.becomeFirstResponder()
//        view.text = 하이픈으로 구분해주는 기능넣기
        return view
    }()
    
    let textFieldSectionBar: UIView = {
       let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    let nextButton: UIButton = {
        let view = UIButton()
        view.setTitle(literalString.nextButton.title(vc: .first), for: .normal)
        view.backgroundColor = .setBrandColor(color: .green)
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .setBaseColor(color: .white)
        setcontents(type: .email, label: titleLabel, button: nextButton, subtitle: subTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [titleLabel, subTitleLabel, inputTextField, textFieldSectionBar, nextButton].forEach {
            self.addSubview($0)
        }
        self.backgroundColor = .white
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(subTitleLabel.snp.top).offset(-8)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(inputTextField.snp.top).offset(-76)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        inputTextField.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(-76)
            make.leading.equalTo(self.snp.leading).offset(28)
        }
        
        textFieldSectionBar.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(12)
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(self.snp.centerY)
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
}
