//
//  VerifrcationView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/08.
//


import UIKit

import SnapKit

final class VerificationView: BaseView {
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "테스트제목입니다"
        view.numberOfLines = 0
        view.setBaseLabelStatus(fontsize: 20, font: .Display1_R20, lineHeight: 1.6, view.text!)
        view.textAlignment = .center
        return view
    }()
    
    let inputTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "test Textfield 입니다"
        view.textAlignment = .left
        view.keyboardType = .namePhonePad
//        view.text = 하이픈으로 구분해주는 기능넣기
        return view
    }()
    
    let textFieldSectionBar: UIView = {
       let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let countingLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .blue
        view.text = "88:88"
        return view
    }()

    let rePostButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .green
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        return view
    }()

    let nextButton: UIButton = {
        let view = UIButton()
        view.setTitle(literalString.nextButton.title(vc: .first), for: .normal)
        view.backgroundColor = .green
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .setBaseColor(color: .white)
        setcontents(type: .second, label: titleLabel, button: nextButton, subtitle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [titleLabel, rePostButton, inputTextField, countingLabel, textFieldSectionBar, nextButton].forEach {
            self.addSubview($0)
        }
        self.backgroundColor = .setBaseColor(color: .white)
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(inputTextField.snp.top).offset(-92)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        countingLabel.snp.makeConstraints { make in
            make.trailing.equalTo(rePostButton.snp.leading).offset(-20)
            make.centerY.equalTo(rePostButton.snp.centerY)
        }
        
        rePostButton.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(-76)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.width.equalTo(72)
            make.height.equalTo(40)
        }
        
        inputTextField.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(-76)
            make.leading.equalTo(self.snp.leading).offset(28)
            make.centerY.equalTo(rePostButton.snp.centerY)
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
