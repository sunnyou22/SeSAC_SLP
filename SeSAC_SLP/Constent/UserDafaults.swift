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
}
