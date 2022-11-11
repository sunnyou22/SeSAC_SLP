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
            .bind { vc, _ in
                if vc.viewModel.buttonValid.value {
                    let viewcontroller = SignUpViewController() //임시
                    vc.viewModel.signUpNetwork (
                        nick: UserDefaults.nickname!, FCMtoken: UserDefaults.FCMToken,
                        phoneNumber: UserDefaults.phoneNumber,
                        birth: UserDefaults.date!,
                        email: UserDefaults.email,
                        gender: UserDefaults.gender,
                        idtoken: UserDefaults.idtoken)
                    //                    vc.transition(viewcontroller, .push)
                } else {
                    vc.mainView.makeToast("성별을 선택해주세요", duration: 1, position: .center)
                }
            }.disposed(by: disposedBag)
    }
}
