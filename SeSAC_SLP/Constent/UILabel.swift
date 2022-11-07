//
//  Font.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/08.
//
import UIKit

extension UILabel {
    static func CustomFont(label: UILabel, _ text: String) {
        let style = NSMutableParagraphStyle()
        let fontSize: CGFloat = 20
        let lineheight = fontSize * 1.6  //font size * multiple
        style.minimumLineHeight = lineheight
        style.maximumLineHeight = lineheight
        
        label.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: style,
                .baselineOffset: (lineheight - fontSize) / 4
            ])
        
        label.font = .systemFont(ofSize: fontSize, weight: .regular)
    }
}
