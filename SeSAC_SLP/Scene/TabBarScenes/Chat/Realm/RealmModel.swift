//
//  RealmModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/03.
//

import Foundation
import RealmSwift

//enum ChatType: Int {
//    case defaultType
//    case openChatType
//    case randomChatType
//}
//
//final class ChatDataTable: Object {
//    private override init() { }
//
//    @Persisted var type: Int = ChatType.defaultType.rawValue // 채팅그룹이 나뉜다면
//    @Persisted var list: List<PayLoadListTable>
//    @Persisted var otherUid: String
//    
//    @Persisted(primaryKey: true) var objectId: ObjectId
//
//    convenience init(type: Int, list: List<PayLoadListTable>, otherUid: String) {
//        self.init()
//        self.type = type
//        self.list = list
//        self.otherUid = otherUid
//    }
//}

final class PayLoadListTable: Object {
    private override init() { }
    
    @Persisted var id: String
    @Persisted var to: String
    @Persisted var from: String
    @Persisted var chat: String
    @Persisted var createdAt: String
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(id: String, to: String, from: String, chat: String, createdAt: String) {
        self.init()
        self.id = id
        self.to = to
        self.from = from
        self.chat = chat
        self.createdAt = createdAt
    }
}
