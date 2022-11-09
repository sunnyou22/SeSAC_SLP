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
        return "http://api.sesac.co.kr:1207"
    }
}

enum SeSACAPI {
    case signUp(nick: String, phoneNumber: String, birth: String, email: String, gender: Int)
    case logIn(phoneNumber: String)
}

extension SeSACAPI {
    
    //MARK: URL
    var url: URL {
        switch self {
        case .signUp:
            return URL(string: URLConstant.BaseURL + "/v1/user")!
        case .logIn:
            return URL(string: URLConstant.BaseURL + "/v1/user")!
        }
    }
    
    //MARK: Header
    func getheader(idtoken: String) -> HTTPHeaders {
        switch self {
        case .signUp:
            return [
                "idtoken": idtoken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .logIn:
            return [
                "idtoken": idtoken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        }
    }

    
}
