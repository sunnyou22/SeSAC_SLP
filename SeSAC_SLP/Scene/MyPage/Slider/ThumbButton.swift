//
//  ThumbButton.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/15.
//

//MARK: ThumbBUttonUI
import UIKit
import SnapKit

//rx로 이벤트 받기
class ThumbButton: RoundableButton {
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = self.isSelected ? .lightGray : .white
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowColor = UIColor.setBaseColor(color: .black).cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.gray.withAlphaComponent(0.1).cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min((max(self, limits.lowerBound)), limits.upperBound)
    }
}
