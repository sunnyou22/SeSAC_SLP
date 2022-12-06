//
//  ShopConstants.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/06.
//

import Foundation

struct BaseBundle {
    static var id: String {
        return "com.memolease.sesac1"
    }
}

struct Product {
    static var name: String {
        return ".sprout"
    }
    
    static var backgound: String {
        return ".background"
    }
}

enum SesacProductIndex: Int, CaseIterable {
    case one
    case two
    case three
    case four
}

enum BackProductIndex: Int, CaseIterable {
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
}

extension SesacProductIndex {
    
    var SeSAC: String {
        switch self {
        case .one, .two, .three, .four:
            return BaseBundle.id + Product.name + "\(self.rawValue + 1)"
        }
    }
}


extension BackProductIndex {
    var Background: String {
        switch self {
        case .one, .two, .three, .four, .five, .six, .seven:
            return BaseBundle.id + Product.backgound + "\(self.rawValue + 1)"
        }
    }
}


