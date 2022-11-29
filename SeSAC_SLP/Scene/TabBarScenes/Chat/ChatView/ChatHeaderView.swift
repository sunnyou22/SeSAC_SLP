//
//  ChatHeaderView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/29.
//

import UIKit

class ChatHeaderView: UITableViewHeaderFooterView {
    
    let dataLabel: PaddingCutomLabel = {
        let view = PaddingCutomLabel()
        view.text = "0월 00일 일요일"
        view.setconfig(basecolor: .setGray(color: .gray7), textcolor: .setBaseColor(color: .white), font: .title5_M12!)
        return view
    }()
    
    let ment: UILabel = {
        let view = UILabel()
        
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
    
        imageAttachment.image = UIImage(systemName: "bell", withConfiguration: config)
        imageAttachment.bounds = CGRect(x: 0, y: 0, width: 16, height: 16)
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        attributedString.append(NSAttributedString(string: " 고래밥님과 매칭되었습니다", attributes: [ .foregroundColor: UIColor.setGray(color: .gray7), .font : UIFont.title3_M14!]))
        view.attributedText = attributedString
        view.sizeToFit()
        return view
    }()
    
    let subment: UILabel = {
        let view = UILabel()
        view.text = "채팅을 통해 약속을 정해보세요:)"
        view.font = .title4_R14
        view.textColor = .setGray(color: .gray6)
        return view
    }()

    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        [dataLabel, ment, subment].forEach { addSubview($0) }
    }
    
    func setConstraints() {
        dataLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        ment.snp.makeConstraints { make in
            make.top.equalTo(dataLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        subment.snp.makeConstraints { make in
            make.top.equalTo(ment.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
}
