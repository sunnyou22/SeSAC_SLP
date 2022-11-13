//
//  Error.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import Foundation

enum SignUpError: Int, Error {
    case Success = 200
    case SignInUser = 201
    case InvaliedNickName = 202
    case FirebaseTokenError = 401
    case NotsignUpUser = 406
    case ServerError = 500
    case ClientError = 501
}

enum AuthVerifyPhoneNumber {
    case success
    case otherError
    case invalidPhoneNumber
    case tooManyRequests
    
    var 
}

enum AuthCredential {
    case missingVerificationID
    case invalidVerificationID
    case invalidUserToken
    case otherError
}
