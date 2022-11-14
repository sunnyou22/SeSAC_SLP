//
//  MatchingAgeTableViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit

class MatchingAgeView: BaseView {
    
    let title: UILabel = {
       let view = UILabel()
        view.text = "내 성별"
        return view
    }()
    
    let ageLable: UILabel = {
        let view = UILabel()
        view.textColor = .setBrandColor(color: .green)
        return view
    }()
    
    let trackBar: AgeSlider = {
        let slider = AgeSlider()
        slider.minValue = 18
        slider.maxValue = 65
        slider.lower = 1
        slider.upper = 30
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [title, ageLable, trackBar].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        title.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        ageLable.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        trackBar.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(12)
        }
    }
}
