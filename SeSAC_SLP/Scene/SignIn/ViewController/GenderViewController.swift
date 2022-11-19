//
//  GenderViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/09.
//

import Foundation

import RxCocoa
import RxSwift
import Toast
import FirebaseCore
import FirebaseAuth
import UIKit

class GenderViewController: BaseViewController {
    
    var mainView = GenderView()
    var viewModel = SignInViewModel()
    var disposedBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if UserDefaults.gender == nil {
            mainView.manButton.backgroundColor = .clear
            mainView.womanButton.backgroundColor = .clear
        }
        
        bindData()
        
    }
    
    func bindData() {
        
        mainView.manButton.rx
            .tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.mainView.manButton.backgroundColor = .setBrandColor(color: .whiteGreen)
                vc.mainView.womanButton.backgroundColor = .clear
                vc.viewModel.buttonValid.accept(true)
                UserDefaults.gender = 1
            }.disposed(by: disposedBag)
        
        mainView.womanButton.rx
            .tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.mainView.womanButton.backgroundColor = .setBrandColor(color: .whiteGreen)
                vc.mainView.manButton.backgroundColor = .clear
                vc.viewModel.buttonValid.accept(true)
                UserDefaults.gender = 0
            }.disposed(by: disposedBag)
        
        viewModel.buttonValid
            .withUnretained(self)
            .bind { vc, bool in
                vc.mainView.nextButton.backgroundColor = bool ? .setBrandColor(color: .green) : .setGray(color: .gray6)
            }.disposed(by: disposedBag)
        
        // ㅇㅔ러코드별로 정리해서 분리하기
        viewModel.autoUserStaus
            .withUnretained(self)
            .bind { vc, response in
                switch response {
                case .Success:
                    let viewController = HomeMapViewController()
                    vc.transition(viewController, .push)
                case .SignInUser:
                    print("이미 가입한유절")
                default :
                    print("아직임싕")
                }
            }.disposed(by: disposedBag)
        
        
        mainView.nextButton.rx
            .tap
            .withUnretained(self)
            .bind { vc, test in
                if vc.viewModel.buttonValid.value {
                    guard let date = UserDefaults.date, let name = UserDefaults.nickname, let FCMToden = UserDefaults.FCMToken, let phoneNum = UserDefaults.phoneNumber, let email = UserDefaults.email, let gender = UserDefaults.gender  else {
                        vc.mainView.makeToast("앞의 회원가입 정보를 전부 입력하고 와주세요!", duration: 1, position: .center)
                        return
                    }
                    vc.viewModel.signUpNetwork (
                        nick: name, FCMtoken: FCMToden,
                        phoneNumber: phoneNum,
                        birth: date,
                        email: email,
                        gender: gender,
                        idtoken: UserDefaults.idtoken!) { [weak self] error in
                            switch error {
                            case SignUpError.FirebaseTokenError:
                                vc.getIdtoken()
                                vc.mainView.makeToast("다시 시도해주세요", duration: 1, position: .center)
                            case SignUpError.InvaliedNickName:
                                vc.mainView.makeToast("사용할 수 없는 닉네임입니다", duration: 1, position: .center) { didTap in
                                    SignInViewModel.backToNicknameVC.accept(true)
                                    
                                    guard let viewControllers : [UIViewController] = self?.navigationController?.viewControllers as? [UIViewController] else { return  }
                                    self?.navigationController?.popToViewController(viewControllers[viewControllers.count - 4 ], animated: true)
                                }
                            default:
                                print("기타")
                            }
                            // 회원가입 성공시 idtoken을 제외한 유저디폴츠 삭제 및 홈화면으로 window 갈아끼우기
                            self?.deleteUserDefaults() // 만약에 다음 버튼을 연타한 경우에 에러가 뜰거임
                            self?.setInitialViewController(to: HomeMapViewController())
                        }
                } else {
                    vc.mainView.makeToast("성별을 선택해주세요", duration: 1, position: .center)
                }
            }.disposed(by: disposedBag)
    }
    
    func getIdtoken() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print(error, "idtoken을 받아올 수 없습니다.")
                return
            } else {
                guard let idtoken = idToken else { return }
                
                UserDefaults.idtoken = idtoken
                
            }
        }
        
    }
    
    func deleteUserDefaults() {
        for key in 1...UserDaultsKey.allCases.count {
            UserDefaults.standard.removeObject(forKey: UserDaultsKey.allCases[key].rawValue)
        }
            
    }
    
}
