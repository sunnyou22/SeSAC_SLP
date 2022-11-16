//
//  ExpandableTableView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit
import Foundation
import SnapKit

struct CellData {
    var opened = Bool() // 테이블뷰를 접었다 폈다
    var title = String() // title 카테고리에 해당하는 문자열
    var setionData = [String]() //카테코리 내 아이뎀들에 해당하는 문자열 리스트
}


//MARK: 헤더
class Header: BaseView {
    let sesacImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "xmark")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "xmark")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        
        imageView.addSubview(sesacImage)
        self.addSubview(imageView)
    }

    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(16)
            make.height.equalTo(imageView.snp.width).multipliedBy(0.57)
            self.layoutIfNeeded()
        }
        sesacImage.snp.makeConstraints { make in
            make.centerX.equalTo(imageView.snp.centerX)
            make.bottom.equalTo(imageView.snp.bottom).offset(-8)
        }
    }
}

//MARK: 아래 테이블 뷰
class ExpandableStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
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
       return view.setStackViewLayout(axis: .vertical, color: .orange)
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
        return
    }()
    
 let titleStackview = TitleStackView()
    
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
       return view.setStackViewLayout(axis: .vertical, color: .black)
    }()
    
    func configure() {
        self.backgroundColor = .brown
        nameContainView.addSubview(nameLabel)
        
        [titleLabel, titleStackview].forEach { titleVIew.addSubview($0) }
        
        [reviewLabel, reviewtitle].forEach { review.addSubview($0) }
        
        [titleVIew, review].forEach { infoContainView.addArrangedSubview($0) }
        
        [infoContainView, nameContainView].forEach { self.addArrangedSubview($0) }
    }
    
    func setConstraints() {
        //이름
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameContainView.snp.leading).offset(16)
            make.centerY.equalTo(nameContainView.snp.centerY)
        }
        
        nameContainView.snp.makeConstraints { make in
            make.height.equalTo(58)
            make.leading.equalTo(self.snp.leading)
        }
        
        // 타이틀, 리뷰
        infoContainView.snp.makeConstraints { make in
            make.top.equalTo(nameContainView.snp.bottom)
            make.leading.equalTo(self.snp.leading).inset(16)
            make.centerX.equalTo(self.snp.centerY)
        }
        
        // 타이틀
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(infoContainView.snp.top)
            make.leading.equalTo(infoContainView.snp.leading)
        }
        
        titleStackview.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            
        }
        
        titleVIew.snp.makeConstraints { make in
            make.leading.equalTo(infoContainView.snp.leading)
            make.centerX.equalTo(infoContainView.snp.centerY)
            make.bottom.equalTo(titleStackview.snp.bottom)
        }
        
        //리뷰
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(review.snp.top)
            make.leading.equalTo(review.snp.leading)
        }
        
        reviewtitle.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.top).offset(16)
            make.leading.equalTo(review.snp.leading)
            make.bottom.equalTo(review.snp.bottom)
        }
    }
}
