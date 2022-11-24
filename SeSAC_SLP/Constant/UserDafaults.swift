//
//  UserDafaults.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/10.
//

import Foundation

enum UserDaultsKey: String, CaseIterable {
    case idtoken
    case phoneNumber
    case FCMToken
    case nickname
    case date
    case email
}

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


@propertyWrapper
struct UserDeaultCodable<T: Codable> {
    let key: String
    let defaultValue: T?
    let container: UserDefaults = .standard
    
    var wrappedValue: T? {
        get {
            if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let lodedObject = try? decoder.decode(T.self, from: savedData) {
                    return lodedObject
                }
            }
            return defaultValue
        }
        set {
            let encoder = JSONEncoder()
            if let encodod = try? encoder.encode(newValue) {
                container.set(encodod, forKey: key)
            }
        }
    }
}


extension UserDefaults {

    @UserDeaultHelper(key: "phoneNumber", defaultValue: nil)
    static var phoneNumber: String?
    
    @UserDeaultHelper(key: "FCMToken", defaultValue: nil)
    static var FCMToken: String?
    
    @UserDeaultHelper(key: "nickname", defaultValue: nil)
    static var nickname: String?
    
    @UserDeaultHelper(key: "date", defaultValue: nil)
    static var date: Date?
    
    @UserDeaultHelper(key: "email", defaultValue: nil)
    static var email: String?
    
    @UserDeaultHelper(key: "woman", defaultValue: nil)
    static var gender: Int?
    
    @UserDeaultHelper(key: "idtoken", defaultValue: nil)
    static var idtoken: String?
    
    @UserDeaultHelper(key: "authVerificationID", defaultValue: "")
    static var authVerificationID: String
    
    @UserDeaultHelper(key: "locationAuthorization", defaultValue: false)
    static var locationAuthorization: Bool
    
    // Codable
    @UserDeaultCodable(key: "searchData", defaultValue: nil)
    static var searchData: [SearchSurroundings]?
    
    @UserDeaultCodable(key: "getUerIfo", defaultValue: nil)
    static var getUerIfo: [GetUerIfo]?
}
