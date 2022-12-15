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
    
    let test = LacunchViewMoldel()
    
    let commonSerVerModel = CommonServerManager()
    let viewModel = LacunchViewMoldel()
    
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
    
        // 토큰 유무
        viewModel.checkIdtoken()
            .subscribe(with: self) { vc, idtoken in
                print("IdToken 있음 :",idtoken)
                vc.commonSerVerModel.UserInfoNetwork(idtoken: idtoken)
            } onFailure: { vc, _ in
                let onboardingViewController = OnboardingViewController()
                vc.setInitialViewController(to: onboardingViewController)
                return
            }.disposed(by: disposedBag)
        
//        UserDefaults.standard.removeObject(forKey: "idtoken")
   
        // 토큰 유효성 검사 필요 지점
        self.commonSerVerModel.userStatus
            .asDriver(onErrorJustReturn: (.InvaliedNickName))
            .drive(with: self) { (vc, value) in
                print(value, " =============")
                switch value {
                    
                case .Success:
                    //                    let testvc = ShopViewController()
                    //                    sceneDelegate?.window?.rootViewController = testvc
                    //                    sceneDelegate?.window?.makeKeyAndVisible()
                    let homeMapController = CustomTabBarController()
                    vc.setInitialViewController(to: homeMapController)
                    print("기존 유저 정보를 받아 홈화면으로 진입 🟢")
                    
                case .FirebaseTokenError:
                    print("401")
                    //앱을 재시작할 수 있나
                    //                    self?.commonSerVerModel.USerInfoNetwork(idtoken: idtoken) // 무한 재귀호출~
//                    vc.test.refreshIdtoken()
                case .NotsignUpUser:
                    let nickNameViewController = NicknameViewController()
                    vc.setInitialViewController(to: nickNameViewController)
                    return
                default:
                    print("온보딩 userstatus 기타 에러 : \(value)")
                }
            }.disposed(by: self.disposedBag)
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
