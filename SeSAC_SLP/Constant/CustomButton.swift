//
//  CustomButton.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/28.
//

import UIKit

final class CutsomButton: UIButton {
    
    enum BtnType {
        case defaultOk
        case defaultNo
        // 더 넣기
        func setTitle() -> String {
            switch self {
            case .defaultOk:
                return "확인"
            case .defaultNo:
                return "취소"
            }
        }
    }
    
    var customtype: BtnType
    
    init(customtype: BtnType) {
        self.customtype = customtype
        super.init(frame: .zero)
    }
    
    func defaultSetting() {
        //타이틀
        self.setTitle(customtype.setTitle(), for: .normal)
        //보더
        self.clipsToBounds = true
        self.layer.cornerRadius = CustomCornerRadius.button.rawValue
        //컬러
        switch customtype {
        case .defaultOk:
            self.backgroundColor = .setBrandColor(color: .green)
        case .defaultNo:
            self.backgroundColor = .setGray(color: .gray2)
        }
        //타이틀 컬러
        switch customtype {
        case .defaultOk:
            self.setTitleColor(.setBaseColor(color: .white), for: .normal)
        case .defaultNo:
            self.setTitleColor(.setBaseColor(color: .black), for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
