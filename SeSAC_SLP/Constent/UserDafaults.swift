//
//  UserDafaults.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/10.
//

import Foundation

@propertyWrapper
struct UserDeaultHelper<Value> {
    let key: String
    let defaultValue: Value
    let container: UserDefaults = .standard
    
    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

extension UserDefaults {

    @UserDeaultHelper(key: "nickname", defaultValue: "")
    static var nickname: String?
    
    @UserDeaultHelper(key: "date", defaultValue: "")
    static var date: String
    
    @UserDeaultHelper(key: "email", defaultValue: "")
    static var email: String
    
    @UserDeaultHelper(key: "man", defaultValue: 1)
    static var man: Int
    
    @UserDeaultHelper(key: "woman", defaultValue: 0)
    static var woman: Int
}
