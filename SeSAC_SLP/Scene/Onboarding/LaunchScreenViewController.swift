//
//  LaunchScreenViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/12.
//

import UIKit
import SnapKit
import Toast

class LaunchScreenViewController: UIViewController {
    
    let mainImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "splash_logo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let titleImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "splash_text")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .setBaseColor(color: .white)
        configure()
        setContents()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
    
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            
            let transition = CATransition()
            transition.type = .fade
            //            transition.duration = 3
            sceneDelegate?.window?.layer.add(transition, forKey: kCATransition)
            //분기처리
            
            if UserDefaults.first == true {
                //토큰이 있는데, 나머지 회원가입절차를 거치치 않았을 때 기존에 저장해뒀던 유저디폴츠의 값이 nil이 판단해서 절차 완료시키기
                //토큰이 없을 때 온보딩화면
                let signViewController = VerificationViewController()
                    let nav = UINavigationController(rootViewController: signViewController)
                    sceneDelegate?.window?.rootViewController = nav
                    sceneDelegate?.window?.makeKeyAndVisible()
                    return

            } else {
                let onboardingViewController = OnboardingViewController()
                sceneDelegate?.window?.rootViewController = onboardingViewController
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            
            return
        }
    }
    
    func configure() {
        view.addSubview(mainImageView)
        view.addSubview(titleImageView)
    }
    
   func setContents() {
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(172)
            make.width.equalTo(264)
            make.height.equalTo(220)
            make.centerX.equalTo(view.snp.centerX)
        }

        titleImageView.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(36)
            make.width.equalTo(292)
            make.height.equalTo(100)
            make.centerX.equalTo(mainImageView.snp.centerX)
        }
    }
}
