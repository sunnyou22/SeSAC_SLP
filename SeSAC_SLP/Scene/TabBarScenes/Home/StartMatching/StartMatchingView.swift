//
//  StartMatchingView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/26.
//

import UIKit

final class StartMatchingView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(StartMatchingCollectionViewCell.self, forCellReuseIdentifier: StartMatchingCollectionViewCell.reuseIdentifier)
        view.rowHeight = UITableView.automaticDimension
        return view
    }()
    
    let placeholderImg: UIImageView = {
        let view = ui
    }
    
    override func configure() {
        addSubview(tableView)
        self.backgroundColor = .setBaseColor(color: .white)
    }
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
    }
}
