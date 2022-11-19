//
//  CardViewTableViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/19.
//

import Foundation
import UIKit
import SnapKit

class CardViewTableViewCell: BaseTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 셀 내부 뷰
  
    lazy var header = Header()
    lazy var nicknameView = CardViewNickName()
    lazy var expandableView = CardViewTitleAndReview()
    
    lazy var borderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.setGray(color: .gray2).cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }()
    
//    lazy var stackView: UIStackView = {
//        let view = UIStackView(arrangedSubviews: [nicknameView, expandableView])
//        view.axis = .vertical
//        view.alignment = .fill
//        view.distribution = .fill
//
//        view.clipsToBounds = true
//        return view
//    }()
    
    override func configuration() {
        [nicknameView, expandableView].forEach { borderView.addSubview($0) }
        [header, borderView].forEach { contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        header.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(194)
        }
        
        borderView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
//        stackView.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.trailing.leading.equalToSuperview().inset(16)
//            make.bottom.equalToSuperview()
//        }
//
        nicknameView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(60)
            make.trailing.leading.equalToSuperview()
        }

        expandableView.snp.makeConstraints { make in
            make.top.equalTo(nicknameView.snp.bottom)
            make.centerX.equalToSuperview()
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
