//
//  UIImage.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/15.
//

import UIKit

extension UIImage {
   static func setBackground(imagename: ImageSet) -> Self {
        
        switch imagename {
        case .background(let background):
            return self.init(named: background.literal)!
        case .sesacFace(let sesac):
            return self.init(named: sesac.face)!
        }
    }
}
