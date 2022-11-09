//
//  OnboardingViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/09.
//

import Foundation

import Foundation
import UIKit
import SnapKit

enum onboardImgList: String {
    case first = "splash_logo"
    case second = "onboarding_img1"
    case third = "onboarding_img2"
    case fourth = "onboarding_img3"
}

enum onboardLabelList: String {
    case second = "onboardFirstLabel"
    case third = "onboardSecondLabel"
    case fourth = "onboardThirdLabel"
}

class OnboardingViewController: UIViewController {

    let mainView = TestView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        mainView.backgroundColor = .setBaseColor(color: .white)
        mainView.pageControl(mainView.pageControl)
        mainView.testScrollView.delegate = self
        contentScrollerivew()
        
        mainView.button.addTarget(self, action: #selector(skipOnboarding), for: .touchUpInside)
    }
    
    @objc func skipOnboarding() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.3
        sceneDelegate?.window?.layer.add(transition, forKey: kCATransition)
        
        let vc = SignUpViewController()
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func contentScrollerivew() {
        let imageList = [mainView.firstImageView, mainView.secondImageView, mainView.thirdImageView, mainView.fourthImageView]
        
        mainView.pageControl.numberOfPages = imageList.count
        
        for i in 0..<imageList.count {
            let positionX = mainView.testScrollView.frame.width * CGFloat(i)
            imageList[i].frame = CGRect(x: positionX, y: 0, width: mainView.testScrollView.bounds.width + 20, height: mainView.testScrollView.bounds.height)
        }
    }
    
    func selectedPage(currentPage: Int) {
        mainView.pageControl.currentPage = currentPage
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let size: Double = scrollView.contentOffset.x / scrollView.frame.size.width
        guard !(size.isNaN || size.isInfinite) else {
            selectedPage(currentPage: 1)
            return print("illegal value" )// or do some error handling)
        }
        selectedPage(currentPage: Int(round(size)))
    }
}

final class TestView: BaseView {
    
    let button: UIButton = {
        let view = UIButton()
        view.backgroundColor = .brown
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.setTitle("skip", for: .normal)
        return view
    }()
    
    let testScrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .setBaseColor(color: .white)
        view.isPagingEnabled = true
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    let pageControl: UIPageControl = {
           let view = UIPageControl()
           return view
       }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .setBaseColor(color: .white)
        return view
    }()
    
    let firstImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: onboardImgList.first.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let secondImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: onboardImgList.second.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let secondLabelView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: onboardLabelList.second.rawValue)
        return view
    }()
    
    let thirdImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: onboardImgList.third.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let thirdLabelView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: onboardLabelList.third.rawValue)
        return view
    }()
    
    let fourthImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: onboardImgList.fourth.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let fourthLabelView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: onboardLabelList.fourth.rawValue)
        return view
    }()
   
    let imageStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 0
        view.backgroundColor = .setBaseColor(color: .white)
        return view
    }()
   
    let labelStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 170
        view.backgroundColor = .setBaseColor(color: .white)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        super.configure()
        
        [secondImageView, thirdImageView, fourthImageView].forEach { labelStackView.addArrangedSubview($0) }
        [firstImageView, secondImageView, thirdImageView, fourthImageView].forEach { imageStackView.addArrangedSubview($0) }
        
        contentView.addSubview(imageStackView)
        contentView.addSubview(labelStackView)
        testScrollView.addSubview(contentView)
        
        [testScrollView, pageControl, button].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        testScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(pageControl.snp.top).offset(-76)
            make.width.equalTo(self.snp.width)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(testScrollView.snp.bottom).offset(76)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(16)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(24)
            make.height.equalTo(48)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(72)
            make.height.equalTo(76)
            make.leading.equalTo(contentView.snp.leading).offset(460)
            make.trailing.equalTo(contentView.snp.trailing).offset(-85)
        }
        
        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(96)
            make.height.width.equalTo(360)
            make.trailing.equalTo(contentView.snp.trailing)
        }
    }
    
    func pageControl(_ : UIPageControl) {
           pageControl.numberOfPages = 4
           pageControl.backgroundColor = UIColor(hex: "#FDF9EF")
           pageControl.pageIndicatorTintColor = .black
           pageControl.currentPageIndicatorTintColor = .brown
           pageControl.currentPage = 0
    }
}
