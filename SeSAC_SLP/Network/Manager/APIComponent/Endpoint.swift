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
    case studyRequest(otheruid: String)
}

// 폴더 나눌 때 버전 빼기
extension SeSACAPI {
    
    //MARK: URL
    var url: URL {
        switch self {
        case .signUp:
            return URL(string: URLConstant.BaseURL + "/v1/user")!
        case .getUserInfo:
            return URL(string: URLConstant.BaseURL + "/v1/user")!
        case .searchSurroundings:
            return URL(string: URLConstant.BaseURL + "/v1/queue/search")! // 주변탐색
        case .setMypage:
            return URL(string: URLConstant.BaseURL + "/v1/user/mypage")!
        case .matchingStatus:
            return URL(string: URLConstant.BaseURL + "/v1/queue/myQueueState")!
        case .search:
            return URL(string: URLConstant.BaseURL + "/v1/queue")! // 새싹 찾기 검색
        case .studyRequest:
            return URL(string: URLConstant.BaseURL + "/v1/queue/studyrequest")!
        }
    }
    
    //MARK: Header
    func getheader(idtoken: String) -> HTTPHeaders {
        switch self {
        case .signUp, .setMypage, .search, .studyRequest:
            return [
                "idtoken": idtoken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .getUserInfo, .searchSurroundings, .matchingStatus:
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
        case .getUserInfo:
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
        case .matchingStatus:
            return nil
        case .search(let lat, let lon, let studylist):
            return [
                "long": lon,
                "lat": lat,
                "studylist": studylist
            ]
        case .studyRequest(otheruid: let otheruid):
            return [
                "otheruid": otheruid
            ]
        }
    }
}
