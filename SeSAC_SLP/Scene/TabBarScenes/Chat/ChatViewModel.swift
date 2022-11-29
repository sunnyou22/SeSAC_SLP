//
//  ChatViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/29.
//

import Foundation

import RxCocoa
import RxSwift

class ChatViewModel: EnableDataInNOut {
    let fetchChatApi = PublishRelay<StatusOfFetchingChat>()
    let chatApi = PublishRelay<StatusOfSendingChat>()
    let textViewText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    struct Input {
        let tapSendButton: ControlEvent<Void>
        let changeMessage: ControlProperty<String?>
    }
    
    struct Output {
        let tapSendButton: Driver<Void>
        let changeMessage: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let tapSendButton = input.tapSendButton.asDriver()
        let changeMessage = input.changeMessage.orEmpty.changed.asDriver()
        return Output(tapSendButton: tapSendButton, changeMessage: changeMessage)
    }
    
    func fetchChatData(from: String, lastchatDate: String, idtoken: String) -> FetchingChatData? {
        let api = SeSACAPI.chatList(from: from, lastchatDate: lastchatDate)
        var result: FetchingChatData?
        Network.shared.receiveRequestSeSAC(type: FetchingChatData.self, url: api.url, method: .get, headers: api.getheader(idtoken: idtoken)) { [weak self] data, statusCode in
            guard let data = data else {
                print("채팅목록 데이터를 받아올 수 없음 🔴", #file)
                return
            }
            result = data
            print("채팅목록 데이터 받아옴 🟢", data)
            guard let status = StatusOfFetchingChat(rawValue: statusCode) else {
                print("채팅목록 상태코드를 받아 올 수 없습니다 🔴", #file)
                return }
            self?.fetchChatApi.accept(status)
        }
        
        return result
    }
    
    func sendChat(to: String, contents: String, idtoken: String) {
        let api = SeSACAPI.chat(to: to)
        
        Network.shared.sendRequestSeSAC(url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { [weak self] statusCode in
            guard let status = StatusOfSendingChat(rawValue: statusCode) else {
                print("채팅 보내기 상태코드를 받아 올 수 없습니다 🔴", #file)
                return }
            print("채팅보내기 성공 🟢")
            self?.chatApi.accept(status)
        }
    }
}
