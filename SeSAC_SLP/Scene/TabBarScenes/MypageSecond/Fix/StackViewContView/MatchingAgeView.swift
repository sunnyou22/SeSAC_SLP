//
//  MatchingAgeTableViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit
import SnapKit

class MatchingAgeView: BaseView {
    
    let title: UILabel = {
       let view = UILabel()
        view.text = "상대방 연령대"
        return view
    }()
    
    lazy var ageLable: UILabel = {
        let view = UILabel()
        view.textColor = .setBrandColor(color: .green)
        view.text = "\(trackBar.lower) - \(trackBar.upper)"
        return view
    }()
    
  lazy var trackBar: AgeSlider = {
        let slider = AgeSlider()
        slider.minValue = 18
        slider.maxValue = 65
        slider.lower = 18
        slider.upper = 65
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
            make.bottom.equalTo(trackBar.snp.top).offset(-8)
        }
        
        ageLable.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing)
            make.centerY.equalTo(title.snp.centerY)
        }
        
        trackBar.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.horizontalEdges.equalToSuperview().offset(4)
            make.center.equalTo(self.snp.center)
        }
    }
}
