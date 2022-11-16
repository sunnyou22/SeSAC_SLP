//
//  SeSACTitleStackView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/16.
//

import UIKit
import SnapKit

class TitleStackView: UIStackView {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  func configuration() {
        
        [first, third, five].forEach { button in
            leftVerticalStackView.addArrangedSubview(button)
        }
        
        [second, four, six].forEach { rightVerticalStackView.addArrangedSubview($0) }
        
        [leftVerticalStackView, rightVerticalStackView].forEach { horizontalStackView.addArrangedSubview($0) }
        
      self.addSubview(horizontalStackView)
    }
    
}
