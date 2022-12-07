//
//  ShopContainerView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/05.
//

import UIKit

class ShopContainerView: BaseView {
    lazy var collectionView: DynamicCollectionView = {
        let view = DynamicCollectionView(frame: .zero, collectionViewLayout: .init())
        view.backgroundColor = .setBaseColor(color: .white)
        view.register(SesacCollectionViewCell.self, forCellWithReuseIdentifier: SesacCollectionViewCell.reuseIdentifier)
        view.register(BackgroundCollectionViewCell.self, forCellWithReuseIdentifier: BackgroundCollectionViewCell.reuseIdentifier)
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
    func configureSesacCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        return UICollectionViewCompositionalLayout.init(sectionProvider: { [weak self] sectionIndex, environment in
            
                configuration.scrollDirection = .vertical
//            configuration.
            return self?.shopSesacCompositionLayout()
        }, configuration: configuration)
    }
    
    func configureBackCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        return UICollectionViewCompositionalLayout.init(sectionProvider: { [weak self] sectionIndex, environment in
            
                configuration.scrollDirection = .vertical
//            configuration.
            return self?.shopBackcompositionLayout()
        }, configuration: configuration)
    }
}
