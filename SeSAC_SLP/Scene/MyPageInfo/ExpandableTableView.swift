////
////  ExpandableTableView.swift
////  SeSAC_SLP
////
////  Created by 방선우 on 2022/11/14.
//
//
import UIKit
import Foundation
import SnapKit


//MARK: 아래 테이블 뷰
class ExpandableStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let view = UILabel()
        view.text = "방선우"
        return view
    }()
    
    let nameContainView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    // 접히는 곳
    let infoContainView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .black
        view.spacing = 8
        view.axis = .vertical
        view.distribution = .fillEqually
        return view
    }()
    
    //섹션타이틀 컨테인뷰
    let titleVIew: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "새싹 타이틀"
        return view
    }()
    
    let titleStackview: UIView = {
        let view = TitleStackView()
       
        return view
    }()
    
    // 리뷰뷰
    let review: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    let reviewtitle: UILabel = {
        let view = UILabel()
        view.text = "새싹 리뷰"
        return view
    }()
    
    let reviewLabel: UILabel = {
        let view = UILabel()
        view.text = "첫 리뷰를 기다리는 중이에요!"
        return view
    }()
    
    // 두컨테이너를 스택뷰로 감싸줌
    let stackView : UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .orange
        view.spacing = 8
        view.axis = .vertical
        view.distribution = .fillEqually
        return view
    }()
    
  
    
    func configure() {
        
        self.backgroundColor = .red
        self.spacing = 8
        self.axis = .vertical
        self.distribution = .fillEqually
        
        self.backgroundColor = .brown
        nameContainView.addSubview(nameLabel)
        
        [titleLabel, titleStackview].forEach { titleVIew.addSubview($0) }
        
        [reviewLabel, reviewtitle].forEach { review.addSubview($0) }
        
        [titleVIew, review].forEach { infoContainView.addArrangedSubview($0) }
        
        [infoContainView, nameContainView].forEach { self.addArrangedSubview($0) }
    }
    
    func setConstraints() {
        //이름
//        nameLabel.snp.makeConstraints { make in
//            make.leading.equalTo(nameContainView.snp.leading).offset(16)
//            make.centerY.equalTo(nameContainView.snp.centerY)
//        }
//
//        nameContainView.snp.makeConstraints { make in
//            make.height.equalTo(58)
//            make.leading.equalTo(self.snp.leading)
//        }
//
//        //         타이틀, 리뷰
//        infoContainView.snp.makeConstraints { make in
//            make.top.equalTo(nameContainView.snp.bottom)
//            make.leading.equalTo(self.snp.leading).inset(16)
//            make.centerX.equalTo(self.snp.centerY)
//        }
//
//        //         타이틀
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(infoContainView.snp.top)
//            make.leading.equalTo(infoContainView.snp.leading)
//        }
//
//        titleStackview.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(16)
//
//        }
//
//        titleVIew.snp.makeConstraints { make in
//            make.leading.equalTo(infoContainView.snp.leading)
//            make.centerX.equalTo(infoContainView.snp.centerY)
//            make.bottom.equalTo(titleStackview.snp.bottom)
//        }
//
//        //        //리뷰
//        reviewLabel.snp.makeConstraints { make in
//            make.top.equalTo(review.snp.top)
//            make.leading.equalTo(review.snp.leading)
//        }
//
//        reviewtitle.snp.makeConstraints { make in
//            make.top.equalTo(reviewLabel.snp.top).offset(16)
//            make.leading.equalTo(review.snp.leading)
//            make.bottom.equalTo(review.snp.bottom)
//        }
    }
}
