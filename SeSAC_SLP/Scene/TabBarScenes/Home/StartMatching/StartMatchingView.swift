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
        let view = UIImageView()
        view.image = UIImage(named: Placeholder.NearSeSASC.placeholderImg.str)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let placeholderString: UILabel = {
        let view = UILabel()
        view.text = Placeholder.NearSeSASC.ment.str
        return view
    }()

    override func configure() {
        [placeholderImg, placeholderString, tableView].forEach { self.addSubview($0) }
        self.backgroundColor = .setBaseColor(color: .white)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        placeholderImg.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(-40)
            make.width.equalTo(self.snp.width).dividedBy(3)
            make.height.equalTo(self.snp.width)
        }
        
        placeholderString.snp.makeConstraints { make in
            make.top.equalTo(placeholderImg.snp.bottom).offset(16)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
}
