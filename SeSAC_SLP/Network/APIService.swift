//
//  APIService.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/10.
//

import Foundation

import Alamofire

enum SignUpError: Int, Error {
    case Success = 200
    case SignInUser = 201
    case InvaliedNickName = 202
    case FirebaseTokenError = 401
    case NotsignUpUser = 406
    case ServerError = 500
    case ClientError = 501
}

// MARK: - SignUp
struct SignUp: Codable {
    let phoneNumber, fcMtoken, nick, birth: String
    let email: String
    let gender: Int
    
    enum CodingKeys: String, CodingKey {
        case phoneNumber
        case fcMtoken = "FCMtoken"
//        UserDefaults.standard.string(forKey: "FCMToken")
        case nick, birth, email, gender
    }
}

// MARK: - Welcome
struct LogIn: Codable {
    let id: String
    let v: Int
    let uid, phoneNumber, email, fcMtoken: String
    let nick, birth: String
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
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case uid, phoneNumber, email
        case fcMtoken = "FCMtoken"
//        UserDefaults.standard.string(forKey: "FCMToken")
        case nick, birth, gender, study, comment, reputation, sesac, sesacCollection, background, backgroundCollection, purchaseToken
        case transactionID = "transactionId"
        case reviewedBefore, reportedNum, reportedUser, dodgepenalty, dodgeNum, ageMin, ageMax, searchable, createdAt
    }
}

