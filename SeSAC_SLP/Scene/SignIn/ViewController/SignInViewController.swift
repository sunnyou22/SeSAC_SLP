//
//  SignInViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/07.
//

import UIKit

import RxSwift
import RxCocoa
import FirebaseCore
import FirebaseAuth
import NotiModel
//import Toast

class SignInViewController: BaseViewController {
    
    var mainView = SignUpView()
    let viewModel = SignInViewModel()
    let commonServerModel = CommonServerManager()
    let disposedBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
 
        print("저나번호", UserDefaults.phoneNumber, "내 토큰(유저디폴): \(UserDefaults.idtoken)")
    }
    
   private func bindData() {
       
        //1. 텍스트필드 편집이벤트 받음(최초이벤트트리거가 필요해)
        mainView.inputTextField.rx
            .text
            .orEmpty
            .withUnretained(self)
            .bind(onNext: { vc, text in
                print(text, "=======")
                vc.viewModel.changePattern(num: text)
            }).disposed(by: disposedBag)
        
        //3. 옵저버 텍스트 필드 전달받음
        viewModel.textfield
            .withUnretained(self)
            .bind { vc, text in
                //변경된 형식의 텍스트를 뷰에 넣어줌
                vc.mainView.inputTextField.text = text
                //4. 텍스트필드 유효성 검사 -> 버튼에 대한 유효성검사 이벤트 던짐
                vc.viewModel.checkVaildPhoneNumber(text: text) // UserDefaults.phoneNumber 담김
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
                    //번호인증
                    vc.viewModel.networkWithFireBase(num: vc.viewModel.textfield.value)
                } else {
                    vc.showDefaultToast(message: .AuthVerifyPhoneNumber(.invalidPhoneNumber))
                }
                   
            }.disposed(by: disposedBag)
        
        viewModel.authPhoneNumResult
            .withUnretained(self)
            .asDriver(onErrorJustReturn: (self, .otherError))
            .drive(onNext: { vc, reponse in
                switch reponse {
                    //에러메세지 받기
                case .success:
                    LoadingIndicator.hideLoading()
                    let viewcontroller = VerificationViewController()
                    print("전화번호인증 성공 🟢")
                    vc.transition(viewcontroller, .push)
                case .invalidPhoneNumber:
                    vc.showDefaultToast(message: .AuthVerifyPhoneNumber(.invalidPhoneNumber))
                case .tooManyRequests:
                    vc.showDefaultToast(message: .AuthVerifyPhoneNumber(.tooManyRequests))
                case .otherError:
                    vc.showDefaultToast(message: .AuthVerifyPhoneNumber(.otherError))
                }
            }).disposed(by: disposedBag)
    }
}

