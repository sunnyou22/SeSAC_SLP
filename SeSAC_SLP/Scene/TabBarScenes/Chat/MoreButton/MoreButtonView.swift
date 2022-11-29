//
//  MoreButtonView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/30.
//

import UIKit

import SnapKit

final class MoreButtonView: BaseView {
    
    let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        view.isOpaque = false
        return view
    }()
    
    lazy var topCustomStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [reportButton, cancelButton, writeReviewButton])
        view.backgroundColor = .setBaseColor(color: .white)
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    let reportButton: ChatMenuButton = {
        let view = ChatMenuButton(frame: .zero)
        view.setDefault(title: Icon.ChatIcon.siren.title, imgname: Icon.ChatIcon.siren.rawValue)
        return view
    }()
    
    let cancelButton: ChatMenuButton = {
        let view = ChatMenuButton(frame: .zero)
        view.setDefault(title: Icon.ChatIcon.cancelmatch.title, imgname: Icon.ChatIcon.cancelmatch.rawValue)
        return view
    }()
    
    let writeReviewButton: ChatMenuButton = {
        let view = ChatMenuButton(frame: .zero)
        view.setDefault(title: Icon.ChatIcon.write.title, imgname: Icon.ChatIcon.write.rawValue)
        return view
    }()
    
    override func configure() {
        baseView.addSubview(topCustomStackView)
        addSubview(baseView)
        
        self.isHidden = true
    }
    
    override func setConstraints() {
        baseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topCustomStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(72)
            make.horizontalEdges.equalToSuperview()
        }
    }
}

