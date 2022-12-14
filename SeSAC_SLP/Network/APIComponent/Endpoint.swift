//
//  Endpoint.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/10.
//

import Foundation

import Alamofire

//MARK: baseURL
struct URLConstant {
    static var BaseURL: String {
        return "http://api.sesac.co.kr:1210"
    }
}

enum SeSACAPI {
    case signUp(phoneNumber: String, FCMtoken: String, nick: String, birth: Date, email: String, gender: Int)
    case getUserInfo // get
    case searchSurroundings(lat: Double, long: Double)
    case setMypage(searchable: Int, ageMin: Int, ageMax: Int, gender: Int, study: String)
    case matchingStatus //get
    case search(lat: Double, lon: Double, studylist: [String])
    case delete
    case studyRequest(otheruid: String), studyAccept(otheruid: String), dodge(otheruid: String)
    case chatList(from: String, lastchatDate: String)
    case chat(to: String, chat: String)
    case review(otheruid: String, reputation: [Int], comment: String)
    case shopmyinfo
    case receiptVelidation(receipt: String, product: String)
    case useritem(sesac: Int, background: Int)
}

// 폴더 나눌 때 버전 빼기
extension SeSACAPI {
    
    //MARK: URL
    var url: URL {
        switch self {
        case .signUp, .getUserInfo:
            return URL(string: URLConstant.BaseURL + "/v1/user")!
        case .searchSurroundings:
            return URL(string: URLConstant.BaseURL + "/v1/queue/search")! // 주변탐색
        case .setMypage:
            return URL(string: URLConstant.BaseURL + "/v1/user/mypage")!
        case .matchingStatus:
            return URL(string: URLConstant.BaseURL + "/v1/queue/myQueueState")!
        case .search, .delete:
            return URL(string: URLConstant.BaseURL + "/v1/queue")! // 새싹 찾기 검색
        case .studyRequest:
            return URL(string: URLConstant.BaseURL + "/v1/queue/studyrequest")!
        case .studyAccept:
            return URL(string: URLConstant.BaseURL + "/v1/queue/studyaccept")!
        case .chatList(let from, let lastchatDate):
            return URL(string: URLConstant.BaseURL + "/v1/chat/\(from)?lastchatDate=\(lastchatDate)")! //중괄호있는거 맞나?
        case .chat(let to, _):
            return URL(string: URLConstant.BaseURL + "/v1/chat/\(to)")!
        case .dodge:
            return URL(string: URLConstant.BaseURL + "/v1/queue/dodge")!
        case .review(let id, _, _):
            return URL(string: URLConstant.BaseURL + "/v1/queue/rate/\(id)")!
        case .shopmyinfo:
            return URL(string: URLConstant.BaseURL + "/v1/user/shop/myinfo")!
        case .receiptVelidation:
            return URL(string: URLConstant.BaseURL + "/v1/user/shop/ios")!
        case .useritem:
            return URL(string: URLConstant.BaseURL + "/v1/user/shop/item")!
        }
    }
    
    //MARK: Header
    func getheader(idtoken: String) -> HTTPHeaders {
        switch self {
        case .signUp, .setMypage, .search, .studyRequest, .chatList, .chat, .studyAccept, .dodge, .review, .receiptVelidation, .useritem:
            return [
                "idtoken": idtoken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .getUserInfo, .searchSurroundings, .matchingStatus, .delete, .shopmyinfo:
            return [
                "idtoken": idtoken
            ]
        }
    }
    
    //데이터 넣어주는 바구닝
    var parameter: [String: Any]? {
        switch self {
        case .signUp(let phoneNumber, let FCMtoken, let nick, let birth, let email, let gender):
            return [
                "phoneNumber": phoneNumber,
                "FCMtoken": FCMtoken,
                "nick": nick,
                "birth": birth,
                "email": email,
                "gender": gender
            ]
        case .getUserInfo, .delete, .matchingStatus, .chatList, .shopmyinfo:
            return nil
        case .searchSurroundings(let lat, let long):
            return [
                "lat": lat,
                "long": long
            ]
        case .setMypage(let searchable, let ageMin, let ageMax, let gender, let study):
            return [
                "searchable" : searchable,
                "ageMin" : ageMin,
                "ageMax" : ageMax,
                "gender" : gender,
                "study" : study
            ]
        case .search(let lat, let lon, let studylist):
            return [
                "long": lon,
                "lat": lat,
                "studylist": studylist
            ]
        case .chat(_, let chat):
            return [
                "chat": chat
            ]
        case .studyRequest(let otheruid), .studyAccept(let otheruid), .dodge(let otheruid):
            return [
                "otheruid": otheruid
            ]
        case .review(let otheruid, let reputation, let comment):
            return [
                "otheruid": otheruid,
                "reputation": reputation,
                "comment": comment
            ]
        case .receiptVelidation(let receipt, let product):
            return [
                "receipt": receipt,
                "product": product
            ]
        case .useritem(let sesac, let background):
            return [
                "sesac": sesac,
                "background": background
            ]
        }
    }
}
