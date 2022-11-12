//
//  LaunchScreenViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/12.
//

import UIKit
import SnapKit

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
//            self?.transition(vc, .presentFullScreen)
            
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            
            let transition = CATransition()
            transition.type = .fade
//            transition.duration = 3
            sceneDelegate?.window?.layer.add(transition, forKey: kCATransition)
            //분기처리
           
            if UserDefaults.first {
                let signViewController = BirthDayViewController()
                let nav = UINavigationController(rootViewController: signViewController)
                sceneDelegate?.window?.rootViewController = nav
                sceneDelegate?.window?.makeKeyAndVisible()
            } else {
                let onboardingViewController = OnboardingViewController()
                sceneDelegate?.window?.rootViewController = onboardingViewController
                sceneDelegate?.window?.makeKeyAndVisible()
            }
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
