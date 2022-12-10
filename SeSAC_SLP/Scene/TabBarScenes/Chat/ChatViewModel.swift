//
//  ChatViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/29.
//

import Foundation

import RxSwift
import RxCocoa
import RxKeyboard
import RealmSwift

final class ChatViewModel: EnableDataInNOut {
    
    //    enum PostStatus {
    //        case success
    //        case networkfail
    //        case other
    //    }
    
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
    
    let serverChatData: BehaviorRelay<[Payload]> = BehaviorRelay(value: [])
//    let RealmchatData: BehaviorRelay<[Payload]> = BehaviorRelay(value: [])
   private let fetchStatus: BehaviorRelay<CompareFetch?> = BehaviorRelay(value: nil)
    
    struct Input {
        let tapSendButton: ControlEvent<Void>
        let cancelButton: ControlEvent<Void>
        let changeMessage: ControlProperty<String?>
    }
    
    struct Output {
        let tapSendButton: Driver<Void>
        let cancelButton: Driver<Void>
        let changeMessage: Driver<String>
    }
    
    final func transform(input: Input) -> Output {
        let tapSendButton = input.tapSendButton.asDriver()
        let cancelButton = input.cancelButton.asDriver()
        let changeMessage = input.changeMessage.orEmpty.changed.asDriver()
        return Output(tapSendButton: tapSendButton, cancelButton: cancelButton, changeMessage: changeMessage)
    }
    
