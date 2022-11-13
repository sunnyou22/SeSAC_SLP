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
//import Toast

class SignInViewController: BaseViewController {
    
    var mainView = SignUpView()
    let viewModel = SignInViewModel()
    let disposedBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                                                                                    
        bindData()
        // 최초진입분기
        UserDefaults.first = true
        // 토근 및 전번확인
        print(UserDefaults.idtoken, "🚀")
        print("저나번호", UserDefaults.phoneNumber, UserDefaults.repostNum)
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
                vc.viewModel.checkVaildPhoneNumber(text: text)
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
                    vc.viewModel.networkWithFireBase()
            }.disposed(by: disposedBag)
        
        viewModel.authResult
            .withUnretained(self)
            .bind { vc, reponse in
                switch reponse {
                case .success:
                    let viewcontroller = VerificationViewController()
                    print("전화번호인증 성공 🟢")
                    vc.transition(viewcontroller, .push)
                case .invalidPhoneNumber:
                    vc.showDefaultToast(message: .invalidPhoneNumber)
                case .tooManyRequests:
                    vc.showDefaultToast(message: .tooManyRequests)
                case .otherError:
                    vc.showDefaultToast(message: .otherError)
                }
            }.disposed(by: disposedBag)
    }
}

