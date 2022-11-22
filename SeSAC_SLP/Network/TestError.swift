//
//  TestError.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/23.
//

import Foundation

enum UserStatus: Int, Error {
    case Success = 200
    case SignInUser = 201
    case InvaliedNickName = 202
    case FirebaseTokenError = 401
    case NotsignUpUser = 406
    case ServerError = 500
    case ClientError = 501
    
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
        case .SignInUser:
            return "이미 가입한 유저입니다."
        case .InvaliedNickName:
            return "사용할 수 없는 닉네임입니다."
        }
    }
}

enum QueueSearchStatus: Int, Error {
    case Success = 200
    case FirebaseTokenError = 401
    case NotsignUpUser = 406
    case ServerError = 500
    case ClientError = 501
    
    var queuemessage: String {
        switch self {
        case .Success:
            return "매칭성공"
        case .FirebaseTokenError:
            return "누군가와 스터디를 함께하기로 약속하셨어요!"
        case .ServerError:
            return "알 수 없는 에러입니다. 고객센터로 문의주세요!"
        case .ClientError:
            return "알 수 없는 에러입니다. 고객센터로 문의주세요!"
        case .NotsignUpUser:
            return "미가입회원입니다."
        }
    }
}

enum QueueStatus: Int, Error {
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

enum MyQueueStatus: Int, Error {
    case Success = 200
    case defaultStatus = 201
    case FirebaseTokenError = 401
    case NotsignUpUser = 406
    case ServerError = 500
    case ClientError = 501
}

enum TestMessage {
    // 공통에러 멘트
    case defaultQueueMessage(QueueSearchStatus)
    case defaultSignupMessage(UserStatus)
  
    // 세부 에러 멘트
    case QueueText(ServerStatus.QueueError)
    case Signup(ServerStatus.UserError)
    
    case AuthVerifyPhoneNumber(AuthVerifyPhoneNumber)
    case AuthCredentialText(AuthCredentialText)
}
