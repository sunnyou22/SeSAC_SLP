//
//  ShopContainerView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/05.
//

import UIKit

class ShopContainerView: BaseView {
    lazy var collectionView: DynamicCollectionView = {
        let view = DynamicCollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        view.backgroundColor = .setBaseColor(color: .white)
        view.register(SesacCollectionViewCell.self, forCellWithReuseIdentifier: SesacCollectionViewCell.reuseIdentifier)
        return view
    }()
    
    override func configure() {
        addSubview(collectionView)
        self.backgroundColor = .blue
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    // collectionView + extension 파일에 뺌
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        return UICollectionViewCompositionalLayout.init(sectionProvider: { [weak self] sectionIndex, environment in
            
                configuration.scrollDirection = .vertical
//            configuration.
            return self?.shopcompositionLayout()
        }, configuration: configuration)
    }
}
