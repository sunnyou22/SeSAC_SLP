//
//  ReviewPopView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/01.
//

import UIKit

import SnapKit

final class ReviewPopView: BaseView {
    
    let title: UILabel = {
    let view = UILabel()
        view.text = "리뷰등록"
        view.textColor = .setBaseColor(color: .black)
        view.font = UIFont.title3_M14
        return view
    }()
    
    let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .setBaseColor(color: .white)
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.view_20.rawValue
        return view
    }()
    
    let subtile: UILabel = {
        let view = UILabel()
        view.text = "고래밥님과의 스터디는 어떠셨나요?"
        view.textColor = .setBrandColor(color: .green)
        view.font = .title3_M14
        return view
    }()
    
    let reviewList = TitleStackView()
    
    let closebutton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "xmark"), for: .normal)
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .setGray(color: .gray6)
        view.configuration = config
        return view
    }()
    
    let reviewTextView: UITextView = {
        let view = UITextView(frame: CGRect(x: 0, y: 0, width: .zero, height: 124))
        view.clipsToBounds = true
        view.textColor = .setBaseColor(color: .black)
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        view.backgroundColor = .setGray(color: .gray1)
        view.text = "자세한 피드백은 다른 새싹들에게 도움이 됩니다\n(500자 이내 작성)"
        return view
    }()
    
    let registerButton: UIButton = {
        let view = UIButton()
        view.setTitle("리뷰 등록하기", for: .normal)
        view.backgroundColor = .setGray(color: .gray6)
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [title, subtile, reviewList, reviewTextView, registerButton])
       view.spacing = 24
       view.axis = .vertical
       view.distribution = .equalSpacing
    
       view.backgroundColor = .setBaseColor(color: .white)
        return view
    }()
    
    override func configure() {
        [stackView, closebutton].forEach { baseView.addSubview($0) }
        addSubview(baseView)
    }
    
    override func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(16)
            make.center.equalToSuperview()
        }
        closebutton.snp.makeConstraints { make in
            make.trailing.top.equalTo(stackView)
        }
        reviewTextView.snp.makeConstraints { make in
            make.height.equalTo(124)
            make.horizontalEdges.equalToSuperview()
        }
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.bottom.equalTo(stackView).offset(16)
            make.centerX.equalToSuperview()
        }
        baseView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(stackView).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.center.equalToSuperview()
        }
    }
}
