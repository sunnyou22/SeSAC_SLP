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
    
    
    func setcontents(type: Vc, view: UILabel) {
        switch type {
        case .first:
            return view.text = literalString.sceneTitle.title(vc: .first)
        case .second:
            return view.text = literalString.sceneTitle.title(vc: .second)
        case .nickname:
            return view.text = literalString.sceneTitle.title(vc: .nickname)
        case .birthDay:
            return view.text = literalString.sceneTitle.title(vc: .birthDay)
        case .email:
            return view.text = literalString.sceneTitle.title(vc: .email)
        case .gender:
            return view.text = literalString.sceneTitle.title(vc: .gender)
        }
    }
}

