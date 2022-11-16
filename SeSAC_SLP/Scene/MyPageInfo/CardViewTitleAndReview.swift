//
//  CardViewTitleAndReview.swift
//  SeSAC_StudyMatchingApp
//
//  Created by Seokjune Hong on 2022/11/15.
//

import UIKit

class CardViewTitleAndReview: BaseView {
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.title6_R12
        view.text = "새싹 타이틀"
        return view
    }()
    
    let titleStackView: UIView = {
        let view = TitleStackView()
        return view
    }()

    lazy var sesacReviewLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.title6_R12
        view.text = "새싹 리뷰"
        return view
    }()

    lazy var reviewLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.Body3_R14
        view.text = "첫 리뷰를 기다리는 중이에요"
        view.numberOfLines = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [titleLabel, titleStackView, sesacReviewLabel, reviewLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalTo(titleLabel.snp.leading)
            make.height.equalTo(200)
            make.width.equalTo(self.snp.width)
        }

        sesacReviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }

        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(sesacReviewLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
