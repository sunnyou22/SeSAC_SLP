//
//  BaseView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/07.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() { }
    func setConstraints() { }
    // 아니면 이니셜라이징
    func setcontents(type: Vc, label: UILabel, button: UIButton, subtitle: UILabel?) {
        switch type {
        case .first:
            label.text = literalString.sceneTitle.title(vc: .first)
            button.setTitle(literalString.nextButton.title(vc: .first), for: .normal)
        case .second:
            label.text = literalString.sceneTitle.title(vc: .second)
            button.setTitle(literalString.nextButton.title(vc: .second), for: .normal)
        case .nickname:
            label.text = literalString.sceneTitle.title(vc: .nickname)
            button.setTitle(literalString.nextButton.title(vc: .nickname), for: .normal)
        case .birthDay:
            label.text = literalString.sceneTitle.title(vc: .birthDay)
            button.setTitle(literalString.nextButton.title(vc: .birthDay), for: .normal)
        case .email:
            label.text = literalString.sceneTitle.title(vc: .email)
            button.setTitle(literalString.nextButton.title(vc: .email), for: .normal)
            subtitle?.text = literalString.subTitle.title(vc: .email)
        case .gender:
            label.text = literalString.sceneTitle.title(vc: .gender)
            button.setTitle(literalString.nextButton.title(vc: .email), for: .normal)
            subtitle?.text = literalString.subTitle.title(vc: .gender)
        }
    }
    
    func setattributeText(view: UILabel, text: String, location: Int = 0, length: Int = 0, baseColor: UIColor, pointColor: UIColor) -> UILabel {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        view.textColor = .black
        view.numberOfLines = 0
        
        let attributeString = text
        let attributeText = attributeString.setFullAttributed(color: baseColor, paragraphStyle: paragraphStyle)
        
        attributeText.addAttributes([
            .font : UIFont(name: "NotoSansKR-Medium", size: 24)!, .foregroundColor : pointColor], range: NSRange(location: location, length: length))
        
        view.attributedText = attributeText
        
        return view
    }
}

