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

enum BaseColorSet {
    case base(_ : String, color: UIColor)
    case brandcolor(_ : String, color: UIColor)
    case gray(num: Int, color: UIColor)
    case systemColor(status: String, color: UIColor)
}

 struct CutsomColor {
    static let white: BaseColorSet = .base("white", color: .white)
    static let black: BaseColorSet = .base("black", color: .black)
    static let green: BaseColorSet = .brandcolor("green", color: UIColor(hex: "#49DC92"))
    static let whiteGreen: BaseColorSet = .brandcolor("whitegreen", color: UIColor(hex: "#CDF4E1"))
    static let yellowGreen: BaseColorSet = .brandcolor("yellowgreen", color: UIColor(hex: "#B2EB61"))
    static let gray1: BaseColorSet = .gray(num: 1, color: UIColor(hex: "#F7F7F7"))
    static let gray2: BaseColorSet = .gray(num: 2, color: UIColor(hex: "#EFEFEF"))
    static let gray3: BaseColorSet = .gray(num: 3, color: UIColor(hex: "#E2E2E2"))
    static let gray4: BaseColorSet = .gray(num: 4, color: UIColor(hex: "#D1D1D1"))
    static let gray5: BaseColorSet = .gray(num: 5, color: UIColor(hex: "#BDBDBD"))
    static let gray6: BaseColorSet = .gray(num: 6, color: UIColor(hex: "#AAAAAA"))
    static let gray7: BaseColorSet = .gray(num: 7, color: UIColor(hex: "#888888"))
    static let success: BaseColorSet = .systemColor(status: "success", color: UIColor(hex: "#628FE5"))
    static let error: BaseColorSet = .systemColor(status: "error", color: UIColor(hex: "#E9666B"))
    static let focus: BaseColorSet = .systemColor(status: "focus", color: UIColor(hex: "#333333"))
}
