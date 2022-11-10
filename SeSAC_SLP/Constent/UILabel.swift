//
//  Font.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/08.
//
import UIKit

extension UILabel {
    func setBaseLabelStatus(fontsize: CGFloat, font: UIFont, lineHeight: CGFloat, _ text: String) {
        let style = NSMutableParagraphStyle()
        let fontSize: CGFloat = fontsize
        let lineheight = fontSize * lineHeight //font size * multiple
        style.minimumLineHeight = lineheight
        style.maximumLineHeight = lineheight
        self.textAlignment = .center
        self.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: style,
                .baselineOffset: (lineheight - fontSize) / 4
            ])
        
        self.font = font
    }
}

//MARK: - Font
enum FontType {
    case title
    case body
}

extension UIFont {
    
    static let Display1_R20 = UIFont.systemFont(ofSize: 20, weight: .regular)
    static let caption_R10 = UIFont.systemFont(ofSize: 10, weight: .regular)
    static let title1_M16 = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let title2_R16 = UIFont.systemFont(ofSize: 16, weight: .regular)
    static let title3_M14 = UIFont.systemFont(ofSize: 14, weight: .medium)
    static let title4_R14 = UIFont.systemFont(ofSize: 14, weight: .regular)
    static let title5_M12 = UIFont.systemFont(ofSize: 12, weight: .medium)
    static let title6_R14 = UIFont.systemFont(ofSize: 14, weight: .medium)
    static let Body1_M16 = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let Body2_R16 = UIFont.systemFont(ofSize: 16, weight: .regular)
    static let Body3_R14 = UIFont.systemFont(ofSize: 14, weight: .regular)
    static let Body1_R12 = UIFont.systemFont(ofSize: 12, weight: .regular)
    
}

extension String {
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
   func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
         }
}
