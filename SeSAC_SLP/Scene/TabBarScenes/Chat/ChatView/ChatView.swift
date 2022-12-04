//
//  ChatView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/29.
//

import UIKit

class ChatView: BaseView {
    
    let moreView = MoreButtonView()
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .brown
        view.allowsSelection = false
        view.separatorStyle = .none
//        view.rowHeight = UITableView.automaticDimension
        view.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.reuseIdentifier)
        view.register(MyChatTableViewCell.self, forCellReuseIdentifier: MyChatTableViewCell.reuseIdentifier)
        view.backgroundColor = .brown
        view.register(ChatHeaderView.self, forHeaderFooterViewReuseIdentifier: ChatHeaderView.reuseIdentifier)
        return view
    }()

    lazy var messageTextView: DynamicTextView = {
        let view = DynamicTextView()
//        view.textContainer.maximumNumberOfLines = 3
        view.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.textContainer.lineBreakMode = .byTruncatingTail
        view.font = .title3_M14
        view.backgroundColor = .setGray(color: .gray1)
        view.textColor = .setBaseColor(color: .black)
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
//        accessoryView.addSubview(containiview)
        [tableView, containiview, moreView].forEach { addSubview($0) }
    }
    
    override func setConstraints() {
       
        moreView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(containiview.snp.top)
        }
    
        //악세서리뷰
        containiview.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(52)
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

class DynamicTextView: UITextView {

    override var intrinsicContentSize: CGSize {
        return self.contentSize
    }

    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
}
