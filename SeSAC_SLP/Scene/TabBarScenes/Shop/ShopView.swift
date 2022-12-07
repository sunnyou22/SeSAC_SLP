//
//  ShopView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/05.
//

import UIKit

class ShopView: BaseView {
    
    let sesac: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Sesac_Face.sesac_face_1.str)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let background: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: SeSac_Background.sesac_background_1.str)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        return view
    }()
    
    let saveBtn: UIButton = {
        let view = UIButton()
        view.setTitle("저장하기", for: .normal)
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.Body3_R14
            return outgoing
           }
        config.baseBackgroundColor = .setBrandColor(color: .green)
        config.baseForegroundColor = .setBaseColor(color: .white)
       
        view.configuration = config
        return view
    }()
    
    let tabmanView: ShopContainerView = ShopContainerView()
    
    override func configure() {
        [background, sesac, saveBtn, tabmanView].forEach { addSubview($0) }
        self.backgroundColor = .setBaseColor(color: .white)
    }
    
    override func setConstraints() {
        background.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(background.snp.width).multipliedBy(0.6)
            make.centerX.equalToSuperview()
        }
        
        sesac.snp.makeConstraints { make in
            make.centerX.equalTo(background.snp.centerX)
            make.bottom.equalTo(background.snp.bottom).offset(-8)
        }
        
        saveBtn.snp.makeConstraints { make in
            make.top.equalTo(background.snp.top).offset(16)
            make.trailing.equalTo(background.snp.trailing).offset(-16)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        tabmanView.snp.makeConstraints { make in
            make.top.equalTo(background.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
