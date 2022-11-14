//
//  ExpandableTableView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit

class ExpandableTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        // 셀등록
        registerTableViewCell()
        
        // 테이블뷰 속성
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //셀등록
 func registerTableViewCell() {
     self.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.reuseIdentifier)
     self.register(WishStudyTavleViewCell.self, forCellReuseIdentifier: WishStudyTavleViewCell.reuseIdentifier)
     self.register(ReviewTableViewCell.self, forCellReuseIdentifier: ReviewTableViewCell.reuseIdentifier)
    }
    
    func configure() {
        self.backgroundColor = .brown
    }
}
