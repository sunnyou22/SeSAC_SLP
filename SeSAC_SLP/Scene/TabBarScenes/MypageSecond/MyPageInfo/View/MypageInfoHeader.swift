//
//  MypageInfoHeader.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/16.
//

import UIKit
import SnapKit

//MARK: 헤더
class Header: BaseView {
    let sesacImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Sesac_Face.sesac_face_1.str)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    
 let imageView: UIImageView = {
        let view = UIImageView()
     view.image = UIImage(named: SeSac_Background.sesac_background_1.str)
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
            make.edges.equalTo(self.snp.edges)
        }
        sesacImage.snp.makeConstraints { make in
            make.centerX.equalTo(imageView.snp.centerX)
            make.bottom.equalTo(imageView.snp.bottom).offset(-8)
        }
    }
}
