//
//  SearchView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/17.
//


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
 

import UIKit
import SnapKit

class SearchView: BaseView {
    
    lazy var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: 80))
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .setBaseColor(color: .black)
        view.isPagingEnabled = true
        view.isScrollEnabled = true
       
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
    
    lazy var topCollectionView: DynamicCollectionView = {
        let view = DynamicCollectionView(frame: .zero, collectionViewLayout: topCollectionViewViewLayout())
        view.register(TopSearchCollecitionViewCell.self, forCellWithReuseIdentifier: TopSearchCollecitionViewCell.reuseIdentifier)
        view.backgroundColor = .black
        return view
    }()
    
    lazy var secondCollectionView: DynamicCollectionView = {
        let view = DynamicCollectionView(frame: .zero, collectionViewLayout: secondCollectionViewLayout())
        view.register(SecondSearchCollecitionViewCell.self, forCellWithReuseIdentifier: SecondSearchCollecitionViewCell.reuseIdentifier)
        view.backgroundColor = .blue
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [topCollectionView, secondCollectionView])
        view.axis = .vertical
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
        scrollView.addSubview(contentView)
        [scrollView, searchButton].forEach { self.addSubview($0)  }
    }
    
    override func setConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        topCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(100)
        }
        
        secondCollectionView.snp.makeConstraints { make in
            make.top.equalTo(topCollectionView.snp.bottom)
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(100)
        }
        
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(stackView.snp.height)
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
   
    func topCollectionViewViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        return UICollectionViewCompositionalLayout.init(sectionProvider: { [weak self] sectionIndex, environment in
            
            let searchSection = AroundSection(rawValue: sectionIndex)
            
            switch searchSection {
            case .quo:
                return self?.defaultLayout()
            case .wish:
                return self?.setWithoutHeaderdefaultLayout()
            case .none:
                return self?.defaultLayout()
            }
        }, configuration: configuration)
    }
    
    func secondCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        return UICollectionViewCompositionalLayout.init(sectionProvider: { [weak self] sectionIndex, environment in
            return self?.defaultLayout()
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
    
    // 공통으로 쓰이는 섹션 레이아웃
    func setWithoutHeaderdefaultLayout() -> NSCollectionLayoutSection {
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
    
        return section
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            let hitView: UIView? = super.hitTest(point, with: event)
            if (self == hitView) { return nil }
            return hitView
        }
    
}
    
