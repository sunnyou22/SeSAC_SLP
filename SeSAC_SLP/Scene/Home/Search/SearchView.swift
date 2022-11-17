//
//  SearchView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/17.
//

import UIKit
import SnapKit

class SearchView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        view.register(SearchCollecitionViewCell.self, forCellWithReuseIdentifier: SearchCollecitionViewCell.reuseIdentifier)
        view.backgroundColor = .cyan
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .brown
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        return UICollectionViewCompositionalLayout.init(sectionProvider: { sectionIndex, environment in
            
            let searchSection = Section(rawValue: sectionIndex)
            
            switch searchSection {
            case .quo:
                //아이템
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(60), heightDimension: .absolute(32))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.edgeSpacing = .init(leading: .none, top: .fixed(8), trailing: .none, bottom: .none)
                
                // 그룹
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(32))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(8)
                
                // 섹션
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 12
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 76, trailing: 16)
                
                let headersize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headersize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
                configuration.scrollDirection = .vertical
                
                return section
            case .wish:
                //아이템
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(60), heightDimension: .absolute(32))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.edgeSpacing = .init(leading: .none, top: .fixed(8), trailing: .none, bottom: .none)
                
                // 그룹
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(32))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(8)
                
                // 섹션
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 12
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 76, trailing: 16)
                
                configuration.scrollDirection = .vertical
                
                let headersize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headersize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
                return section
            case .none:
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(60), heightDimension: .absolute(32))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.edgeSpacing = .init(leading: .none, top: .fixed(8), trailing: .none, bottom: .none)
                
                // 그룹
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(32))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(8)
                
                // 섹션
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 12
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 76, trailing: 16)
                
                configuration.scrollDirection = .vertical
                
                let headersize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headersize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
                return section
            }
        }, configuration: configuration)
    }
                                                        
}


