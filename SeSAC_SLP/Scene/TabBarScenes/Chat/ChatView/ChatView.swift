//
//  ChatView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/29.
//

import UIKit

class ChatView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .brown
        view.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.reuseIdentifier)
        view.register(MyChatTableViewCell.self, forCellReuseIdentifier: MyChatTableViewCell.reuseIdentifier)
        view.backgroundColor = .brown
        view.register(ChatHeaderView.self, forHeaderFooterViewReuseIdentifier: ChatHeaderView.reuseIdentifier)
        return view
    }()
    
    lazy var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: 80))
    }()
    
    let messageTextView: UITextView = {
        let view = UITextView()
        view.textContainer.maximumNumberOfLines = 3
        view.textContainer.lineBreakMode = .byTruncatingTail
        view.backgroundColor = .setGray(color: .gray1)
        view.textColor = .setBaseColor(color: .white)
        view.text = "메세지를 입력하세요"
        return view
    }()
    
    let sendbutton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: Icon.inactsender.rawValue), for: .normal)
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .gray
        return view
    }()
    
    let containiview: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        return view
    }()
    
    
    override func configure() {
        [messageTextView, sendbutton].forEach { containiview.addSubview($0) }
        accessoryView.addSubview(containiview)
        [tableView, containiview].forEach { addSubview($0) }
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(containiview.snp.top)
        }
        
        containiview.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.centerX.equalToSuperview()
        }
        
        messageTextView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(containiview.snp.verticalEdges).inset(12)
            make.leading.equalTo(containiview.snp.leading).offset(12)
            make.trailing.equalTo(sendbutton.snp.leading).offset(8)
        }
        
        sendbutton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(messageTextView.snp.centerY)
            make.trailing.equalToSuperview().offset(-12)

        }
    }
}
