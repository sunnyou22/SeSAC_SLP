//
//  SignUPViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/07.
//

import UIKit

import RxSwift
import RxCocoa
import FirebaseAuth

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
                vc.mainView.nextButton.isEnabled = bool ? true : false
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
                vc.verification(num: String(result))
//                let viewcontroller = VerificationViewController()
//                vc.transition(viewcontroller, .push)
            }.disposed(by: disposedBag)
            
    }
//
//    @objc func goReceiveVerificationNumView() {
//
//    }
    
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
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") // 이 부분 이해하기

        Auth.auth().languageCode = "kr"
        PhoneAuthProvider.provider()
            .verifyPhoneNumber("+82\(num)", uiDelegate: nil) { (verificationID, error) in
//                if let id = verificationID {
//                    UserDefaults.standard.set("\(id)", forKey: "authVerificationID")
//                    print("success🥰🥰")
//                }
                if let error = error {
                    print(error.localizedDescription, "🥲😡")
                    return
                }
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                print("success🥰🥰")
            }
    }
}
