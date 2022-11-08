//
//  PickerView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/08.
//

import UIKit

class ComponentView: BaseView {
    
    var str: String
    
    init(str: String) {
        self.str = str
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let button: UIButton = {
        let view = UIButton()
        view.backgroundColor = .brown
//        view.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        return view
    }()
    
   lazy var label: UILabel = { [weak self] in
        let view = UILabel()
        view.text = self?.str
        return view
    }()
    
    let sectionBar: UIView = {
       let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    override func configure() {
        [label, button, sectionBar].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        label.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.leading)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        button.snp.makeConstraints { make in
            make.leading.equalTo(28)
            make.trailing.equalTo(label.snp.leading)
        }
        
        sectionBar.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(label.snp.leading)
            make.height.equalTo(1)
        }
    }
}


final class PickerView: BaseView {
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "테스트타이틀입니다"
        return view
    }()
    
    let yearView = ComponentView(str: "년")
    let monthView = ComponentView(str: "월")
    let dateView = ComponentView(str: "일")

    let nextButton: UIButton = {
        let view = UIButton()
        view.setTitle(literalString.nextButton.title(vc: .first), for: .normal)
        view.backgroundColor = .setBaseColor(color: .white)
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 28
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [yearView, monthView, dateView].forEach { stackView.addArrangedSubview($0) }
        [titleLabel, stackView, nextButton].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(124)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(72)
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
}
