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
    
    override func prepareForReuse() {
    super.prepareForReuse()
        requestButton.removeTarget(nil, action: nil, for: .touchUpInside)
        cardView.nicknameView.gestureRecognizers?.forEach(cardView.nicknameView.removeGestureRecognizer(_:))

    }
    
}

