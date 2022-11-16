//
//  ExpandableTableView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit

struct CellData {
    var opened = Bool() // 테이블뷰를 접었다 폈다
    var title = String() // title 카테고리에 해당하는 문자열
    var setionData = [String]() //카테코리 내 아이뎀들에 해당하는 문자열 리스트
}


//MARK: 헤더
class Header: BaseView {
    let sesacImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.setBackground(imagename: .sesacFace(.sesac_face_1))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.setBackground(imagename: .background(.sesac_background_1))
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
class ExpandableTableView: UITableView {
    
    var collectionView: UICollectionView = {
        let view = BaseCollectionView(frame: .zero, collectionViewLayout: .init())
        view.register(BackCollectionViewCell.self, forCellWithReuseIdentifier: BackCollectionViewCell.reuseIdentifier)
        view.backgroundColor = .cyan
        return view
    }()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .insetGrouped)
        
        // 셀등록
        registerTableViewCell()
        configure()
    }
    
    func configure() {
        self.backgroundColor = .brown
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //셀등록
 func registerTableViewCell() {
     self.register(ExpandableTableViewCell.self, forCellReuseIdentifier: ExpandableTableViewCell.reuseIdentifier)
     self.register(ExpandableTextTableViewCell.self, forCellReuseIdentifier: ExpandableTextTableViewCell.reuseIdentifier)
    
    }
 
}
