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
        view.numberOfLines = 0
        view.setBaseLabelStatus(fontsize: 20, font: .Display1_R20, lineHeight: 1.6, view.text!)
        view.textAlignment = .center
        view.textColor = .setBaseColor(color: .black)
        return view
    }()
    
    let subTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "테스트 서브타이틀입니다"
        view.setBaseLabelStatus(fontsize: 16, font: .title2_R16, lineHeight: 1.6, view.text!)
        view.textAlignment = .center
        view.textColor = .setBaseColor(color: .black)
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
        config.baseForegroundColor = .black
        config.image = UIImage(named: "man")
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
        config.baseForegroundColor = .black
        config.image = UIImage(named: "woman")
        config.imagePlacement = .top
        config.imagePadding = 0

        view.configuration = config
        
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
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 12
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .setBaseColor(color: .white)
        setcontents(type: .gender, label: titleLabel, button: nextButton, subtitle: subTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        
        [manButton, womanButton].forEach { stackView.addArrangedSubview($0) }
        [titleLabel, subTitleLabel, stackView, nextButton].forEach {
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
            make.bottom.equalTo(stackView.snp.top).offset(-76)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(-32)
            make.height.equalTo(120)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(self.snp.centerY)
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
}
