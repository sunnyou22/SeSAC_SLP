//
//  ChatDataListRepositoryType.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/03.
//

import Foundation
import RealmSwift

fileprivate protocol ChatDataListRepositoryType: AnyObject {
    func fetchDate() -> Results<PayLoadListTable>
    func addItem(item: PayLoadListTable, errorHandler: @escaping (() -> Void))
    //    func deleteRecord(item: PayLoadListTable)
    func deleteTasks(tasks: Results<PayLoadListTable>, errorHandler: @escaping (() -> Void))
}

class ChatDataListRepository: ChatDataListRepositoryType {
    
    static let shared = ChatDataListRepository()
    private init() { }
    
    let localRealm = try! Realm()
    
    func fetchDate() -> Results<PayLoadListTable> {
        return localRealm.objects(PayLoadListTable.self)
    }
    
    func addItem(item: PayLoadListTable, errorHandler: @escaping (() -> Void)) {
        do {
            try localRealm.write({
                localRealm.add(item)
            })
            
        } catch {
            print("렘에 저장안됨 ")
            errorHandler()
        }
    }
    
    func deleteTasks(tasks: Results<PayLoadListTable>, errorHandler: @escaping (() -> Void)) {
        do {
            try localRealm.write {
                localRealm.delete(tasks)
            }
        } catch {
            print("렘에에서 삭제안됨")
            errorHandler()
        }
    }
}

