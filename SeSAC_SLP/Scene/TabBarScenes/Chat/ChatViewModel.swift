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
    
    struct Input {
        let tapSendButton: ControlEvent<Void>
    }
    
    struct Output {
        let tapSendButton: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let tapSendButton = input.tapSendButton.asDriver()
        
        return Output(tapSendButton: tapSendButton)
    }
    
    func fetchChatData(from: String, lastchatDate: String, idtoken: String) -> Payload? {
        let api = SeSACAPI.chatList(from: from, lastchatDate: lastchatDate)
        var result: Payload?
        Network.shared.receiveRequestSeSAC(type: Payload.self, url: api.url, parameter: api.parameter, method: .get, headers: api.getheader(idtoken: idtoken)) { [weak self] data, statusCode in
            guard let data = data else {
                print("데이터를 받아올 수 없음 🔴", #file)
                return
            }
      result = data
            
            guard let status = StatusOfFetchingChat(rawValue: statusCode) else {
                print("상태코드를 받아 올 수 없습니다 🔴", #file)
                return }
            self?.fetchChatApi.accept(status)
        }
        
        return result
    }
}
