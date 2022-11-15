//
//  ExpandableTableViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/15.
//

import Foundation
import UIKit
import SnapKit

class ExpandableTableViewCell: BaseTableViewCell {
    
    let lable: UILabel = {
        let view = UILabel()
        view.text = "새싹타이틀"
        view.backgroundColor = .red
        return view
    }()
    
//    let titleCollectionView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configuration() {
        contentView.addSubview(lable)
    }
    
    override func setConstraints() {
        lable.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(16)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
