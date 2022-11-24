//
//  BaseScrollView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/23.
//

import UIKit

class BaseScrollView: UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() { }
    func setConstraints() { }
}
