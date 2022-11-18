//
//  UIButtom.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/15.
//

import UIKit

class RoundableButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        self.setImage(UIImage(named: "filter_control"), for: .normal)
    }
}
