//
//  CardViewNickName.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/16.
//

import UIKit
import SnapKit

class CardViewNickName: BaseView {
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.Body1_M16
       
        return view
    }()
    
    lazy var toggleButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        view.tintColor = .setGray(color: .gray7)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
           [nameLabel, toggleButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.snp.leading)
        }
        
        toggleButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalTo(self.snp.trailing)
            make.width.height.equalTo(16)
        }
    }
}
