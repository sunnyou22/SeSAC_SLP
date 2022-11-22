//
//  LaunchScreenViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/12.
//

import UIKit
import SnapKit
import Toast
import RxCocoa
import RxSwift

class LaunchScreenViewController: UIViewController {
    
    let commonSerVerModel = CommonServerManager()
    let disposedBag = DisposeBag()
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
        //
  
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { // 디패큐있으니까 안드렁오ㅁ
        //
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let transition = CATransition()
        transition.type = .fade
//        transition.duration = 10
        sceneDelegate?.window?.layer.add(transition, forKey: kCATransition)
        //분기처리
        
        guard let idtoken = UserDefaults.idtoken else {
            let onboardingViewController = OnboardingViewController()
            sceneDelegate?.window?.rootViewController = onboardingViewController
            sceneDelegate?.window?.makeKeyAndVisible()
            return
        }
        
        print(idtoken)
        
        
//        UserDefaults.standard.removeObject(forKey: "idtoken")

        //토큰이 있는데, 나머지 회원가입절차를 거치치 않았을 때 기존에 저장해뒀던 유저디폴츠의 값이 nil이 판단해서 절차 완료시키기
        //토큰이 없을 때 온보딩화면
   
        //데이터 통신이 끝난 이후 불러지는 코드인데
        self.commonSerVerModel.usererror
            .asDriver(onErrorJustReturn: .InvaliedNickName)
            .drive(onNext: { value in
                print(value, " =============")
                switch value {
                case .SignInUser:
                    let signViewController = SearchViewController()
                    let nav = UINavigationController(rootViewController: signViewController)
                    sceneDelegate?.window?.rootViewController = nav
                    sceneDelegate?.window?.makeKeyAndVisible()
                    return
                case .InvaliedNickName:
                    print("InvaliedNickName // 온보딩에서 필요없는 코드")
                }
            }).disposed(by: self.disposedBag)
        
        self.commonSerVerModel.commonError
            .asDriver(onErrorJustReturn: .ClientError)
            .drive(onNext: { status in
                print(status, " =============")
                switch status {
                case .Success:
                    let homeVC = HomeMapViewController()
                    let nav = UINavigationController(rootViewController: homeVC)
                    sceneDelegate?.window?.rootViewController = nav
                    sceneDelegate?.window?.makeKeyAndVisible()
                    print("기존 유저 정보를 받아 홈화면으로 진입 🟢")
                case .FirebaseTokenError:
                    print("401")
//                    self.commonSerVerModel.USerInfoNetwork(idtoken: idtoken)
                case .NotsignUpUser:
                    let nickNameViewController = NicknameViewController()
                    let nav = UINavigationController(rootViewController: nickNameViewController)
                    sceneDelegate?.window?.rootViewController = nav
                    sceneDelegate?.window?.makeKeyAndVisible()
                    return
                case .ServerError:
                    print("ServerError 🔴")
                case .ClientError:
                    print("ClientError 🔴")
                }
                
            }).disposed(by: self.disposedBag)
        //        }
        self.commonSerVerModel.USerInfoNetwork(idtoken: idtoken)
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