    final func setchatList(addchatList: Payload) {
        print(serverChatData.value, "======= addwish 이전")
        var tempList = serverChatData.value
        tempList.append(addchatList)
        print(serverChatData.value, "======= addwish 이후")
        serverChatData.accept(tempList)
    }
    
    
    final func removeLastChat() {
        var removeChat = serverChatData.value
        removeChat.removeLast()
        print("서버통신 실패로 인해 최신 채팅 삭제한 한 줄 removeChat.removeLast()")
        serverChatData.accept(removeChat)
    }
    
    
    final func changeMorebuttontitle() {
        guard let matchstatus = matchingStatus.value[0].matched, let dogged = matchingStatus.value[0].dodged, let reviewed = matchingStatus.value[0].reviewed else {
            print("\(#function) 상대방 매칭상태 못 받아옴")
            return }
        if matchstatus == 1 {
            studyStatus.accept(ChatViewModel.MoreBtnUserStatus.cancel)
        } else if dogged == 1 || reviewed == 1 {
            studyStatus.accept(ChatViewModel.MoreBtnUserStatus.finished)
        } else {
            print( #function, "오류체크하기 더보기 버튼 사용자상태 조건문 다시 확인 🔴")
        }
    }
    
   final func fetchChatData(from: String, lastchatDate: String, idtoken: String) {
        let api = SeSACAPI.chatList(from: from, lastchatDate: lastchatDate)
        Network.shared.receiveRequestSeSAC(type: FetchingChatData.self, url: api.url, method: .get, headers: api.getheader(idtoken: idtoken)) { [weak self] data, statusCode in
            guard let data = data?.payload else {
                print("채팅목록 데이터를 받아올 수 없음 🔴", #function)
                return
            }
            self?.serverChatData.accept(data)
            print("채팅목록 데이터 받아옴 🟢", data)
            
            guard let status = StatusOfFetchingChat(rawValue: statusCode) else {
                print("채팅목록 상태코드를 받아 올 수 없습니다 🔴", #function)
                return }
            
            SocketIOManager.shared.establistConnection()
            
            self?.fetchChatApi.accept(status)
        }
    }
    
   private func compareDate() {
        let tasks = ChatDataListRepository.shared.fetchDate() // 모델간의 상호작용이 맞을지 고민하기 중간다리 역할 모델을 두고 뷰모델에서 전부 처리한뒤 뷰컨에 보여주던가, 아님 중간다리 뷰모델 없이 그때그때 처리하던가흠,,
        
        guard let latestRealmTask = CustomFormatter.shared.setformatterToDate(tasks.last?.createdAt ?? "최초매칭") else { return }
        guard let chatDataSorted = CustomFormatter.shared.setformatterToDate(serverChatData.value.sorted(by: {
            guard let past = CustomFormatter.shared.setformatterToDate($0.createdAt) else { return false}
            guard let lastest = CustomFormatter.shared.setformatterToDate($1.createdAt) else { return false }
            return (past < lastest) }).last?.createdAt ?? "최초매칭") else { return }
        
        if chatDataSorted > latestRealmTask {
            return fetchStatus.accept(.refresh)
        } else if (chatDataSorted == latestRealmTask) || tasks.isEmpty {
            return fetchStatus.accept(.updated)
        }  else {
            return fetchStatus.accept(.error)
        }
    }
    
    final func addLatestDataToRealm() { // 최신순 정렬
        compareDate() // 비교하기
        
        switch fetchStatus.value {
        case .refresh:
            print("Realm is located at:", ChatDataListRepository.shared.localRealm.configuration.fileURL!)
            for i in serverChatData.value {
                let task = PayLoadListTable(id: i.id, to: i.to , from: i.from , chat: i.chat , createdAt: i.createdAt )
                
                ChatDataListRepository.shared.addItem(item: task) {
                    print("램 payloadListTable add 완료")
                }
            }
            // 여차피 서버통신은 느리까. 너무 느리면 로딩바 같은거 달기
        serverChatData.accept(ChatDataListRepository.shared.fetchDate().map { Payload(id: $0.id, to: $0.to, from: $0.from, chat: $0.chat, createdAt: $0.createdAt) })
        case .updated:
            serverChatData.accept(ChatDataListRepository.shared.fetchDate().map { Payload(id: $0.id, to: $0.to, from: $0.from, chat: $0.chat, createdAt: $0.createdAt) })
            print("양쪽 최신 데이터, 혹은 최신데이터")
        case .error:
            print("램이 최신날짜 -> 서버에 값 전달 확인 필요")
        case .none:
            serverChatData.accept(ChatDataListRepository.shared.fetchDate().map { Payload(id: $0.id, to: $0.to, from: $0.from, chat: $0.chat, createdAt: $0.createdAt) })
            print("기타 램 서버 비교에렁")
        }
    }
    
    final func sendChat(to: String, contents: String, idtoken: String) {
        let api = SeSACAPI.chat(to: to, chat: contents)
        
        Network.shared.testSendReuestSeSAC(type: Payload.self, url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { data, statusCode in
            guard let status = StatusOfSendingChat(rawValue: statusCode) else {
                print("채팅 보내기 상태코드를 받아 올 수 없습니다 🔴", #file)
                return }
            
            guard let data = data else {
                self.chatApi.accept(status)
                return }
            
            //  200이 떴을 때 "램에 넣어주기 랑 셀의 상태도 바꿔줘야함
//            let task = PayLoadListTable(id: data.id, to: data.to, from: data.from, chat: data.chat, createdAt: data.createdAt)
//            ChatDataListRepository.shared.addItem(item: task) {
//                print("send chat 램에 레코드 넣기 완료 -> 넣은 메세지: ", task.chat)
//            }
        }
    }
  
//    final func sendChat(to: String, contents: String, idtoken: String) {
//        let api = SeSACAPI.chat(to: to, chat: contents)
//
//        Network.shared.sendRequestSeSAC(url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { statusCode in
//            guard let status = StatusOfSendingChat(rawValue: statusCode) else {
//                print("채팅 보내기 상태코드를 받아 올 수 없습니다 🔴", #file)
//                return }
//
//            print("SENDCHAT STATUS ->", status)
//            self.chatApi.accept(status)
//        }
//    }
    
    final func dodge(otherID: String, idtoken: String) {
        let api = SeSACAPI.dodge(otheruid: otherID)
        
        Network.shared.sendRequestSeSAC(url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { [weak self] statusCode in
            guard let status = Dodge(rawValue: statusCode) else {
                print("스터디를 취소할 수 없음 가드구문 🔴", #function)
                return }
            print("스터디 취소 성공 🟢", status)
            self?.cancelApi.accept(status)
        }
    }
}
