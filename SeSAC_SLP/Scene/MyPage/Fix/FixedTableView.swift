//
//  FixedTableView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit

class FixedTableView: UITableView {
    
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
     self.register(GenderTableViewCell.self, forCellReuseIdentifier: GenderTableViewCell.reuseIdentifier)
     self.register(SetFrequentStudyTableViewCell.self, forCellReuseIdentifier: SetFrequentStudyTableViewCell.reuseIdentifier)
     self.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.reuseIdentifier)
     self.register(MatchingAgeTableViewCell.self, forCellReuseIdentifier: MatchingAgeTableViewCell.reuseIdentifier)
     self.register(SignOutTableViewCell.self, forCellReuseIdentifier: SignOutTableViewCell.reuseIdentifier)
    }
    
    func configure() {
        self.backgroundColor = .brown
    }
}

