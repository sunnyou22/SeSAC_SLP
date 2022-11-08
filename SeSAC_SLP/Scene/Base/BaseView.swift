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
    func Setcontents(type: CommonSignView, vc: Vc, view: UILabel) {
        switch type {
        case .verification:
            view.text = literalString.sceneTitle.title(vc: vc)
        case .signIn:
            view.text = literalString.sceneTitle.title(vc: vc)
            
        }
    }
}

