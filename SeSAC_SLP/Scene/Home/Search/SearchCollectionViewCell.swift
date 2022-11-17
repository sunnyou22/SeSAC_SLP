//
//  SearchCollectionViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/17.
//

import UIKit
import SnapKit

class SearchCollecitionViewCell: UICollectionViewCell {
  
    let lable: UILabel = {
        let view = UILabel()
        view.text = "이건 테스트"
        view.textColor = .black
        return view
    }()
    
//    let containVeiw: UIView = {
//        let view = UIView()
//        view.backgroundColor = .blue
//        return view
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configrue() {
        contentView.addSubview(lable)
    }
    
    func setConstraints() {
        lable.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges).inset(8)
        }
    }
}
