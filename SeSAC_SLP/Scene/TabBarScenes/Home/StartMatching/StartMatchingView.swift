//
//  StartMatchingView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/26.
//

import UIKit

final class StartMatchingView: BaseView {
    
    let collectionView: DynamicCollectionView = {
        let view = DynamicCollectionView(frame: .zero, collectionViewLayout: .init())
        view.register(BaseCollectionViewCell.self, forCellWithReuseIdentifier: BaseCollectionViewCell.reuseIdentifier)
       
        return view
    }()
    
    override func configure() {
        addSubview(collectionView)
    }
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
