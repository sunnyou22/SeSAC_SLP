//
//  SearchCollectionViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/17.
//

import UIKit
import SnapKit

class SearchCollecitionViewCell: UICollectionViewCell {
  
    lazy var label: UILabel = {
        let view = UILabel()
        view.text = "이건 테스트"
        view.font = UIFont.title4_R14
        view.textColor = .black
    
        return view
    }()
    
    lazy var xbutton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "xmark"), for: .normal)
        
        view.tintColor = .setBrandColor(color: .green)
        return view
    }()
    
    lazy var customView: UIView = {
        let view = UIStackView()
       
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        view.layer.borderColor = UIColor.setBrandColor(color: .green).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    //    let containVeiw: UIView = {
    //        let view = UIView()
    //        view.backgroundColor = .blue
    //        return view
    //    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .brown
        configrue()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configrue() {
        [label, xbutton].forEach { customView.addSubview($0) }
        contentView.addSubview(customView)
    }
    
    func setConstraints() {
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        xbutton.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.height.equalTo(12)
        }
        
        customView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
