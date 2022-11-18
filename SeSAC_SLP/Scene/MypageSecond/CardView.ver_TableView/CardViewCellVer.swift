//
//  CardViewCellVer.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/19.
//

import UIKit
import SnapKit

class CardViewCellVer: BaseView {
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(CardViewTableViewCell.self, forCellReuseIdentifier: CardViewTableViewCell.reuseIdentifier)
        view.backgroundColor = .brown
        view.isScrollEnabled = true
        return view
    }()
    
    lazy var fixView = FixedView()
    
    lazy var contentView = UIView()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [tableView, fixView])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .equalSpacing
        view.spacing = 24
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.isScrollEnabled = true
//        configure()
//        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      
    }
    
    override func configure() {
        contentView.addSubview(stackView)
        self.addSubview(contentView)
        
    }
    
    override func setConstraints() {

        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        fixView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(16)
            make.centerX.top.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
