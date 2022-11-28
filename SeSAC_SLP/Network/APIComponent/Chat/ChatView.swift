//
//  ChatView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/29.
//

import UIKit

class ChatView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .brown
        return view
    }()
    
    lazy var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: 80))
    }()
    
    let messageTextView: UITextView = {
        let view = UITextView()
        view.textContainer.maximumNumberOfLines = 3
        view.textContainer.lineBreakMode = .byTruncatingTail
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        view.backgroundColor = .setGray(color: .gray1)
        view.text = "메세지를 입력하세요"
        return view
    }()
    
    
    
    override func configure() {
        accessoryView.addSubview(messageTextView)
        [tableView, messageTextView].forEach { addSubview($0) }
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(messageTextView.snp.top)
        }
        
        messageTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            
        }
    }
}
