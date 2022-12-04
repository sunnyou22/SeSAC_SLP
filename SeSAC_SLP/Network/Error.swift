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

struct ServerStatus {
    
    enum Common: Int, Error {
        case Success = 200
        case FirebaseTokenError = 401
        case NotsignUpUser = 406
        case ServerError = 500
        case ClientError = 501
        
        //공통에러에 대한 개별적인 처리
        var signupMessage: String {
            switch self {
            case .Success:
                return "회원가입성공"
            case .FirebaseTokenError:
                return "재인증 필요"
            case .ServerError:
                return "알 수 없는 에러입니다. 고객센터로 문의주세요!"
            case .ClientError:
                return "알 수 없는 에러입니다. 고객센터로 문의주세요!"
            case .NotsignUpUser:
                return "미가입회원입니다."
            }
        }
        
        var queuemessage: String {
            switch self {
            case .Success:
                return "매칭성공"
            case .FirebaseTokenError:
                return "토큰갱신!"
            case .ServerError:
                return "알 수 없는 에러입니다. 고객센터로 문의주세요!"
            case .ClientError:
                return "알 수 없는 에러입니다. 고객센터로 문의주세요!"
            case .NotsignUpUser:
                return "미가입회원입니다."
            }
        }
    }
    
    // 개별 에러 분리
    enum UserError: Int, Error {
        case SignInUser = 201
        case InvaliedNickName = 202
        
        var message: String {
            switch self {
            case .SignInUser:
                return "이미 가입한 유저입니다."
            case .InvaliedNickName:
                return "사용할 수 없는 닉네임입니다."
            }
        }
    }
    
    enum QueueError: Int, Error {
        case threeTimesReport = 201
        case firstPenalty = 203
        case secondPenalty = 204
        case thirdPenalty = 205
        
        var message: String {
            switch self {
            case .threeTimesReport:
                return "신고가 누적되어 이용하실 수 없습니다"
            case .firstPenalty:
                return "스터디 취소 패널티로, 1분동안 이용하실 수 없습니다"
            case .secondPenalty:
                return "스터디 취소 패널티로, 2분동안 이용하실 수 없습니다"
            case .thirdPenalty:
                return "스터디 취소 패널티로, 3분동안 이용하실 수 없습니다"
            }
        }
    }
    
    enum MyQueueState: Int, Error {
        case defaultStatus = 201
    }
}

//MARK: 메세지
enum Message {
    // 공통에러 멘트
    case defaultQueueMessage(ServerStatus.Common)
    case defaultSignupMessage(ServerStatus.Common)
  
    // 세부 에러 멘트
    case QueueText(ServerStatus.QueueError)
    case Signup(ServerStatus.UserError)
    
    case AuthVerifyPhoneNumber(AuthVerifyPhoneNumber)
    case AuthCredentialText(AuthCredentialText)
}

//MARK: - 파이어베이스 오류

// 오류 묶기 - 실제 사용
enum CustomAuth {
    case AuthVerifyPhoneNumber(AuthVerifyPhoneNumber)
    case AuthCredentialText(AuthCredentialText)
}

// 핸드폰 번호 오류
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

// 번호인증 오류
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
