//
//  Constants.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/24.
//

import Foundation

enum TabBarIcon: Int, CaseIterable {
    case home
    case shop
    case chat
    case mypage
    
    var Img: String {
        switch self {
        case .home:
            return "홈"
        case .shop:
            return "새싹샵"
        case .chat:
            return "새싹친구"
        case .mypage:
            return "내정보"
        }
    }
}
