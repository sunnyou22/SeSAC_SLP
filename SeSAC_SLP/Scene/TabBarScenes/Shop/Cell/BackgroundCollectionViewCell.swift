//
//  BackgroundCollectionViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/06.
//

import UIKit

class BackgroundCollectionViewCell: BaseCollectionViewCell {
    
    let background: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "searchPlaceholder")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        return view
    }()
    
    let nameLbl: UILabel = {
        let view = UILabel()
        view.text = "준비중"
        view.font = .title3_M14
        view.textColor = .setBaseColor(color: .black)
        return view
    }()
    
    lazy var priceBtn: UIButton = {
        let view = UIButton()
        view.setTitle("8,888", for: .normal)
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.buttonSize = .small
        view.tintColor = .setGray(color: .gray7)
        view.configuration = config
        return view
    }()
    
    let explanation: UILabel = {
        let view = UILabel()
        view.text = "준비중인 배경 아이템입니다. 조금만 더 기다려주세요!"
        view.font = .Body3_R14
        view.textColor = .setBaseColor(color: .black)
        view.numberOfLines = 0
        return view
    }()
    
    let infoView = UIView()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [background, infoView])
        view.spacing = 16
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    override func configure() {
        [nameLbl, priceBtn, explanation].forEach { infoView.addSubview($0) }
        contentView.addSubview(stackView)
    }
    
    override func setUpConstraints() {
        nameLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }
        
        priceBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(nameLbl.snp.centerY)
        }
        
        explanation.snp.makeConstraints { make in
            make.top.equalTo(nameLbl.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        infoView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalTo(background.snp.trailing).offset(16)
        }
        
        background.snp.makeConstraints { make in
            make.height.width.equalTo(contentView.snp.height)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
