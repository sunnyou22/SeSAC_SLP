//
//  Font.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/08.
//
import UIKit

// 여기 전반적으로 수정하기
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

extension BaseView {
    
    func setattributeText(view: UILabel, text: String, location: Int = 0, length: Int = 0, baseColor: UIColor, pointColor: UIColor) -> UILabel {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        view.textColor = .black
        view.numberOfLines = 0
        
        let attributeString = text
        let attributeText = attributeString.setFullAttributed(color: baseColor, paragraphStyle: paragraphStyle)
        
        attributeText.addAttributes([
            .font : UIFont(name: "NotoSansKR-Medium", size: 24)!, .foregroundColor : pointColor], range: NSRange(location: location, length: length))
        
        view.attributedText = attributeText
        
        return view
    }
}

//MARK: - Font
enum FontType {
    case title
    case body
}

extension UIFont {   
    static let Display1_R20 = UIFont(name: "NotoSansKR-Regular", size: 20)
    static let caption_R10 = UIFont(name: "NotoSansKR-Regular", size: 10)
    static let title1_M16 = UIFont(name: "NotoSansKR-Medium", size: 16)
    static let title2_R16 = UIFont(name: "NotoSansKR-Regular", size: 16)
    static let title3_M14 = UIFont(name: "NotoSansKR-Medium", size: 14)
    static let title4_R14 = UIFont(name: "NotoSansKR-Regular", size: 14)
    static let title5_M12 = UIFont(name: "NotoSansKR-Medium", size: 12)
    static let title6_R12 = UIFont(name: "NotoSansKR-Regular", size: 12)
    static let Body1_M16 = UIFont(name: "NotoSansKR-Medium", size: 16)
    static let Body2_R16 = UIFont(name: "NotoSansKR-Regular", size: 16)
    static let Body3_R14 = UIFont(name: "NotoSansKR-Regular", size: 12)
    static let Body1_R12 = UIFont(name: "NotoSansKR-Regular", size: 12)
    
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
    
   fileprivate func setFullAttributed(location: Int = 0, length: Int = 0, color: UIColor, paragraphStyle: NSMutableParagraphStyle) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttributes([.kern: -0.5, .paragraphStyle: paragraphStyle], range: (self as NSString).range(of: self))

        return attributedString
    }
}
