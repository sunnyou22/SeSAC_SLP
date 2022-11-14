//
//  FixedView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit

final class FixedView: UIStackView {
    
    let genderView: MyPageGenderView = {
        let view = MyPageGenderView()
        return view
    }()
    
    let setFrequentStudyView: SetFrequentStudyView = {
        let view = SetFrequentStudyView()
        return view
    }()
    
    let switchView: SwitchView = {
        let view = SwitchView()
        return view
    }()
    
    let matchingAgeView: MatchingAgeView = {
        let view = MatchingAgeView()
        return view
    }()
    
    let signOutView: SignOutView = {
        let view = SignOutView()
        return view
    }()
    
    //    slider.addTarget(self, action: #selector(changeValue), for: .valueChanged)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [genderView, setFrequentStudyView, switchView, matchingAgeView, signOutView].forEach { self.addArrangedSubview($0) }
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.backgroundColor = .brown
        self.axis = .vertical
        self.distribution = .fillEqually
        self.spacing = 16
    }
}

