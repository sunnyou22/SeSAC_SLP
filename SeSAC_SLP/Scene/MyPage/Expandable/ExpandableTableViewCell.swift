//
//  ExpandableTableViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/15.
//

import Foundation
import UIKit
import SnapKit

extension UIStackView {
    func setStackViewLayout(axis: NSLayoutConstraint.Axis, color: UIColor) -> Self {
        self.backgroundColor = color
        self.spacing = 8
        self.axis = axis
        self.distribution = .fillEqually
        return self
    }
}


final class ExpandableTableViewCell: BaseTableViewCell {
    
    let lable: UILabel = {
        let view = UILabel()
        view.text = "새싹타이틀"
        view.backgroundColor = .red
        return view
    }()
    
    let leftVerticalStackView: UIStackView = {
        let view = UIStackView()
       return view.setStackViewLayout(axis: .vertical, color: .magenta)
    }()

    let rightVerticalStackView: UIStackView = {
        let view = UIStackView()
        return view.setStackViewLayout(axis: .vertical, color: .green)
    }()
   
    let horizontalStackView: UIStackView = {
        let view = UIStackView()
        return view.setStackViewLayout(axis: .horizontal, color: .cyan)
    }()
    

    lazy var first: UIButton = {
        let view = UIButton()
        return setStackViewComponent(view, tag: 1)
    }()
    
    lazy var second: UIButton = {
        let view = UIButton()
        return setStackViewComponent(view, tag: 2)
    }()
    
    lazy var third: UIButton = {
        let view = UIButton()
        return setStackViewComponent(view, tag: 3)
    }()
    
    lazy var four: UIButton = {
        let view = UIButton()
        return setStackViewComponent(view, tag: 4)
    }()
    
    lazy var five: UIButton = {
        let view = UIButton()
        return setStackViewComponent(view, tag: 5)
    }()
 
    lazy var six: UIButton = {
        let view = UIButton()
        return setStackViewComponent(view, tag: 6)
    }()
    
    func setStackViewComponent(_ to: UIButton, tag: Int) -> UIButton {
        to.backgroundColor = .setBaseColor(color: .white)
        to.clipsToBounds = true
        to.layer.cornerRadius = CustomCornerRadius.button.rawValue
        to.layer.borderColor = UIColor.setGray(color: .gray4).cgColor
        to.layer.borderWidth = 1
        to.tag = tag
        return to
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configuration() {
        
        [first, third, five].forEach { button in
            leftVerticalStackView.addArrangedSubview(button)
        }
        
        [second, four, six].forEach { rightVerticalStackView.addArrangedSubview($0) }
        
        [leftVerticalStackView, rightVerticalStackView].forEach { horizontalStackView.addArrangedSubview($0) }
        
        [lable, horizontalStackView].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        lable.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(16)
        }
        horizontalStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.snp.horizontalEdges)
            make.top.equalTo(lable.snp.bottom)
            make.bottom.equalTo(contentView.snp.bottom)
//            make.height.equalTo(146)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
