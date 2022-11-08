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
