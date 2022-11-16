//
//  MyPageListTableViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/16.
//

import UIKit

class MyPageListTableViewCell: BaseTableViewCell {
    
    let title: UILabel = {
      let view = UILabel()
        view.textColor = .setBaseColor(color: .black)
      return view
    }()
    
    let iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
      
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configuration() {
        [title, iconImageView].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        iconImageView.snp.makeConstraints { make in
//              make.width.height.equalTo(50)
            make.leading.equalTo(contentView.snp.leading).offset(16)
              make.centerY.equalTo(contentView.snp.centerY)
          }
          
          title.snp.makeConstraints { make in
              make.leading.equalTo(iconImageView.snp.trailing).offset(16)
              make.centerY.equalTo(self.snp.centerY)
          }
  }
}
