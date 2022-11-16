//
//  CustomMapView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/17.
//

import UIKit
import SnapKit
import MapKit // 지도
import CoreLocation

enum MapIcon: String {
    case matched
    case search
    case waiting
}

class CustomMapView: BaseView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    lazy var totalButton: UIButton = {
        let view = UIButton()
        view.setTitle("전체", for: .normal)
        view.setTitleColor(.setBaseColor(color: .black), for: .normal)
        view.titleLabel?.font = UIFont.title4_R14
        view.backgroundColor = .setBrandColor(color: .green)
        view.titleLabel?.textAlignment = .left
        return view
    }()
    
    lazy var manButton: UIButton = {
        let view = UIButton()
        view.setTitle("남자", for: .normal)
        view.titleLabel?.font = UIFont.title4_R14
        view.setTitleColor(.setBaseColor(color: .black), for: .normal)
        return view
    }()
    
    lazy var womanButton: UIButton = {
        let view = UIButton()
        view.setTitle("여자", for: .normal)
        view.titleLabel?.font = UIFont.title4_R14
        view.setTitleColor(.setBaseColor(color: .black), for: .normal)
        return view
    }()
    
    let currentLocationButton: test = {
        let view = test()
        view.setImage(UIImage(named: "place"), for: .normal)
//        var config = UIButton.Configuration.plain()
//        config.baseForegroundColor = .setBaseColor(color: .white)
//        view.configuration = config
//        view.clipsToBounds = true
//        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        return view
    }()
    
    let matchingButton: UIButton = {
       let view = UIButton()
        view.setImage(UIImage(named: MapIcon.search.rawValue), for: .normal)
        return view
    }()
    
    lazy var shadowView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor //그림자 색깔 : 검정색
        view.layer.shadowOpacity = 0.4 // 그림자 투명도 : 0~1, 0에 가까울 수록 투명해짐
        view.layer.shadowOffset = CGSize(width: 0, height: 5) // 그림자 위치 이동 : 밑으로 5 point 이동
        view.layer.shadowRadius = 2 // 그림자 굵기
        return view
    }()
    
    lazy var stackview: UIStackView = {
        let view = UIStackView(arrangedSubviews: [totalButton, manButton, womanButton])
        view.spacing = 0
        view.axis = .vertical
        view.backgroundColor = .setBaseColor(color: .white)
        view.distribution = .fillEqually
        
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        
        return view
    }()
    
    override func configure() {
        shadowView.addSubview(stackview)
        [shadowView, currentLocationButton, matchingButton].forEach { mapView.addSubview($0) }
        self.addSubview(mapView)
    }
    
    override func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        shadowView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.leading.equalTo(self.snp.leading).offset(16)
            make.width.equalTo(48)
            make.height.equalTo(48 * 3)
        }
        
        stackview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.top.equalTo(stackview.snp.bottom).offset(16)
            make.leading.equalTo(self.snp.leading).offset(16)
            make.width.height.equalTo(48)
        }
        
        matchingButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.width.equalTo(64)
        }
    }
}

class test: UIButton {
    
    private var shadowLayer: CALayer?
    private var backgroundLayer: CALayer?
    
    func configureLayers( _ rect: CGRect) {
           if shadowLayer == nil {
               // shadow
               let shadowLayer = CALayer()
               shadowLayer.masksToBounds = false
               shadowLayer.shadowColor = UIColor.setGray(color: .gray7).cgColor
               shadowLayer.shadowOffset = CGSize(width: 0, height: 5) //위치
               shadowLayer.shadowOpacity = 1
               shadowLayer.shadowRadius = 8
               shadowLayer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: 8).cgPath
               layer.insertSublayer(shadowLayer, at: 0)
               self.shadowLayer = shadowLayer
           }

        // 버튼의 색과 모양
            if backgroundLayer == nil {
                let backgroundLayer = CALayer()
                backgroundLayer.masksToBounds = true
                backgroundLayer.frame = rect
                backgroundLayer.cornerRadius = 8
                backgroundLayer.backgroundColor = UIColor.setBaseColor(color: .white).cgColor
                layer.insertSublayer(backgroundLayer, at: 1)
                self.backgroundLayer = backgroundLayer
            }
       }
    
    override func draw(_ rect: CGRect) {
        configureLayers(rect)
    }
}
