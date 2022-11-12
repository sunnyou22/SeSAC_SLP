//
//  PickerView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/08.
//

import UIKit

class ComponentView: BaseView {
    
    var str: String
    let spacing = 16
    
    let datePiceker: UIDatePicker = {
       let view = UIDatePicker()
        view.datePickerMode = .date
        view.preferredDatePickerStyle = .wheels
        view.locale = Locale(identifier: "ko-kr")
        return view
    }()
    
    init(str: String) {
        self.str = str
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var dateTextField: UITextField = {
        let view = UITextField()
        view.inputView = datePiceker
        view.textColor = .setBaseColor(color: .black)
        view.font = .title4_R14
        view.tintColor = .clear
//        view.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        return view
    }()
    
   lazy var label: UILabel = { [weak self] in
        let view = UILabel()
        view.text = self?.str
       view.textColor = .setBaseColor(color: .black)
        return view
    }()
    
    let sectionBar: UIView = {
       let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    override func configure() {
        [label, dateTextField, sectionBar].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        label.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).priority(251)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(28)
//            make.trailing.lessThanOrEqualTo(label.snp.leading).offset(-40)
            make.width.greaterThanOrEqualTo(32)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        sectionBar.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(label.snp.leading)
            make.height.equalTo(1)
        }
    }
}

//MARK: mainview
final class PickerView: BaseView {
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "테스트타이틀입니다"
        view.numberOfLines = 0
        view.setBaseLabelStatus(fontsize: 20, font: .Display1_R20!, lineHeight: 1.6, view.text!)
        view.textAlignment = .center
        view.tintColor = .setBaseColor(color: .black)
        return view
    }()
    
    let yearView = ComponentView(str: "년")
    let monthView = ComponentView(str: "월")
    let dateView = ComponentView(str: "일")

    let nextButton: UIButton = {
        let view = UIButton()
        view.setTitle(literalString.nextButton.title(vc: .first), for: .normal)
        view.backgroundColor = .setBrandColor(color: .green)
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 16
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .setBaseColor(color: .white)
        setcontents(type: .birthDay, label: titleLabel, button: nextButton, subtitle: nil)
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
            make.bottom.equalTo(stackView.snp.top).offset(-92)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(-72)
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(self.snp.centerY)
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
}
