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
        view.image = UIImage(systemName: "xmark")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(errorTextImageView)
        
        errorTextImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.center.equalTo(self.snp.center)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
