//
//  VerificationViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift
import FirebaseCore
import FirebaseAuth

class VerificationViewController: BaseViewController {
    
    var mainView = VerificationView()
    let viewModel = SignUpViewModel()
    let disposedBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        credential()
        bindData()
        mainView.inputTextField.addTarget(self, action: #selector(changedTextfield), for: .editingChanged)
    }
    
    func bindData() {
        
        viewModel.textfield
            .withUnretained(self)
            .subscribe(onNext: { vc, text in
                print(text, "=======")
            }).disposed(by: disposedBag)
        
        viewModel.buttonValid
            .withUnretained(self)
            .bind { vc, bool in
                vc.mainView.nextButton.isEnabled = bool ? true : false
                vc.mainView.nextButton.backgroundColor = bool ? .setBrandColor(color: .green) : .setGray(color: .gray6)
            }.disposed(by: disposedBag)
        
        mainView.rePostButton.rx
            .tap
            .withUnretained(self)
            .bind { vc, _ in
                guard let phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber") else { return }
//                vc.verification(num: phoneNumber)
                print("클릭이된당😇")
            }.disposed(by: disposedBag)
        
        mainView.nextButton.rx
            .tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.credential()
                print("클릭된당")
                //                let viewcontroller = NicknameViewController()
                //                vc.transition(viewcontroller, .push)
            }.disposed(by: disposedBag)
    }
    
    
    @objc func changedTextfield() {
        guard let text = mainView.inputTextField.text else { return }
        viewModel.textfield.accept(text)
        if text.count == 6 {
            viewModel.buttonValid.accept(true)
        } else {
            viewModel.buttonValid.accept(false)
        }
       
    }
    
    func credential() {
        // error코드화면전화테스트
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else { return } // 이 부분 이해하기
        guard let verificationCode = mainView.inputTextField.text else { return }
        
        print(verificationID,"😫", verificationCode, "😫😫😫😫😫😫")
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )

        Auth.auth().signIn(with: credential) { [weak self] result, error in
            if let error = error {
                //토스트띄우기
                
                let alert = UIAlertController(title: "알 수 없는 사용자", message: "회원가입화면으로 넘어가시겠습니까?", preferredStyle: .alert)
                let ok = UIAlertAction(title: "네", style: .default) { [weak self] _ in
                    let viewcontroller = NicknameViewController()
                    self?.transition(viewcontroller, .push)
                    
                }
                let cancel = UIAlertAction(title: "아니오", style: .cancel)
                alert.addAction(ok)
                alert.addAction(cancel)
                
                self?.present(alert, animated: true)
                
                
                print("Unable to login with Phone : error[\(error)]🥲😡")
                return
            } else {
                print("Phone Number user is signed in \(String(describing: result?.user.uid))🥰🥰")
            }
        }
    }
    
    func verification(num: String) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") // 이 부분 이해하기
        
        mainView.loadingBar.startAnimating()
        mainView.nextButton.isEnabled = false
        
        Auth.auth().languageCode = "kr"
        PhoneAuthProvider.provider()
            .verifyPhoneNumber("+82\(num)", uiDelegate: nil) { [weak self] (verificationID, error) in
                if let error = error {
                    print(error.localizedDescription, "🥲😡")
                    
                    return
                } else {
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    print("success🥰🥰")
                    self?.mainView.loadingBar.stopAnimating()
                    self?.mainView.nextButton.isEnabled = true
                }
            }
    }
}
