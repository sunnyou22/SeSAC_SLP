//
//  MatchingAgeTableViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit

class MatchingAgeTableViewCell: BaseTableViewCell {
    
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
        slider.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        return slider
    }()
    
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configuration() {
        <#code#>
    }
    
    override func setConstraints() {
        <#code#>
    }
}
