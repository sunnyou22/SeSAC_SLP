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
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.register(SearchCollecitionViewCell.self, forCellWithReuseIdentifier: SearchCollecitionViewCell.reuseIdentifier)
        view.backgroundColor = .cyan
        return view
    }()
    
//    lazy var collectionView: UICollectionView = {
//        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
//        view.register(SearchCollecitionViewCell.self, forCellWithReuseIdentifier: SearchCollecitionViewCell.reuseIdentifier)
//        return view
//    }()
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
   
}
