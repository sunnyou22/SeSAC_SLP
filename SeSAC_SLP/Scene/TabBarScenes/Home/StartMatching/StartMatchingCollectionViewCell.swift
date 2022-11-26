//
//  StartMatchingCollectionViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/26.
//

import UIKit

class StartMatchingCollectionViewCell: BaseCollectionViewCell {
    
    let cardView: CardView = {
        let view = CardView()
        view.backgroundColor = .green
        return view
    }()
    
    override func configure() {
        contentView.addSubview(cardView)
        self.backgroundColor = .darkGray
    }
    
    override func setUpConstraints() {
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
