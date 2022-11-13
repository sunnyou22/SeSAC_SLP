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
    case first = "onboarding_img1"
    case second = "onboarding_img2"
    case third = "onboarding_img3"
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
        mainView.pageControl.addTarget(self, action: #selector(pageChanged), for: .touchDragInside)
    }

    @objc func skipOnboarding() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate

        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.3
        sceneDelegate?.window?.layer.add(transition, forKey: kCATransition)

        let vc = SignInViewController()
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKeyAndVisible()
    }
//
    @objc func pageChanged() {
        if mainView.pageControl.currentPage != 2 {
            let x = CGFloat(mainView.pageControl.currentPage + 1) * mainView.testScrollView.frame.width
            mainView.testScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        } else {
            mainView.pageControl.currentPage = 2
            mainView.testScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    func contentScrollerivew() {
        let viewList = [mainView.firstView, mainView.secondView, mainView.thirdView]
        mainView.pageControl.numberOfPages = viewList.count
        for i in 0..<viewList.count {
            let positionX = mainView.testScrollView.frame.width * CGFloat(i)
            viewList[i].frame = CGRect(x: positionX, y: 0, width: mainView.testScrollView.bounds.width, height: mainView.testScrollView.bounds.height)
        }
    }
    
    func selectedPage(currentPage: Int) {
        mainView.pageControl.currentPage = currentPage
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let size = scrollView.contentOffset.x / scrollView.frame.size.width
        selectedPage(currentPage: Int(round(size)))
    }
}

final class TestView: BaseView {
    
    let button: UIButton = {
        let view = UIButton()
        view.backgroundColor = .setBrandColor(color: .green)
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        view.setTitle("시작하기", for: .normal)
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
    
    let firstView: UIView = {
        let view = FirstView()
        return view
    }()
    
    let secondView: UIView = {
        let view = SecondView()
        return view
    }()
    
    let thirdView: UIView = {
        let view = ThirdView()
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    let pageControl: UIPageControl = {
           let view = UIPageControl()
           return view
       }()

    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 0
        view.backgroundColor = .cyan
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
        
       [firstView, secondView, thirdView].forEach { stackView.addArrangedSubview($0) }
        
        contentView.addSubview(stackView)
        testScrollView.addSubview(contentView)
       
        [testScrollView, pageControl, button].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        testScrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.84)
            make.top.equalToSuperview()
            
            make.horizontalEdges.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(3)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(button.snp.top).offset(-42)
            make.centerX.equalTo(self.snp.centerX)
//            make.height.equalTo(16)
        }
        
        button.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    func pageControl(_ : UIPageControl) {
           pageControl.numberOfPages = 3
        pageControl.backgroundColor = .setBaseColor(color: .white)
        pageControl.pageIndicatorTintColor = .setGray(color: .gray5)
        pageControl.currentPageIndicatorTintColor = .setBrandColor(color: .green)
           pageControl.currentPage = 0
    }
}
