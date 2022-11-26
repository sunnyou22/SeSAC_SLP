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
    
    let collectionView: DynamicCollectionView = {
        let view = DynamicCollectionView(frame: .zero, collectionViewLayout: .init())
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
}
