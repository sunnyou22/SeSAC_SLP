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
        [title, section, textField].forEach { self.addSubview($0) }
        
    }
    
    override func setConstraints() {
        
        title.snp.makeConstraints { make in
            make.leading.equalTo(self.contentView.snp.leading)
            make.centerX.equalTo(self.contentView.snp.centerX)
        }
        
        section.snp.makeConstraints { make in
            make.trailing.equalTo(self.contentView.snp.leading)
            make.width.equalTo(164)
        }
        
        textField.snp.makeConstraints { make in
            make.centerX.equalTo(self.title.snp.centerX)
            make.leading.equalTo(section.snp.leading).offset(12)
        }
    }
}

