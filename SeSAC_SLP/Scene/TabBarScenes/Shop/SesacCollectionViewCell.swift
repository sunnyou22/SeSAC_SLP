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
        view.image = UIImage(named: Sesac_Face.sesac_face_1.rawValue)
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        view.layer.borderColor = UIColor.setGray(color: .gray3).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let nameLbl: UILabel = {
        let view = UILabel()
        view.text = "새싹이름"
        view.font = .title2_R16
        view.textColor = .setBaseColor(color: .black)
        return view
    }()
    
    lazy var priceBtn: UIButton = {
        let view = UIButton()
        view.setTitle("보유중", for: .normal)
        view.backgroundColor = .setGray(color: .gray2)
        view.tintColor = .setGray(color: .gray7)
        view.clipsToBounds = true
        view.layer.cornerRadius = view.frame.size.height / 2
        return view
    }()
    
    let explanation: UILabel = {
        let view = UILabel()
        view.text = "이건 설명입니다.이건 설명입니다.이건 설명입니다.이건 설명입니다.이건 설명입니다.이건 설명입니다.이건 설명입니다.이건 설명입니다."
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
        }
        
        priceBtn.snp.makeConstraints { make in
            make.trailing.equalTo(sesac.snp.trailing).offset(-8)
            make.centerY.equalTo(nameLbl.snp.centerY)
            make.width.equalTo(52)
            make.height.equalTo(20)
        }
        
        explanation.snp.makeConstraints { make in
            make.top.equalTo(priceBtn.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(sesac.snp.horizontalEdges)
        }
    }
}
