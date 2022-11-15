//
//  Header.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/16.
//

import UIKit
import SnapKit

final class MyPageHeaderView: UICollectionReusableView {
  lazy var username: UILabel = {
    let view = UILabel()
    view.textColor = .white
    return view
  }()
  
//    let roundView: UIView = {
//        let view = UIView()
//        view.clipsToBounds = true
//        view.layer.cornerRadius = view.frame.size.width / 2
//        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor.setGray(color: .gray2).cgColor
//        return view
//    }()
//
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.setBackground(imagename: .sesacFace(.sesac_face_1))
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = view.frame.size.width / 2
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.setGray(color: .gray2).cgColor
        return view
    }()
    
    func configure() {
        [username, imageView].forEach { self.addSubview($0) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
      func setConsentrait() {
          
          imageView.snp.makeConstraints { make in
              make.width.height.equalTo(50)
              make.leading.equalTo(16)
              make.centerY.equalTo(self.snp.centerY)
          }
          
          username.snp.makeConstraints { make in
              make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
              make.centerY.equalTo(self.snp.centerY)
          }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.prepare(text: nil)
  }
  
  func prepare(text: String?) {
    self.username.text = text
  }
}
