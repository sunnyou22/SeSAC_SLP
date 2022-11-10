//
//  NicknameViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/09.
//

import UIKit

import RxSwift
import RxCocoa

class NicknameViewController: BaseViewController {

    var mainView = SignUpView()
    let viewModel = SignUpViewModel()
    let disposedBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .setBaseColor(color: .white)
        mainView.setcontents(type: .nickname, label: mainView.titleLabel, button: mainView.nextButton, subtitle: nil)
        mainView.setInputTextField()
        bindData()
    }
    
    func bindData() {
        
        //텍스트 필드, 버튼 탭
        mainView.inputTextField
            .rx
            .text
            .orEmpty
            .map { ($0.count < 10 && $0.count > 1) }
            .withUnretained(self)
            .bind { vc, bool in
                UserDefaults.nickname = vc.mainView.inputTextField.text
                print("닉네임 🚀 \(UserDefaults.nickname)")
                vc.mainView.nextButton.backgroundColor = bool ? .setBrandColor(color: .green) : .setGray(color: .gray6)
                vc.viewModel.buttonValid.accept(bool)
            }.disposed(by: disposedBag)
        
        // 버튼 탭
        mainView.nextButton.rx
            .tap
            .withUnretained(self)
            .bind { vc, _ in
                let viewcontroller = BirthDayViewController()
                if vc.viewModel.buttonValid.value {
                    vc.transition(viewcontroller, .push)
                }
            }.disposed(by: disposedBag)
    }
}

