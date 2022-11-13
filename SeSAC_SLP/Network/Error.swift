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
    
    var message: String {
        switch self {
        case .success:
            return "전화번호 파베로 보내기 성공"
        case .otherError:
            return "에러가 발생했습니다. 다시 시도해주세요"
        case .invalidPhoneNumber:
            return "잘못된 전화번호 형식입니다."
        case .tooManyRequests:
           return "과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요."
        }
    }
}

enum AuthCredential {
    case missingVerificationID
    case invalidVerificationID
    case invalidUserToken
    case otherError
    
    var message: String {
        switch self {
        case .missingVerificationID:
            return "잘못된 전화번호 형식입니다"
        case .invalidVerificationID:
            return "전화 번호 인증 실패입니다."
        case .invalidUserToken:
            return "유효하지 않는 정보입니다. 잠시 후 다시 시도해주세요."
        case .otherError:
            return "에러가 발생했습니다. 다시 시도해주세요."
        }
    }
}
