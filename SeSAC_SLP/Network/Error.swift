//
//  Error.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import Foundation
import UIKit

/*
 에러를 공통사항하고 개별사항하고 분리하기
 그리고 그 둘을 하나의 케이스로 묶어서 연관값으로 호출
 안그러면 에러케이스 다 외워야할듯
 */

enum SignUpError: Int, Error {
    case Success = 200
    case SignInUser = 201
    case InvaliedNickName = 202
    case FirebaseTokenError = 401
    case NotsignUpUser = 406
    case ServerError = 500
    case ClientError = 501
    
    var message: String {
        switch self {
        case .Success:
            return "인증이력이 있으시군요! 회원가입화면으로 이동하겠습니다."
        case .SignInUser:
            return "이미 가입한 회원입니다."
        case .InvaliedNickName:
            return "유효하지 않는 닉네임입니다."
        case .FirebaseTokenError:
            return "인증번호가 만료됐습니다. 다시 버튼을 눌러주세요."
        case .NotsignUpUser:
            return "처음 방문하셨군요! 회원가입화면으로 넘어가시겠습니까?"
        case .ServerError:
            return "ServerError"
        case .ClientError:
            return "알 수 없는 에러입니다. 고객센터로 문의주세요"
        }
    }
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

enum AuthCredentialText {
    case success
    case missingVerificationID
    case invalidVerificationID
    case invalidUserToken
    case otherError
    
    var message: String {
        switch self {
        case .success:
            return "번호인증 성공 🟢"
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

enum CustomAuth {
    
    case AuthVerifyPhoneNumber(AuthVerifyPhoneNumber)
    case AuthCredentialText(AuthCredentialText)
    case SignUpError(SignUpError)
}
