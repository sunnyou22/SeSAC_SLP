//
//  CardViewTableViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/19.
//

import Foundation
import UIKit
import SnapKit

class CardViewTableViewCell: BaseTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 셀 내부 뷰
  
    lazy var cardView = CardView()
    
    override func configuration() {
        contentView.addSubview(cardView)
    }
    
    override func setConstraints() {
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
