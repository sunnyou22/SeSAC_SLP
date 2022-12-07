//
//  SesacCollectionViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/05.
//

import UIKit

class SesacCollectionViewCell: BaseCollectionViewCell {
    let sesac: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "searchPlaceholder")
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        view.layer.borderColor = UIColor.setGray(color: .gray3).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let nameLbl: UILabel = {
        let view = UILabel()
        view.text = "준비중"
        view.font = .title2_R16
        view.textColor = .setBaseColor(color: .black)
        return view
    }()
    
    lazy var priceBtn: UIButton = {
        let view = UIButton()
        view.setTitle("8,888", for: .normal)
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.buttonSize = .mini
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.title5_M12
            return outgoing
           }
        config.baseBackgroundColor = .setGray(color: .gray7)
        config.baseForegroundColor = .setBaseColor(color: .white)
        view.configuration = config
        //이것도 됨
//        DispatchQueue.main.async {
//            view.clipsToBounds = true
//            view.layer.cornerRadius = view.frame.size.height / 2
//        }
        return view
        
    }()
    
    let explanation: UILabel = {
        let view = UILabel()
        view.text = "아직 자라나지 않는 새싹자리입니다. 조금만 더 기다려주세요!"
        view.font = .Body3_R14
        view.textColor = .setBaseColor(color: .black)
        view.numberOfLines = 0
        return view
    }()
    
    override func configure() {
        [sesac, nameLbl, priceBtn, explanation].forEach { contentView.addSubview($0) }
    }
    
    override func setUpConstraints() {
        sesac.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
            make.centerX.equalToSuperview()
        }
        
        nameLbl.snp.makeConstraints { make in
            make.top.equalTo(sesac.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.width.lessThanOrEqualTo(contentView.snp.width).dividedBy(2)
        }
        
        priceBtn.snp.makeConstraints { make in
            make.top.equalTo(sesac.snp.bottom).offset(8)
            make.trailing.equalTo(sesac.snp.trailing).offset(-8)
            make.centerY.equalTo(nameLbl.snp.centerY)
            make.width.lessThanOrEqualTo(contentView.snp.width).dividedBy(2)
        }
        
        explanation.snp.makeConstraints { make in
            make.top.equalTo(priceBtn.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(sesac.snp.horizontalEdges)
        }
    }
}
