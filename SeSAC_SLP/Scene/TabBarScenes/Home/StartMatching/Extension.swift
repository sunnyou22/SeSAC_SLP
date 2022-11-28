//
//  Extension.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/28.
//

import UIKit

extension StartMatcingViewController {
    //MARK: - 뷰컨 타입
    enum Vctype {
        case near
        case requested
        
        var title: String {
            switch self {
            case .near:
                return "주변 새싹"
            case .requested:
                return "받은 요청"
            }
        }
        
        var buttonTitle: String {
            switch self {
            case .near:
                return "요청하기"
            case .requested:
                return "수락하기"
            }
        }
        
        var buttonColor: UIColor {
            switch self {
            case .near:
                return .setStatus(color: .error)
            case .requested:
                return .setStatus(color: .success)
            }
        }
    }
}
