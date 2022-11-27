//
//  StartMatchingCollectionViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/26.
//

import UIKit

class StartMatchingCollectionViewCell: BaseTableViewCell {
    
    let cardView: CardView = {
        let view = CardView()
        view.backgroundColor = .green
        return view
    }()
    
    let requestButton: UIButton = {
        let view = UIButton()
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        view.titleLabel?.font = UIFont.title3_M14
        return view
    }()
    
    override func configure() {
        
        [cardView, requestButton].forEach { contentView.addSubview($0) }
        self.backgroundColor = .darkGray
//        cardView.nicknameView.toggleButton.addTarget(self, action: #selector(test), for: .touchUpInside)
 
       requestButton.addTarget(self, action: #selector(request), for: .touchUpInside)
        
        
        // 1. create a gesture recognizer (tap gesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        
        cardView.nicknameView.addGestureRecognizer(tapGesture)
    }
    

// 3. this method is called when a tap is recognized
@objc func handleTap(sender: UITapGestureRecognizer) {
    print("tap")
}
    @objc func request() {
        print("버튼 눌리야?")
    }
    
    
    
    override func setUpConstraints() {
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        requestButton.snp.makeConstraints { make in
            make.trailing.equalTo(cardView.snp.trailing).offset(-12)
            make.top.equalTo(cardView.snp.top).offset(12)
            make.width.equalTo(80)
            make.height.equalTo(requestButton.snp.width).dividedBy(2)
        }
    }
}

