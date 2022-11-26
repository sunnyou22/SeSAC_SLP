//
//  SearchView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/17.
//


import UIKit
import SnapKit

class DynamicCollectionView: UICollectionView {
    override var intrinsicContentSize: CGSize {
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
}

final class SearchView: BaseView {
    
    lazy var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: 80))
    }()

    let searchBar: UISearchBar = {
        let view = UISearchBar(frame: CGRect(x: 0, y: 0, width: 1000, height: 52))
        view.placeholder = Placeholder.Searcn.ment.str
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        view.register(SearchCollecitionViewCell.self, forCellWithReuseIdentifier: SearchCollecitionViewCell.reuseIdentifier)
        view.backgroundColor = .cyan
        return view
    }()
    
    let searchButton: UIButton = {
        let view = UIButton()
        view.setTitle("새싹 찾기", for: .normal)
        view.backgroundColor = .setBrandColor(color: .green)
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .brown
    }
    
    override func configure() {
        accessoryView.addSubview(searchButton)
        [collectionView, searchButton].forEach { self.addSubview($0)  }
    }
    
    override func setConstraints() {
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        searchButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(16)
             make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
             make.height.equalTo(48)
         }
     }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

     func configureCollectionViewLayout() -> UICollectionViewLayout {
         let configuration = UICollectionViewCompositionalLayoutConfiguration()
         
         return UICollectionViewCompositionalLayout.init(sectionProvider: { [weak self] sectionIndex, environment in
             
             let searchSection = SearchHeaderView.Section(rawValue: sectionIndex)
             
             switch searchSection {
             case .quo:
                 configuration.scrollDirection = .vertical
                 return self?.defaultLayout()
             case .wish:
                 configuration.scrollDirection = .vertical
                 return self?.defaultLayout()
             case .none:
                 configuration.scrollDirection = .vertical
                 return self?.defaultLayout()
             }
         }, configuration: configuration)
     }

// 공통으로 쓰이는 섹션 레이아웃
func defaultLayout() -> NSCollectionLayoutSection {
           
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(60), heightDimension: .absolute(32))
            //아이템
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
            
            return section
        }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView: UIView? = super.hitTest(point, with: event)
        if (self == hitView) { return nil }
        return hitView
    }
}




