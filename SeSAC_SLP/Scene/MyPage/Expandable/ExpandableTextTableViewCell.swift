//
//  ExpandableTextTableViewCell.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/15.
//


import Foundation
import UIKit
import SnapKit

class ExpandableTextTableViewCell: BaseTableViewCell {
    
    let lable: UILabel = {
        let view = UILabel()
        view.text = "새싹 리뷰"
        view.backgroundColor = .red
        return view
    }()
    
    let textView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .blue
//        view.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        view.isScrollEnabled = false
        view.contentSize.height
        return view
    }()
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configuration() {
        contentView.addSubview(lable)
        contentView.addSubview(textView)
    }
    
    override func setConstraints() {
        lable.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.height.equalTo(28)
        }
       
        textView.snp.makeConstraints { make in
            make.top.equalTo(lable.snp.bottom)
            make.horizontalEdges.equalTo(self.snp.horizontalEdges)
            make.bottom.equalTo(self.snp.bottom)

        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

