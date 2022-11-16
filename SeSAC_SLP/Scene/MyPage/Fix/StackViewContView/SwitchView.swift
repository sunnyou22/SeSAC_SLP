//
//  SwitchTableViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit
import SnapKit

class SwitchView: BaseView {
     
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [title, switchButton].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        title.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.snp.leading)
        }
        
        switchButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
}

