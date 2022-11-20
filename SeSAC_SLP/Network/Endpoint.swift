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
    case getUserInfo
    case search(lat: Double, long: Double)
    case setMypage(searchable: Int, ageMin: Int, ageMax: Int, gender: Int, study: String)
}

extension SeSACAPI {
    
    //MARK: URL
    var url: URL {
        switch self {
        case .signUp:
            return URL(string: URLConstant.BaseURL + "/v1/user")!
        case .getUserInfo:
            return URL(string: URLConstant.BaseURL + "/v1/user")!
        case .search:
            return URL(string: URLConstant.BaseURL + "/v1/queue/search")!
        case .setMypage:
            return URL(string: URLConstant.BaseURL + "/v1/user/mypage")!
        }
    }
    
    //MARK: Header
    func getheader(idtoken: String) -> HTTPHeaders {
        switch self {
        case .signUp, .setMypage:
            return [
                "idtoken": idtoken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .getUserInfo, .search:
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
        case .search(let lat, let long):
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
        }
    }
}
