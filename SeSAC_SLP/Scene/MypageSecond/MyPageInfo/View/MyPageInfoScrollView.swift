//
//  MyPageInfoScrollView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/16.
//

import UIKit

class MyPageInfoScrollView: UIScrollView {
    
    lazy var cardView = CardView()
    lazy var fixView = FixedView()
    
    lazy var contentView = UIView()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [cardView, fixView])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .setBaseColor(color: .white)
        
        self.isScrollEnabled = true
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.addSubview(contentView)
        contentView.addSubview(stackView)
    }
    
    func setConstraints() {
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(16)
            make.centerX.top.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
