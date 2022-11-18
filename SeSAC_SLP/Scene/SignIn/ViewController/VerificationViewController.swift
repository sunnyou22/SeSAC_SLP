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
import Toast

class VerificationViewController: BaseViewController {
    
    var mainView = VerificationView()
    let viewModel = SignInViewModel()
    let disposedBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        print( UserDefaults.idtoken, "🔓")
        print("저나번호☎️", UserDefaults.phoneNumber, UserDefaults.phoneNumber)
    }
    
    func bindData() {
        
        mainView.inputTextField.rx
            .text
            .orEmpty
            .withUnretained(self)
            .bind(onNext: { vc, text in
                print(text, "=======")
                vc.viewModel.checkValidCode(text: text)
            }).disposed(by: disposedBag)
        
        
        viewModel.textfield
            .withUnretained(self)
            .bind { vc, text in
                vc.mainView.inputTextField.text = text
               
            }.disposed(by: disposedBag)
        
        viewModel.buttonValid
            .withUnretained(self)
            .bind { vc, bool in
                vc.mainView.nextButton.backgroundColor = bool ? .setBrandColor(color: .green) : .setGray(color: .gray6)
            }.disposed(by: disposedBag)
        
        mainView.rePostButton.rx
            .tap
            .withUnretained(self)
            .bind { vc, _ in
                guard let num = UserDefaults.phoneNumber else {
                    print(#file, "유저디폴츠에 유효하지 않는 phoneNumber가 저장됨 🔴")
                    print("UserDefaults.phoneNumber ☎️", UserDefaults.phoneNumber)
                    return }
                vc.viewModel.networkWithFireBase(num: num)
            }.disposed(by: disposedBag)
        
        mainView.nextButton.rx
            .tap
            .withUnretained(self)
            .bind { vc, _ in
                guard let idtoken = UserDefaults.idtoken else {
                    print("다음 버튼을 눌렀는데 토큰이 없어 🔴")
                    return }
                vc.viewModel.logInNetwork(idtoken: idtoken)
            }.disposed(by: disposedBag)
        
        viewModel.authPhoneNumResult
            .withUnretained(self)
            .bind { vc, reponse in
                switch reponse {
                case .success:
                    print("전화번호인증 성공 🟢")
                case .invalidPhoneNumber:
                    vc.showDefaultToast(message: .AuthVerifyPhoneNumber(.invalidPhoneNumber))
                case .tooManyRequests:
                    vc.showDefaultToast(message: .AuthVerifyPhoneNumber(.tooManyRequests))
                case .otherError:
                    vc.showDefaultToast(message: .AuthVerifyPhoneNumber(.otherError))
                }
            }.disposed(by: disposedBag)
        
        viewModel.authValidCode
            .withUnretained(self)
            .bind { vc, reponse in
                switch reponse {
                case .success:
                    vc.viewModel.getNetwork()
                case .otherError:
                    vc.showDefaultToast(message: .AuthCredentialText(.otherError))
                case .invalidVerificationID:
                    vc.showDefaultToast(message: .AuthCredentialText(.invalidVerificationID))
                case .invalidUserToken:
                    vc.showDefaultToast(message: .AuthCredentialText(.invalidUserToken))
                case.missingVerificationID:
                    vc.showDefaultToast(message: .AuthCredentialText(.missingVerificationID))
                    
                }
            }.disposed(by: disposedBag)
        
        viewModel.autoUserStaus
            .withUnretained(self)
            .bind { vc, response in
                switch response {
                case .Success:
                    let viewcontroller = NicknameViewController()
                    vc.showDefaultToast(message: .SignUpError(.Success)) {
                        vc.transition(viewcontroller, .push)
                    }
                case .SignInUser:
                    
                    vc.showDefaultToast(message: .SignUpError(.SignInUser)) {
                        self.setInitialViewController(to: HomeMapViewController())
                    }
                case .FirebaseTokenError:
                    vc.showDefaultToast(message: .SignUpError(.FirebaseTokenError)) {
                        guard let idtoken = UserDefaults.idtoken else {
                            print("다음 버튼을 눌렀는데 토큰이 없어 🔴")
                            return }
                        vc.viewModel.logInNetwork(idtoken: idtoken)
                    }
                    
                case .NotsignUpUser:
                    vc.showDefaultToast(message: .SignUpError(.NotsignUpUser)) { [weak self] in
                        vc.showSelectedAlert(title: "첫방문을 환영합니다:)", message: "회원가입화면으로 넘어가시겠습니까?") { _ in
                            guard let DBitoken = FirebaseManager.shared.getIDTokenForcingRefresh() else { return }
                            UserDefaults.idtoken = DBitoken
                            let viewcontroller = NicknameViewController()
                            self?.transition(viewcontroller, .push)
                        }
                    }
                default:
                    vc.showDefaultToast(message: .SignUpError(.ClientError)) {
                        
                    }
                }
            }.disposed(by: disposedBag)
    }
}
