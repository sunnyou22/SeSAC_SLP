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
        mainView.inputTextField.text = UserDefaults.email ?? ""
        bindData()
    }

    func bindData() {
        
        viewModel.textfield
            .map { text in
                text.isValidEmail(testStr: self.mainView.inputTextField.text!)
            }
            .withUnretained(self)
            .bind { vc, bool in
                vc.mainView.nextButton.backgroundColor = bool ? .setBrandColor(color: .green) : .setGray(color: .gray6)
                vc.viewModel.buttonValid.accept(bool)
                print(UserDefaults.email, bool, "🐭")
            }.disposed(by: disposedBag)
        
        mainView.inputTextField.rx
            .text
            .orEmpty
            .withUnretained(self)
            .bind { vc, text in
                UserDefaults.email = text
                print("text😵‍💫😵‍💫😵‍💫😵‍💫", text, text.isValidEmail(testStr: text))
                vc.viewModel.textfield.accept(text)
            }.disposed(by: disposedBag)
        
//        viewModel.buttonValid
//            .withUnretained(self)
//            .bind { vc, bool in
//                vc.mainView.nextButton.backgroundColor = bool ? .setBrandColor(color: .green) : .setGray(color: .gray6)
//            }.disposed(by: disposedBag)
        
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

