//
//  CardViewTableViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/19.
//

import UIKit
import SnapKit

class CardViewTableViewCell: BaseTableViewCell {

    //MARK: - 셀 내부 뷰
  
    lazy var header = Header()
    lazy var nicknameView = CardViewNickName()
    lazy var expandableView = CardViewTitleAndReview()
    
    lazy var borderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
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
            make.height.equalTo(160) // 셀 높이면
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
