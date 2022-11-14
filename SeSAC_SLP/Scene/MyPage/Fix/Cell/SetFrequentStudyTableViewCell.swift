//
//  SetFrequentStudyTableViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit

class SetFrequentStudyTableViewCell: BaseTableViewCell {
    
    let title: UILabel = {
       let view = UILabel()
        view.text = "자주 하는 스터디"
        return view
    }()
    
    let section: UIView = {
        let view = UIView()
        view.backgroundColor = .setGray(color: .gray3)
        view.bounds.size.height = 1
        return view
    }()
    
    let textField: UITextField = {
        let view = UITextField()
        view.textColor = .setBaseColor(color: .white)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configuration() {
        
    }
    
    override func setConstraints() {
        section.snp.makeConstraints { make in
            make.width.equalTo(164)
        }
    }
}

