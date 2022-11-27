//
//  BaseCollectionViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/24.
//
import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setUpConstraints()
        
        self.backgroundColor = .darkGray
    }
        
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {}
    
    func setUpConstraints() {}
        
}

