//
//  Enum.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/08.
//

import Foundation

enum Vc {
    case first, second
}

enum literalString: Int, CaseIterable {
    case scene
    case nextButton
    
    func title(vc: Vc) -> String {
        switch self {
        case .scene:
            switch vc {
            case .first:
                return "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해주세요"
            case .second:
                return "인증번호가 문자로 전송되었어요"
            }
        case .nextButton:
            switch vc {
            case .first:
                return "인증 문자 받기"
            case .second:
                return "인증하고 시작하기"
            }
        }
    }
}

enum CustomCornerRadius: CGFloat {
    case button = 8
}
