//
//  Enum.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/08.
//

import Foundation

//MARK: - 문자열 처리

enum Vc {
    case first, second, nickname, birthDay, email, gender
}

enum literalString: Int, CaseIterable {
    case sceneTitle
    case subTitle
    case nextButton
    
    func title(vc: Vc) -> String {
        switch self {
        case .sceneTitle:
            switch vc {
            case .first:
                return "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해주세요"
            case .second:
                return "인증번호가 문자로 전송되었어요"
            case .nickname:
                return "닉네임을 입력해 주세요"
            case .birthDay:
                return "생년월일을 알려주세요"
            case .email:
                return "이메일을 입력해 주세요"
            case .gender:
                return "성별을 선택해주세요"
            }
            
        case .nextButton:
            switch vc {
            case .first:
                return "인증 문자 받기"
            case .second:
                return "인증하고 시작하기"
            default:
                return "다음"
            }
           
        case .subTitle:
            switch vc {
            case .email:
                return "휴대폰 번호 변경 시 인증을 위해 사용해요"
            case .gender:
                return "새싹 찾기 기능을 이용하기 위해서 필요해요!"
            default:
                return ""
            }
        }
    }
}

//MARK: - layer처리

enum CustomCornerRadius: CGFloat {
    case button = 8
}

//MARK: - 뷰 나누기

enum CommonSignView {
    case verification
    case signIn
}

