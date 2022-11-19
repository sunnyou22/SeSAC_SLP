//
//  APIService.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/10.
//

import Foundation

import Alamofire


// MARK: - SignUp
struct SignUp: Codable {
    let phoneNumber: String
    let fcmToken: String
    let nick: String
    let birth: String
    let email: String
    let gender: Int
    
    enum CodingKeys: String, CodingKey {
        case phoneNumber, nick, birth, email, gender
        case fcmToken = "FCMtoken"
    }
}

// MARK: - Login
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
    
    //string을 없애도 200으로 통신이 되지만 error로 들어옴
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case uid, phoneNumber, email
        case fcMtoken = "FCMtoken"
        case nick, birth, gender, study, comment, reputation, sesac, sesacCollection, background, backgroundCollection, purchaseToken
        case transactionID = "transactionId"
        case reviewedBefore, reportedNum, reportedUser, dodgepenalty, dodgeNum, ageMin, ageMax, searchable, createdAt
    }
}

//MARK: Match

struct Search: Codable, Hashable {
    let fromQueueDB, fromQueueDBRequested: [FromQueueDB]
    let fromRecommend: [String] // 디퍼블 반영
}
    // MARK: - FromQueueDB
    struct FromQueueDB: Codable, Hashable {
        let uid, nick: String
        let lat, long: Double
        let reputation: [Int]
        let studylist, reviews: [String] // 디퍼플 반여
        let gender, type, sesac, background: Int
    
}

//MARK: - MAP

struct Map: Codable {
    let lat, long: Double
}

//MARK: SetUserInfo
struct SetUserInfo: Codable {
    let searchable, ageMin, ageMax, gender: Int
    let study: String
}
