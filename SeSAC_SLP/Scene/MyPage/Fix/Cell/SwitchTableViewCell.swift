//
//  SwitchTableViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit

class SwitchTableViewCell: BaseTableViewCell {
     
    let title: UILabel = {
       let view = UILabel()
        view.text = "내 번호 검색 허용"
        return view
    }()
    
    let switchButton: UISwitch = {
        let view = UISwitch()
        view.onTintColor = .setBrandColor(color: .green)
        view.backgroundColor = .setGray(color: .gray4)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configuration() {
        [title, switchButton].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        title.snp.makeConstraints { make in
            make.centerX.equalTo(self.contentView.snp.centerX)
            make.leading.equalTo(self.contentView.snp.leading)
        }
        
        switchButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.contentView.snp.trailing)
            make.centerX.equalTo(self.contentView.snp.centerX)
        }
    }
}

