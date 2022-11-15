//
//  MyPageGenderView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit

import SnapKit

class MyPageGenderView: BaseView {
    
    let spacing: CGFloat = 56
    
    let title: UILabel = {
       let view = UILabel()
        view.text = "내 성별"
        return view
    }()
    
    lazy var manButton: UIButton = {
        let view = UIButton()
        view.setTitle("남자", for: .normal)
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        view.layer.borderColor = UIColor.setGray(color: .gray4).cgColor
        view.layer.borderWidth = 1
        view.frame.size.width = spacing
        return view
    }()
    
    lazy var womanButton: UIButton = {
        let view = UIButton()
        view.setTitle("여자", for: .normal)
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        view.layer.borderColor = UIColor.setGray(color: .gray4).cgColor
        view.layer.borderWidth = 1
        view.frame.size.width = spacing
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [manButton, womanButton].forEach { stackView.addArrangedSubview($0) }
        [title, stackView].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        title.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.leading.equalTo(self.snp.leading)
        }
        
        stackView.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(48)
            make.width.equalTo((spacing * 2) + 8)
        }
    }
}

