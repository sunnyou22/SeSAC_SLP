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
    
    override func configure() {
        contentView.addSubview(cardView)
        self.backgroundColor = .darkGray
        
//        cardView.nicknameView.toggleButton.addTarget(self, action: #selector(test), for: .touchUpInside)
    }
    
    override func setUpConstraints() {
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
//    @objc private func test() {
//        cardView.expandableView.isHidden = !cardView.expandableView.isHidden
//    }
}
