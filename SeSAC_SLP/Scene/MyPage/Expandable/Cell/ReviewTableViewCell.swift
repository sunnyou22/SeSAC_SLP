//
//  ReviewTableViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit

class ReviewTableViewCell: BaseTableViewCell {
    
    let textView: UITextView = {
        let view = UITextView()
        //플레이스 홀더 넣어주기
        view.text = "첫 리뷰를 기다리는 중이에요!"
        //텍스트뷰 색깔지정
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


