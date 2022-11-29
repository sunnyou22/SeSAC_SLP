//
//  TestError.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/23.
//

import Foundation

//struc Status { } 이런식으로 묶어볼까

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
            return "ERROR 500. 고객센터로 문의주세요!"
        case .ClientError:
            return "ERROR 501. 고객센터로 문의주세요!"
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

enum StudyRequestStatus: Int, Error {
    case Success = 200
    case Requested = 201
    case FirebaseTokenError = 401
    case NotsignUpUser = 406
    case ServerError = 500
    case ClientError = 501
    
    var massage: String {
        switch self {
        case .Success:
            return "스터디요청을 보냈습니다"
        case .Requested:
            return "이미 매칭중이시네요!"
        case .FirebaseTokenError:
            return "요청대기시간이 지났습니다! 다시 시도해주세요"
        case .NotsignUpUser:
            return "미가입회원입니다"
        case .ServerError:
            return "ERROR 500! 알 수 없는 오류입니다. 고객센터로 문의주세요!"
        case .ClientError:
            return "ERROR 501! 알 수 없는 오류입니다. 고객센터로 문의주세요!"
        }
    }
}

enum DeleteStatus: Int, Error {
    case success = 200
    case matched = 201
    case firebaseTokenError = 401
    case notsignUpUser = 406
    case serverError = 500
    case clientError = 501
    
    var massage: String {
        switch self {
        case .success:
            return "성공적으로 찾기 중단"
        case .matched:
            return "누군가와 스터디를 함께하기로 약속하셨어요! "
        case .firebaseTokenError:
            return "요청대기시간이 지났습니다! 다시 시도해주세요"
        case .notsignUpUser:
            return "미가입회원입니다"
        case .serverError:
            return "ERROR 500! 알 수 없는 오류입니다. 고객센터로 문의주세요!"
        case .clientError:
            return "ERROR 501! 알 수 없는 오류입니다. 고객센터로 문의주세요!"
        }
    }
}

enum StudyAcceptStatus: Int, Error {
    case success = 200
    case othersmatched = 201
    case othersStopSearching = 202
    case accepted = 203
    case firebaseTokenError = 401
    case notsignUpUser = 406
    case serverError = 500
    case clientError = 501
    
    var massage: String {
        switch self {
        case .success:
            return "스터디요청을 수락했습니다"
        case .othersmatched:
            return "상대방이 이미 다른 새싹과 스터디를 함께 하는 중입니다"
        case .firebaseTokenError:
            return "요청대기시간이 지났습니다! 다시 시도해주세요"
        case .notsignUpUser:
            return "미가입회원입니다"
        case .serverError:
            return "ERROR 500! 알 수 없는 오류입니다. 고객센터로 문의주세요!"
        case .clientError:
            return "ERROR 501! 알 수 없는 오류입니다. 고객센터로 문의주세요!"
        case .othersStopSearching:
            return "상대방이 스터디 찾기를 그만두었습니다"
        case .accepted:
            return "앗! 누군가 나의 스터디를 수락했어요!"
        }
    }
}

enum StatusOfFetchingChat: Int, Error {
    case success = 200
    case firebaseTokenError = 401
    case notsignUpUser = 406
    case serverError = 500
    case clientError = 501
    
    var message: String {
        switch self {
        case .success:
            return "채팅목록 가져오기 성공"
        case .firebaseTokenError:
            return "요청대기시간이 지났습니다! 다시 시도해주세요"
        case .notsignUpUser:
            return "미가입회원입니다"
        case .serverError:
            return "ERROR 500"
        case .clientError:
            return "ERROR 501"
        }
    }
}

enum TestMessage {
    // 공통에러 멘트
    case defaultQueueMessage(QueueSearchStatus)
    case defaultSignupMessage(UserStatus)
    
    // 세부 에러 멘트
    case QueueText(ServerStatus.QueueError)
    case Signup(ServerStatus.UserError)
    case StudyRequestStatus(StudyRequestStatus)
    case StudyAcceptedStatus(StudyAcceptStatus)
    case DeleteStatus(DeleteStatus)
    
    case AuthVerifyPhoneNumber(AuthVerifyPhoneNumber)
    case AuthCredentialText(AuthCredentialText)
}
