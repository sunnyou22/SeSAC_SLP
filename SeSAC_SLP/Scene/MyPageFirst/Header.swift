//
//  Header.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/16.
//

import UIKit
import SnapKit

final class MyPageHeaderView: UICollectionReusableView {
    
    let username: UILabel = {
        let view = UILabel()
        view.text = "방선우"
        view.textColor = .setBaseColor(color: .black)
        return view
    }()
 
    let arrowButton: UIButton = {
        let view = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.right")
        config.baseForegroundColor = .setGray(color: .gray7)
        view.configuration = config

    
        return view
    }()
    
        lazy var imageView: UIImageView = {
            let view = UIImageView()
            view.image = UIImage.setBackground(imagename: .sesacFace(.sesac_face_1))
            DispatchQueue.main.async {
                view.contentMode = .scaleAspectFit
                view.clipsToBounds = true
                view.layer.cornerRadius = view.frame.size.width / 2
                view.layer.borderWidth = 1
                view.layer.borderColor = UIColor.setGray(color: .gray2).cgColor
            }
            return view
        }()
    
    func configure() {
        [username, arrowButton, imageView].forEach { self.addSubview($0) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .setBaseColor(color: .white)
        configure()
        setConsentrait()
        
    }
      func setConsentrait() {
          
          imageView.snp.makeConstraints { make in
              make.width.height.equalTo(50)
              make.leading.equalTo(16)
              make.centerY.equalTo(self.snp.centerY)
          }
          
          username.snp.makeConstraints { make in
              make.leading.equalTo(imageView.snp.trailing).offset(16)
              make.centerY.equalTo(self.snp.centerY)
          }
          
          arrowButton.snp.makeConstraints { make in
              make.width.height.equalTo(40)
              make.trailing.equalTo(self.snp.trailing).offset(-4)
              make.centerY.equalTo(self.snp.centerY)
          }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
