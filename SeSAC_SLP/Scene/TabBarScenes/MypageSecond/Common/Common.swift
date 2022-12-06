//
//  Common.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit

//Reuavlekit 나중에 써보기
protocol ReusableViewProtocol: AnyObject {
    static var reuseIdentifier: String { get }
}

extension UIViewController: ReusableViewProtocol {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UIView: ReusableViewProtocol {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

//MARK: - ImgName
enum ImageSet {
    case background(SeSac_Background)
    case sesacFace(Sesac_Face)
}

enum SeSac_Background: Int, CaseIterable {
    case sesac_background_1
    case sesac_background_2
    case sesac_background_3
    case sesac_background_4
    case sesac_background_5
    case sesac_background_6
    case sesac_background_7
    case sesac_background_8
    case sesac_background_9
    
    var str: String {
        switch self {
        default:
            return "\(self)"
        }
    }
}

enum Sesac_Face: Int, CaseIterable {
    case sesac_face_1
    case sesac_face_2
    case sesac_face_3
    case sesac_face_4
    case sesac_face_5
    
    var str: String {
        switch self {
        default:
            return "\(self)"
        }
    }
}

extension UIStackView {
    func setStackViewLayout(axis: NSLayoutConstraint.Axis, color: UIColor) -> Self {
        self.backgroundColor = color
        self.spacing = 8
        self.axis = axis
        self.distribution = .fillEqually
        return self
    }
}
