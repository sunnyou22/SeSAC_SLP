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
        return view
    }()
    
    let subTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "테스트 서브타이틀입니다"
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

    let nextButton: UIButton = {
        let view = UIButton()
        view.setTitle(literalString.nextButton.title(vc: .first), for: .normal)
        view.backgroundColor = .setBaseColor(color: .white)
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
            make.top.equalTo(self.safeAreaLayoutGuide).offset(124)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(76)
            make.leading.equalTo(self.snp.leading).offset(28)
        }
        
        textFieldSectionBar.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(12)
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(textFieldSectionBar.snp.bottom).offset(72)
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
}
