//
//  WhishStudyView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/26.
//

import UIKit

class WhishStudyView: BaseView {
    
    lazy var whishList: UILabel = {
        let view = UILabel()
        view.font = UIFont.title6_R12
        view.text = "하고 싶은 스터디"
        return view
    }()
    
    //나중에 wishcollectionVeiwcell로 바꿔줘야함
    lazy var collectionView: DynamicCollectionView = {
        let view = DynamicCollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        view.register(SearchCollecitionViewCell.self, forCellWithReuseIdentifier: SearchCollecitionViewCell.reuseIdentifier)
        view.backgroundColor = .cyan
        return view
    }()
    
    override func configure() {
        [whishList, collectionView].forEach { self.addSubview($0) }
        self.backgroundColor = .darkGray
    }
    
    override func setConstraints() {
        whishList.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(whishList.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // collectionView + extension 파일에 뺌
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        return UICollectionViewCompositionalLayout.init(sectionProvider: { [weak self] sectionIndex, environment in
                configuration.scrollDirection = .vertical
                return self?.defaultLayout()
        }, configuration: configuration)
    }
   
}
