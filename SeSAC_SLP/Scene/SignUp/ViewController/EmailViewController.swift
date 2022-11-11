//
//  EmailViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/09.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

class EmailViewController: BaseViewController {
    
    var mainView = EmailView()
    var viewModel = SignUpViewModel()
    let disposedBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UserDefaults.email, "🐭")
        
        bindData()
    }

    func bindData() {
        
        mainView.inputTextField.rx
            .text
            .orEmpty
            .withUnretained(self)
            .bind { vc, text in
                vc.viewModel.textfield.accept(text)
            }.disposed(by: disposedBag)
        
        viewModel.textfield
            .withUnretained(self)
            .bind { vc, text in
                guard let textfield = vc.mainView.inputTextField.text else { return }
                vc.viewModel.buttonValid.accept(textfield.isValidEmail(testStr: text))
                UserDefaults.standard.set(text, forKey: "email")
                print(UserDefaults.email, "🐭")
                print(textfield, text, "text😵‍💫😵‍💫😵‍💫😵‍💫", textfield.isValidEmail(testStr: text))
                print("😮", textfield.isValidEmail(testStr: text))
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
                    let viewController = GenderViewController()
                   vc.transition(viewController, .push)
               } else {
                   vc.mainView.makeToast("이메일 형식이 올바르지 않습니다.", position: .center)
               }
            }.disposed(by: disposedBag)
    }
}

