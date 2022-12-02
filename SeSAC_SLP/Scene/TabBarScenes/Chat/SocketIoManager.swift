//
//  SocketIoManager.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/30.
//

import Foundation

import SocketIO

class SocketIOManager {
    
    static let shared = SocketIOManager()
    
    let NotificationName = "getMessage"
    
    var manager: SocketManager!
    
    var socket: SocketIOClient!
    
    private init() {
    
        // 누구랑 통신할거냐
        manager = SocketManager(socketURL: URL(string: URLConstant.BaseURL)!, config: [
            .forceWebsockets(true)
        ])
        
        socket = manager.defaultSocket
        
        // 소켓 연결 메서드
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket is connected", data, ack)
            // 내 유아이디 리터럴한거 바꾸기
            self.socket.emit("changesocketid", "bAO88VFDs2goBwg6nhsnZhUTA6G2")
        }
        // 연결해제
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
        // 이벤트 수집
        socket.on("chat") { dataArray, ack in
            print("SESAC RECEIVED", dataArray, ack)
            
            let data = dataArray[0] as! NSDictionary
            let id = data[Payload.CodingKeys.id.rawValue] as! String
            let to = data[Payload.CodingKeys.to.rawValue] as! String
            let from = data[Payload.CodingKeys.from.rawValue] as! String
            let chat = data[Payload.CodingKeys.chat.rawValue] as! String
            let createdAt = data[Payload.CodingKeys.createdAt.rawValue] as! String
            
            print("check >>>", chat, to, from, createdAt)
            
            NotificationCenter.default.post(name: Notification.Name(SocketIOManager.shared.NotificationName), object: self, userInfo: [
                Payload.CodingKeys.id.rawValue: id,
                Payload.CodingKeys.to.rawValue: to,
                Payload.CodingKeys.from.rawValue: from,
                Payload.CodingKeys.chat.rawValue: chat,
                Payload.CodingKeys.createdAt.rawValue: createdAt
            ])
        }
    }
    
    func establistConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
