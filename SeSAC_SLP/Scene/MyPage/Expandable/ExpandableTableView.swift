//
//  ExpandableTableView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit



class ExpandableTableView: UITableView {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.setBackground(imagename: .background(.sesac_background_1))
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        return view
    }()
    
    let sesacImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.setBackground(imagename: .sesacFace(.sesac_face_1))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    
    let header: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        // 셀등록
        registerTableViewCell()
        
        // 테이블뷰 속성
        configure()
    setConstraints()
        imageView.addSubview(sesacImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //셀등록
 func registerTableViewCell() {
     self.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.reuseIdentifier)
     self.register(WishStudyTavleViewCell.self, forCellReuseIdentifier: WishStudyTavleViewCell.reuseIdentifier)
     self.register(ReviewTableViewCell.self, forCellReuseIdentifier: ReviewTableViewCell.reuseIdentifier)
    }
    
    func configure() {
        self.backgroundColor = .brown
        self.tableHeaderView = self.header
    }
    
    func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(16)
            make.height.equalTo(imageView.snp.width).multipliedBy(0.57)
        }
        sesacImage.snp.makeConstraints { make in
            make.centerX.equalTo(imageView.snp.centerX)
            make.bottom.equalTo(imageView.snp.bottom).offset(16)
        }
        
    }
}
