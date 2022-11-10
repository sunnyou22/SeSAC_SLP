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
        mainView.setcontents(type: .nickname, label: mainView.titleLabel, button: mainView.nextButton, subtitle: nil)
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
                vc.mainView.nextButton.backgroundColor = bool ? .setBrandColor(color: .green) : .setGray(color: .gray6)
            }.disposed(by: disposedBag)
        
        // 버튼 탭
        mainView.nextButton.rx
            .tap
            .withUnretained(self)
            .bind { vc, _ in
                guard let text = vc.mainView.inputTextField.text else {return}
                let rawnum = text.applyPatternOnNumbers(pattern: "###########", replacmentCharacter: "#")
                let result = rawnum.dropFirst(1)
                print(result, String(result), "😵‍💫😵‍💫😵‍💫😵‍💫")
                //                vc.verification(num: String(result))
                let viewcontroller = NicknameViewController()
                vc.transition(viewcontroller, .push)
            }.disposed(by: disposedBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .setBaseColor(color: .white)
        mainView.setcontents(type: .first, label: mainView.titleLabel, button: mainView.nextButton, subtitle: nil)
        mainView.nextButton.addTarget(self, action: #selector(goReceiveVerificationNumView), for: .touchUpInside)
    }

    @objc func goReceiveVerificationNumView() {
        let vc = BirthDayViewController()
        transition(vc, .push)
    }
}

