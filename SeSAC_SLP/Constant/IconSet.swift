//
//  IconSet.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/13.
//

import Foundation

enum Icon: String {
    case navigationBackButton = "arrow"
    case refreshButton = "arrow.clockwise"
    case inactsender
    case actsender
    
    enum ChatIcon: String {
        case siren = "siren"
        case cancelmatch = "cancel_match"
        case write = "write"
        case more
        
        var title: String {
            switch self {
            case .cancelmatch:
                return "스터디 취소"
            case .siren:
                return "새싹 신고"
            case .write:
                return "리뷰 등록"
            default:
                break
            }
        }
    }
}
