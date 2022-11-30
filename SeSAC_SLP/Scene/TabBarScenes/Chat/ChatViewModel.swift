//
//  ChatViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/29.
//

import Foundation

import RxCocoa
import RxSwift

final class ChatViewModel: EnableDataInNOut {
    
    enum MoreBtnUserStatus: String {
        case cancel = "스터디 취소"
        case finished = "스터디 종료"
    }
    
    let commonServer = CommonServerManager()
    
    let fetchChatApi = PublishRelay<StatusOfFetchingChat>()
    let chatApi = PublishRelay<StatusOfSendingChat>()
    let cancelApi = PublishRelay<Dodge>()
    let textViewText: BehaviorRelay<String> = BehaviorRelay(value: "")
    let matchingStatus: BehaviorRelay<[MatchStatus]> =  BehaviorRelay(value: [])
    var studyStatus: BehaviorRelay<MoreBtnUserStatus> = BehaviorRelay(value: .cancel)
    
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
    
    func checkMyQueueStatus(idtoken: String) {
        matchingStatus.accept(commonServer.getMatchStatus(idtoken: idtoken))
    }
    
    func changeMorebuttontitle() {
        guard let matchstatus = matchingStatus.value[0].matched, let dogged = matchingStatus.value[0].dodged, let reviewed = matchingStatus.value[0].reviewed else {
            print("\(#function), \(#file) 상대방 매칭상태 못 받아옴")
            return }
        if matchstatus == 1 {
        studyStatus.accept(ChatViewModel.MoreBtnUserStatus.cancel)
        } else if dogged == 1 || reviewed == 1 {
            studyStatus.accept(ChatViewModel.MoreBtnUserStatus.finished)
        } else {
            print(#file, #function, "오류체크하기 더보기 버튼 사용자상태 조건문 다시 확인 🔴")
        }
    }
    
    func fetchChatData(from: String, lastchatDate: String, idtoken: String) -> [FetchingChatData]? {
        let api = SeSACAPI.chatList(from: from, lastchatDate: lastchatDate)
        var result: [FetchingChatData]?
        Network.shared.receiveRequestSeSAC(type: FetchingChatData.self, url: api.url, method: .get, headers: api.getheader(idtoken: idtoken)) { [weak self] data, statusCode in
            guard let data = data else {
                print("채팅목록 데이터를 받아올 수 없음 🔴", #file)
                return
            }
            result = [data]
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
    
    func dodge(otherID: String, idtoken: String) {
        let api = SeSACAPI.dodge(otheruid: otherID)
        
        Network.shared.sendRequestSeSAC(url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { [weak self] statusCode in
            guard let status = Dodge(rawValue: statusCode) else {
                print("스터디를 취소할 수 없음 가드구문 🔴", #file)
                return }
            print("스터디 취소 성공 🟢")
            self?.cancelApi.accept(status)
        }
    }
}
