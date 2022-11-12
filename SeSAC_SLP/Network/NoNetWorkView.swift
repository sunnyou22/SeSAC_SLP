//
//  NoNetWorkView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/12.
//

import UIKit
import SnapKit

class NoNetWorkView: UIView {
    
    let errorTextImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "wifi.exclamationmark")
        view.image?.withTintColor(.cyan)
        return view
    }()
    
    let cautionLabel: UILabel = {
        let view = UILabel()
        view.text = "네트워크상태가 불안정합니다!\n네트워크 상태를 확인해주세요!"
        view.textColor = .systemRed
        view.font = .title1_M16
        view.textAlignment = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [errorTextImageView, cautionLabel].forEach { self.addSubview($0) }
        
        errorTextImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.center.equalTo(self.snp.center)
        }
        
        cautionLabel.snp.makeConstraints { make in
            make.top.equalTo(errorTextImageView.snp.bottom).offset(20)
            make.centerX.equalTo(errorTextImageView.snp.centerX)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
