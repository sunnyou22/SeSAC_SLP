//
//  ViewControllerList.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/09.
//

//MARK: 이후 RX 로 바꾸기 + 공통속성 메서드로 빼기
import UIKit
import SnapKit

class FirstView: BaseView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   lazy var firstLabel: UILabel = {
        let view = UILabel()
       return setattributeText(view: view, text: "위치 기반으로 빠르게\n주위 친구를 확인", location: 0, length: 6, baseColor: .black, pointColor: .setBrandColor(color: .green))
    }()
    
    
    let firstImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: onboardImgList.first.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    
    override func configure() {
        [firstLabel, firstImageView].forEach { self.addSubview($0) }
        self.backgroundColor = .setBaseColor(color: .white)
    }
    
    override func setConstraints() {
        firstLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(76)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        firstImageView.snp.makeConstraints { make in
            make.top.equalTo(firstLabel.snp.bottom).offset(50)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
}

class SecondView: BaseView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     lazy var secondLabel: UILabel = {
         let view = UILabel()
         return setattributeText(view: view, text: "스터디를 원하는 친구를\n찾을 수 있어요", location: 0, length: 11, baseColor: .black, pointColor: .setBrandColor(color: .green))
     }()
    
    let secondImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: onboardImgList.second.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    
    override func configure() {
        [secondLabel, secondImageView].forEach { self.addSubview($0) }
        self.backgroundColor = .setBaseColor(color: .white)
    }
    
    override func setConstraints() {
        
        secondLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(72)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        secondImageView.snp.makeConstraints { make in
            make.top.equalTo(secondLabel.snp.bottom).offset(56)
            make.centerX.equalTo(secondLabel.snp.centerX)
        }
        
    }
}

class ThirdView: BaseView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var thirdLabel: UILabel = {
        let view = UILabel()
        return setattributeText(view: view, text: "SeSAC Study", baseColor: .black, pointColor: .black)
    }()
    
    let thirdImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: onboardImgList.third.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override func configure() {
        [thirdLabel, thirdImageView].forEach { self.addSubview($0) }
        self.backgroundColor = .setBaseColor(color: .white)
    }
    
    override func setConstraints() {
          thirdLabel.snp.makeConstraints { make in
              make.top.equalToSuperview().offset(76)
              make.centerX.equalTo(self.snp.centerX)
          }
          
          thirdImageView.snp.makeConstraints { make in
              make.top.equalTo(thirdLabel.snp.bottom).offset(50)
              make.centerX.equalTo(thirdLabel.snp.centerX)
          }
    }
}
