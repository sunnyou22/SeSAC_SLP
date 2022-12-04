//
//  ChatViewController + Extension.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/03.
//

import UIKit
import RxSwift
import RealmSwift

//MARK: - Table
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ChatHeaderView()
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.serverChatData.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = viewModel.serverChatData.value[indexPath.row]
//
        if data.from == commonserver.userData.value[0].uid {
            guard let myCell = tableView.dequeueReusableCell(withIdentifier: MyChatTableViewCell.reuseIdentifier, for: indexPath) as? MyChatTableViewCell else { return UITableViewCell() }
            myCell.messegeLbl.text = data.chat
            myCell.timeLbl.text = data.createdAt
            myCell.containView.backgroundColor = .setBaseColor(color: .white)
            viewModel.chatApi
                .asDriver(onErrorJustReturn: .success)
                .drive { status in
                    switch status {
                    case .success:
                        myCell.containView.backgroundColor = .setBaseColor(color: .white)
                    default:
                        myCell.containView.backgroundColor = .setGray(color: .gray6)
                    }
                }.disposed(by: disposedBag)
            return myCell
        } else {
            guard let yourCell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.reuseIdentifier, for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
            yourCell.messegeLbl.text = data.chat
            yourCell.timeLbl.text = data.createdAt
            yourCell.containView.backgroundColor = .setGray(color: .gray7)
            return yourCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainView.messageTextView.resignFirstResponder()
    }
}

//MARK: -
extension ChatViewController {
    @objc func getMessage(notification: NSNotification) {
        
        let id = notification.userInfo![Payload.CodingKeys.id.rawValue] as! String
        let to = notification.userInfo![Payload.CodingKeys.to.rawValue] as! String
        let from = notification.userInfo![Payload.CodingKeys.from.rawValue] as! String
        let chat = notification.userInfo![Payload.CodingKeys.chat.rawValue] as! String
        let createdAt = notification.userInfo![Payload.CodingKeys.createdAt.rawValue] as! String
        
            // Payload 데이터
        let value = Payload(id: id, to: to, from: from, chat: chat, createdAt: createdAt)
            // 데이터 쌓아줌, 뷰모델에서 chatList 이벤트 던짐 -> 시점 체크하기
        viewModel.setchatList(addchatList: value) // 화면에 보여주고
        
        guard viewModel.serverChatData.value.count != 0 else {
           return
        }
        mainView.tableView.reloadData()
        mainView.tableView.scrollToRow(at: IndexPath(row: viewModel.serverChatData.value.count - 1, section: 0), at: .bottom, animated: false)
    }
}

