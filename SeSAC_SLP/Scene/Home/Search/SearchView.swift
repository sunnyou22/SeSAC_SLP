//
//  SearchView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/17.
//

import UIKit
import SnapKit

class SearchView: BaseScrollView {
    
    lazy var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: 80))
    }()
    
    let searchButton: UIButton = {
        let view = UIButton()
        view.setTitle("새싹 찾기", for: .normal)
        view.backgroundColor = .setBrandColor(color: .green)
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        return view
    }()
    
    lazy var topCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        view.register(TopSearchCollecitionViewCell.self, forCellWithReuseIdentifier: TopSearchCollecitionViewCell.reuseIdentifier)
        view.backgroundColor = .cyan
        return view
    }()
    
    lazy var secondCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout2())
        view.register(SecondSearchCollecitionViewCell.self, forCellWithReuseIdentifier: SecondSearchCollecitionViewCell.reuseIdentifier)
        view.backgroundColor = .cyan
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [topCollectionView, secondCollectionView])
        view.axis = .vertical
        view.spacing = 8
        view.distribution = .fillEqually
        view.backgroundColor = .green
        return view
    }()
    
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .brown
    }
    
    override func configure() {
        accessoryView.addSubview(searchButton)
        contentView.addSubview(stackView)
        [contentView, searchButton].forEach { self.addSubview($0)  }
    }
    
    override func setConstraints() {
        
        topCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(topCollectionView.contentSize.height)
        }
        
        secondCollectionView.snp.makeConstraints { make in
            make.top.equalTo(topCollectionView.snp.bottom).offset(topCollectionView.contentSize.height)
            make.width.equalToSuperview()
            make.height.equalTo(topCollectionView.contentSize.height)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(searchButton.snp.top)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(48)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCollectionViewLayout2() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        return UICollectionViewCompositionalLayout.init(sectionProvider: { sectionIndex, environment in
            let searchSection = Section(rawValue: sectionIndex)
           
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
        }, configuration: configuration)
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
    
