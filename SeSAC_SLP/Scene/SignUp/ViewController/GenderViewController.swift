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
    var viewModel = SignUpViewModel()
    var disposedBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    vc.viewModel.signUpNetwork (
                        nick: UserDefaults.nickname!, FCMtoken: UserDefaults.FCMToken,
                        phoneNumber: UserDefaults.phoneNumber,
                        birth: UserDefaults.date!,
                        email: UserDefaults.email,
                        gender: UserDefaults.gender,
                        idtoken: UserDefaults.idtoken) { error in
                            switch error {
                            case SignUpError.FirebaseTokenError:
                                vc.getIdtoken()
                            case SignUpError.InvaliedNickName:
                                
                                vc.mainView.makeToast("사용할 수 없는 닉네임입니다", duration: 1, position: .center) { didTap in
                                    SignUpViewModel.test.accept(true)
                                    
                                    guard let viewControllers : [UIViewController] = self.navigationController?.viewControllers as? [UIViewController] else { return  }
                                    self.navigationController?.popToViewController(viewControllers[viewControllers.count - 4 ], animated: true)
                                }
                                
                            default:
                                print("기타")
                            }
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
    
}
