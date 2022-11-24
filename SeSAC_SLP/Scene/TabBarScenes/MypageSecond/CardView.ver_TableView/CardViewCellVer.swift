//
//  CardViewCellVer.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/19.
//

import UIKit
import SnapKit

class CardViewCellVer: UIScrollView {
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(CardViewTableViewCell.self, forCellReuseIdentifier: CardViewTableViewCell.reuseIdentifier)
        view.backgroundColor = .brown
        view.isScrollEnabled = true
        invalidateIntrinsicContentSize()
        
        return view
    }()
    
    lazy var fixView = FixedView()
    
    lazy var contentView = UIView()
    
//    lazy var stackView: UIStackView = {
//        let view = UIStackView(arrangedSubviews: [tableView, fixView])
//        view.axis = .vertical
//        view.alignment = .fill
//        view.distribution = .fill
//        view.spacing = 24
//        return view
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isScrollEnabled = true
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      
    }
    
    func configure() {
        [tableView, fixView].forEach { contentView.addSubview($0) }
//        contentView.addSubview(stackView)
        self.addSubview(contentView)
      
    }
    
    func setConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(tableView.contentSize.height) // 셀이 그려지기 전에 호출돼서 그런가
            make.bottom.equalTo(fixView.snp.top)
                make.horizontalEdges.equalToSuperview()
            
        }
        
        fixView.snp.makeConstraints { make in
            
            make.horizontalEdges.equalToSuperview()
//            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(16)
            make.centerX.top.bottom.equalToSuperview()
        }
        
//        stackView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
    }
}
