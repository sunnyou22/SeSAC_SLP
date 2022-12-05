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
        view.image = UIImage(named: Sesac_Face.sesac_face_1.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let background: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: SeSac_Background.sesac_background_1.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let saveBtn = UIButton {
        let view = UIButton()
        view.setTitle("저장하기", for: .normal)
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .setBaseColor(color: .white)
        config.baseBackgroundColor = .setBrandColor(color: .green)
    }()
}
