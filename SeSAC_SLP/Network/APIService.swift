//
//  APIService.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/10.
//

import Foundation

import Alamofire

enum SignUpError: Int, Error {
    case SignInUser = 201
    case InvaliedNickName = 202
    case FirebaseTokenError = 401
    case NotsignUpUser = 406
    case ServerError = 500
    case ClientError = 501
}

// MARK: - SignUp
struct SignUp: Codable {
    let phoneNumber: String
    let fcMtoken: String
    let nick: String
    let birth: Date
    let email: String
    let gender: Int
    
    enum CodingKeys: CodingKey {
        case phoneNumber
        case fcMtoken
        //        UserDefaults.standard.string(forKey: "FCMToken")
        case nick
        case birth
        case email
        case gender
    }
}

// MARK: - Welcome
struct LogIn: Codable {
    let id: String
    let v: Int
    let uid, phoneNumber, email, fcMtoken: String
    let nick: String
    let birth: Date
    let gender: Int
    let study: String
    let comment: [String]
    let reputation: [Int]
    let sesac: Int
    let sesacCollection: [Int]
    let background: Int
    let backgroundCollection: [Int]
    let purchaseToken, transactionID, reviewedBefore: [String]
    let reportedNum: Int
    let reportedUser: [String]
    let dodgepenalty, dodgeNum, ageMin, ageMax: Int
    let searchable: Int
    let createdAt: Date

    enum CodingKeys: CodingKey {
        case id
        case v
        case uid, phoneNumber, email
        case fcMtoken
//        UserDefaults.standard.string(forKey: "FCMToken")
        case nick, birth, gender, study, comment, reputation, sesac, sesacCollection, background, backgroundCollection, purchaseToken
        case transactionID
        case reviewedBefore, reportedNum, reportedUser, dodgepenalty, dodgeNum, ageMin, ageMax, searchable, createdAt
    }
}

