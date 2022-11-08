//
//  GenderView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/08.
//

import UIKit

final class GenderView: BaseView {
    
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
    
    let manButton: UIButton = {
        let view = UIButton()
        view.tag = 1
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        view.layer.borderColor = UIColor.setGray(color: .gray3).cgColor
        view.layer.borderWidth = 1
      
// ✅ Configuration.
        var config = UIButton.Configuration.plain()
        config.title = "남자"
        config.image = UIImage(systemName: "man")
        config.imagePlacement = .top
        config.imagePadding = 0

        view.configuration = config
        
        return view
    }()
    
    let womanButton: UIButton = {
        let view = UIButton()
        view.tag = 1
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        view.layer.borderColor = UIColor.setGray(color: .gray3).cgColor
        view.layer.borderWidth = 1
// ✅ Configuration.
        var config = UIButton.Configuration.plain()
        config.title = "여자"
        config.image = UIImage(systemName: "woman")
        config.imagePlacement = .top
        config.imagePadding = 0

        view.configuration = config
        
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
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 12
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
        [titleLabel, subTitleLabel, manButton, womanButton, nextButton].forEach {
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
            make.height.equalTo(120)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(32)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(32)
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
}
