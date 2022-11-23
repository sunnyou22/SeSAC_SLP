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
                        idtoken: UserDefaults.idtoken!)
                } else {
                    vc.mainView.makeToast("성별을 선택해주세요", duration: 1, position: .center)
                }
            }.disposed(by: disposedBag)
        
        viewModel.userStatus
            .withUnretained(self)
            .bind { vc, error in
                switch error {
                case .Success:
                    print("회원가입성공 ✅")
                    let viewcontroller = HomeMapViewController()
                    vc.setInitialViewController(to: viewcontroller)
                    vc.deleteUserDefaults()
                case .FirebaseTokenError:
                    FirebaseManager.shared.getIDTokenForcingRefresh()
                    // 사용자에게 이렇게 요청하는게 맞는걸까
                    vc.mainView.makeToast("다시 시도해주세요", duration: 1, position: .center)
                case .NotsignUpUser:
                    print("미가입유저🔴", #function)
                case .ServerError:
                    print("서버에러🔴", #function)
                case .ClientError:
                    print("클라에러🔴", #function)
                case .SignInUser:
                    print("이미가입한 유저🔴", #function)
                case .InvaliedNickName:
                    vc.mainView.makeToast("사용할 수 없는 닉네임입니다", duration: 1, position: .center) { didTap in
                        SignInViewModel.backToNicknameVC.accept(true)
                        
                        guard let viewControllers : [UIViewController] = vc.navigationController?.viewControllers as? [UIViewController] else { return  }
                        vc.navigationController?.popToViewController(viewControllers[viewControllers.count - 4 ], animated: true)
                    }
                }
            }.disposed(by: disposedBag)
    }

//    
    func deleteUserDefaults() {
        for key in 1...(UserDaultsKey.allCases.count - 1) {
            UserDefaults.standard.removeObject(forKey: UserDaultsKey.allCases[key].rawValue)
        }
            
    }
    
}
