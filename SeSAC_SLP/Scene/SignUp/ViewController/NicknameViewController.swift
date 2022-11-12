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
        mainView.inputTextField.text = UserDefaults.nickname ?? ""
        bindData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        SignUpViewModel.test
            .withUnretained(self)
            .bind { vc, bool in
                print("들어오나요오오오오오오오옹ㄴ")
            if bool {
                print("들어오나욘")
                vc.mainView.makeToast("해당 닉네임은 사용할 수 없습니다.", duration: 2, position: .center)
            }
            }.disposed(by: disposedBag)
    }
    
    func bindData() {
        
        //이벤트 넣어주기
        viewModel.textfield
            .map { ($0.count < 10 && $0.count > 1) }
            .withUnretained(self)
            .bind { vc, bool in
                print("닉네임 🚀 \(UserDefaults.nickname)")
                vc.mainView.nextButton.backgroundColor = bool ? .setBrandColor(color: .green) : .setGray(color: .gray6)
                vc.viewModel.buttonValid.accept(bool)
            }.disposed(by: disposedBag)
        
        //텍스트 필드, 버튼 탭, 여기서 이벤트를 발생ㅎ시키
        mainView.inputTextField
            .rx
            .text
            .orEmpty
            .withUnretained(self)
            .bind { vc, text in
                vc.viewModel.textfield.accept(text)
                UserDefaults.nickname = text
                print("닉네임 🚀🚀 \(UserDefaults.nickname)")

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

