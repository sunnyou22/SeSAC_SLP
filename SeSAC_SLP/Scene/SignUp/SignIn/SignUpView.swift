//
//  SignView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/07.
//

import UIKit

import SnapKit

final class SignUpView: BaseView {
    
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
        view.text = "테스트제목입니다. SignUpView"
        view.numberOfLines = 0
        view.setBaseLabelStatus(fontsize: 20, font: .Display1_R20, lineHeight: 1.6, view.text!)
        view.textAlignment = .center
        
        return view
    }()
    
    let inputTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "휴대폰 번호(-없이 숫자만 입력)" // 닉네임 뷰랑 구분해서 넣기
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
    
    lazy var nextButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .setGray(color: .gray6)
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .setBaseColor(color: .white)
        setcontents(type: .first, label: titleLabel, button: nextButton, subtitle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [titleLabel, inputTextField, textFieldSectionBar, nextButton].forEach {
            self.addSubview($0)
        }
        self.backgroundColor = .white
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(inputTextField.snp.top).offset(-92)
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
    
    func setInputTextField() {
        inputTextField.becomeFirstResponder()
        inputTextField.keyboardType = .default
    }
}
