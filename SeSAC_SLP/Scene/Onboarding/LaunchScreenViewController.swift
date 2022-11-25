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
      
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let transition = CATransition()
        transition.type = .fade
                transition.duration = 3
        sceneDelegate?.window?.layer.add(transition, forKey: kCATransition)
        //분기처리
        //        UserDefaults.standard.removeObject(forKey: "idtoken")
        guard let idtoken = UserDefaults.idtoken else {
            let onboardingViewController = OnboardingViewController()
            setInitialViewController(to: onboardingViewController)
            return
        }
        
        print(idtoken)
        
        self.commonSerVerModel.USerInfoNetwork(idtoken: idtoken)
        
        //데이터 통신이 끝난 이후 불러지는 코드인데
        self.commonSerVerModel.userStatus
            .asDriver(onErrorJustReturn: (.InvaliedNickName))
            .drive(onNext: { [weak self] value in
                print(value, " =============")
                switch value {
                case .SignInUser:
                    print("201 안불려지는 메서드")
                case .InvaliedNickName:
                    print("InvaliedNickName // 온보딩에서 필요없는 코드")
                case .Success:
                    let homeMapController = CustomTabBarController()
                    self?.setInitialViewController(to: homeMapController)
                    print("기존 유저 정보를 받아 홈화면으로 진입 🟢")
                case .FirebaseTokenError:
                    print("401")
                    //앱을 재시작할 수 있나
//                    self?.commonSerVerModel.USerInfoNetwork(idtoken: idtoken) // 이부분 확인하기
                    FirebaseManager.shared.getIDTokenForcingRefresh()
                case .NotsignUpUser:
                    let nickNameViewController = NicknameViewController()
                    self?.setInitialViewController(to: nickNameViewController)
                    return
                case .ServerError:
                    print("ServerError 🔴")
                case .ClientError:
                    print("ClientError 🔴")
                }
            }).disposed(by: self.disposedBag)
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
