//
//  ChatTableViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/29.
//

import UIKit

class ChatTableViewCell: BaseTableViewCell {
    
    let messegeLbl: PaddingCutomLabel = {
        let view = PaddingCutomLabel(padding: UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
        
        let attributeString = "이건 테스트입니다.이건 테스트입니다.이건 테스트입니다.이건 테스트입니다.이건 테스트입니다.이건 테스트입니다.이건 테스트입니다.이건 테스트입니다.이건 테스트입니다."
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = .left
     
        let attributedText = NSAttributedString(
            string: attributeString,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.Body3_R14!
            ])
        
        view.textAlignment = .center
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.textColor = .green
        view.numberOfLines = 0
        
        view.attributedText = attributedText
//            .setBaseColor(color: .black)
        return view
    }()
    
    let timeLbl: UILabel = {
        let view = UILabel()
        view.text = "88:88"
        view.font = .title6_R12
        view.textColor = .setGray(color: .gray4)
        return view
    }()
    
    let containView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    override func configure() {
        [messegeLbl, timeLbl].forEach { containView.addSubview($0) }
        contentView.addSubview(containView)
    }
    
    override func setUpConstraints() {
        messegeLbl.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(contentView.frame.size.width * 3.5/4)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        timeLbl.snp.makeConstraints { make in
            make.leading.equalTo(messegeLbl.snp.trailing).offset(8)
            make.bottom.equalToSuperview()
        }
        containView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(timeLbl.snp.trailing)
            make.height.equalTo(messegeLbl.snp.height)
            make.verticalEdges.equalToSuperview()
        }
    }
}

class MyChatTableViewCell: ChatTableViewCell {
    
    override func configure() {
        [messegeLbl, timeLbl].forEach { containView.addSubview($0) }
        contentView.addSubview(containView)
        self.backgroundColor = .gray
    }
    
    override func setUpConstraints() {
        messegeLbl.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(contentView.frame.size.width * 3.5/4)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        timeLbl.snp.makeConstraints { make in
            make.trailing.equalTo(messegeLbl.snp.leading).offset(-8)
            make.bottom.equalToSuperview()
        }
        containView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(16)
            make.leading.equalTo(timeLbl.snp.leading)
            make.height.equalTo(messegeLbl.snp.height)
            make.verticalEdges.equalToSuperview()
        }
    }
}
