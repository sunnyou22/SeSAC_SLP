//
//  SignUPViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/07.
//

import UIKit

import RxSwift
import RxCocoa
import FirebaseCore
import FirebaseAuth
import Toast

class SignUpViewController: BaseViewController {
    
    var mainView = SignUpView()
    let viewModel = SignUpViewModel()
    let disposedBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        UserDefaults.first = true
        //        mainView.nextButton.addTarget(self, action: #selector(goReceiveVerificationNumView), for: .touchUpInside)
        mainView.inputTextField.addTarget(self, action: #selector(changedTextfield), for: .editingChanged)
    }
    
    func bindData() {
        //여기서 이벤트를 받음냐
        viewModel.textfield
            .withUnretained(self)
            .subscribe(onNext: { vc, text in
                print(text, "=======")
                vc.mainView.inputTextField.text = text.applyPatternOnNumbers(pattern: "###-####-####", replacmentCharacter: "#")
            }).disposed(by: disposedBag)
        
        viewModel.buttonValid
            .withUnretained(self)
            .bind { vc, bool in
                vc.mainView.nextButton.backgroundColor = bool ? .setBrandColor(color: .green) : .setGray(color: .gray6)
            }.disposed(by: disposedBag)
        
        mainView.nextButton.rx
            .tap
            .withUnretained(self)
            .bind { vc, _ in
                guard let text = vc.mainView.inputTextField.text else {return}
                let rawnum = text.applyPatternOnNumbers(pattern: "###########", replacmentCharacter: "#")
                let result = rawnum.dropFirst(1)
                print(result, String(result), "😵‍💫😵‍💫😵‍💫😵‍💫")
                if vc.viewModel.buttonValid.value == false {
                    vc.view.makeToast("잘못된 전화번호 형식입니다.", position: .center)
                } else {
                    vc.verification(num: String(result))
                    UserDefaults.repostNum = String(result)
                }
            }.disposed(by: disposedBag)
        
        // 로딩바를 터치하면 로딩바가 없어지고 인증과정도 리셋되게
    }
    
    @objc func changedTextfield() {
        guard let text = mainView.inputTextField.text else { return }
        viewModel.textfield.accept(text)
        if text.count == 13, text.starts(with: "010") {
            viewModel.buttonValid.accept(true)
        } else {
            viewModel.buttonValid.accept(false)
        }
    }
    
    func verification(num: String) {
        
        // verifyPhoneNumber 메서드는 원래 요청이 시간 초과되지 않는 한 두 번째 SMS를 보내지 않습니다.
        
        Auth.auth().languageCode = "kr"
        PhoneAuthProvider.provider()
            .verifyPhoneNumber("+82\(num)", uiDelegate: nil) { [weak self] (verificationID, error) in
                UserDefaults.phoneNumber = "+82\(num)"
                if let error = error {
                    switch error {
                    case AuthErrorCode.invalidPhoneNumber:
                        self?.view.makeToast("잘못된 전화번호 형식입니다.", position: .center)
                        // 이거 어떻게 실험할 수 있지 흠...
                    case AuthErrorCode.tooManyRequests:
                        self?.view.makeToast("과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요.", position: .center)
                    default:
                        self?.view.makeToast("에러가 발생했습니다. 다시 시도해주세요", position: .center)
                    }
                    print(error.localizedDescription, error, "🥲😡")
                    return
                } else {
                    let viewcontroller = VerificationViewController()
                    self?.transition(viewcontroller, .push)
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    print("success🥰🥰")
                }
            }
    }
}

