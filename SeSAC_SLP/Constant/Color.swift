//
//  Color.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/08.
//

import UIKit

extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

extension UIColor {
    static func setBaseColor(color: BaseColorSet) -> UIColor {
        switch color {
        case .white:
            return .white
        case .black:
            return .black
        }
    }
    
    static func setBrandColor(color: BrandColor) -> UIColor {
        switch color {
        case .green:
            return UIColor(hex: "#49DC92")
        case .whiteGreen:
            return UIColor(hex: "#CDF4E1")
        case .yellowGreen:
            return UIColor(hex: "#B2EB61")
        }
    }
    
    static func setGray(color: Gray) -> UIColor {
        switch color {
        case .gray1:
            return UIColor(hex: "#F7F7F7")
        case .gray2:
            return UIColor(hex: "#EFEFEF")
        case .gray3:
            return UIColor(hex: "#E2E2E2")
        case .gray4:
            return UIColor(hex: "#D1D1D1")
        case .gray5:
            return UIColor(hex: "#BDBDBD")
        case .gray6:
            return UIColor(hex: "#AAAAAA")
        case .gray7:
            return UIColor(hex: "#888888")
        }
    }
    
    static func setStatus(color: StatusColor) -> UIColor {
        switch color {
        case .success:
            return UIColor(hex: "#628FE5")
        case .error:
            return UIColor(hex: "#E9666B")
        case .focus:
            return UIColor(hex: "#333333")
        }
    }
}

enum BaseColorSet {
    case black
    case white
}

enum BrandColor {
    case green
    case whiteGreen
    case yellowGreen
}

enum Gray {
    case gray1
    case gray2
    case gray3
    case gray4
    case gray5
    case gray6
    case gray7
}

enum StatusColor {
    case success
    case error
    case focus
}


