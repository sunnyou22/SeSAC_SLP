//
//  BackCollectionViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/15.
//

import UIKit
import SnapKit

class BackCollectionViewCell: UICollectionViewCell {
    
    let label: UILabel = {
        let view = UILabel()
        view.text = "회원탈퇴"
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .magenta

         self.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.leading.equalTo(self.snp.leading)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
 
