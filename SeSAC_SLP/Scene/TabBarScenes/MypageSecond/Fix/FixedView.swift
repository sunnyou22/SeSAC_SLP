//
//  FixedView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit

final class FixedView: BaseView {
    
    let genderView: MyPageGenderView = {
        let view = MyPageGenderView()
        view.backgroundColor = .green
        return view
    }()
    
    let setFrequentStudyView: SetFrequentStudyView = {
        let view = SetFrequentStudyView()
        view.backgroundColor = .blue
        return view
    }()
    
    let switchView: SwitchView = {
        let view = SwitchView()
        view.backgroundColor = .cyan
        return view
    }()
    
    let matchingAgeView: MatchingAgeView = {
        let view = MatchingAgeView()
        view.backgroundColor = .black
        return view
    }()
    
    let signOutView: SignOutView = {
        let view = SignOutView()
        view.backgroundColor = .cyan
        return view
    }()
    
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .brown
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 16
        return view
    }()
    //    slider.addTarget(self, action: #selector(changeValue), for: .valueChanged)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [genderView, setFrequentStudyView, switchView, matchingAgeView, signOutView].forEach { stackView.addArrangedSubview($0) }
        self.addSubview(stackView)
    }
    
    override func setConstraints() {
        
        genderView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(60)
            make.width.equalTo(self.snp.width)
        }
        
        setFrequentStudyView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(60)
            make.width.equalTo(self.snp.width)
        }
        
        switchView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(60)
            make.width.equalTo(self.snp.width)
        }
        
        matchingAgeView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(80)
            make.width.equalTo(self.snp.width)
        }
        
        signOutView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(60)
            make.width.equalTo(self.snp.width)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

