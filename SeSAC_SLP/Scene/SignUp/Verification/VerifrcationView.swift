//
//  VerifrcationView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/08.
//


import UIKit

import SnapKit

final class VerificationView: BaseView {
    
   lazy var loadingBar: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
       view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
       view.center = self.center
       view.color = UIColor.red
       view.hidesWhenStopped = true
       view.style = UIActivityIndicatorView.Style.medium
       view.stopAnimating()
       return view
    }()
    
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
        view.backgroundColor = .setGray(color: .gray3)
        return view
    }()
    
    let countingLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .setBaseColor(color: .white)
        view.textColor = .setBrandColor(color: .green)
        view.text = "88:88"
        return view
    }()

    let rePostButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .setBrandColor(color: .green)
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        return view
    }()

    let nextButton: UIButton = {
        let view = UIButton()
        view.setTitle(literalString.nextButton.title(vc: .first), for: .normal)
        view.backgroundColor = .setGray(color: .gray6)
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
