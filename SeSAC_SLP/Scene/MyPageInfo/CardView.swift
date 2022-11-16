//
//  CardView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/16.
//

import Foundation
import UIKit
import SnapKit

class CardView: BaseView {
    let header = Header()
    let nicknameView = CardViewNickName()
    let expandableView = CardViewTitleAndReview()
    
    let borderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.setGray(color: .gray2).cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [nicknameView, expandableView])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        nicknameView.backgroundColor = .red
        expandableView.backgroundColor = .brown
        
        [header, stackView].forEach { self.addSubview($0) }
        borderView.addSubview(stackView)
    }
    
    override func setConstraints() {
        header.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(header.snp.width).multipliedBy(0.57)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top)
        }
        
        borderView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        nicknameView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(60)
            make.trailing.leading.equalToSuperview()
        }
        
        expandableView.snp.makeConstraints { make in
            make.top.equalTo(nicknameView.snp.bottom)
            make.centerX.equalToSuperview()
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
