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
import NotiModel

class VerificationViewController: BaseViewController {
    
    var mainView = VerificationView()
    let signInViewModel = SignInViewModel()
    let apiViewModel = CommonServerManager()
    let disposedBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("======", UserDefaults.standard.dictionaryRepresentation(), "========")
        
        bindData()
    }
    
    func bindData() {
        
        mainView.inputTextField.rx
            .text
            .orEmpty
            .withUnretained(self)
            .bind(onNext: { vc, text in
                print(text, "=======")
                vc.signInViewModel.checkValidCode(text: text)
            }).disposed(by: disposedBag)
        
        signInViewModel.textfield
            .withUnretained(self)
            .bind { vc, text in
                vc.mainView.inputTextField.text = text
            }.disposed(by: disposedBag)
        
        signInViewModel.buttonValid
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
                vc.signInViewModel.networkWithFireBase(num: num)
            }.disposed(by: disposedBag)
        
        mainView.nextButton.rx
            .tap
            .withUnretained(self)
            .bind { vc, _ in
                print("버튼눌림")
                // 회색버튼이어도 활성화돼있는 상태
                vc.signInViewModel.matchCredential()
            }.disposed(by: disposedBag)
        
        signInViewModel.authPhoneNumResult
            .withUnretained(self)
            .bind { vc, reponse in
                switch reponse {
                case .success:
                    print("전화번호인증 성공 🟢🟢")
                case .invalidPhoneNumber:
                    vc.showDefaultToast(message: .AuthVerifyPhoneNumber(.invalidPhoneNumber))
                case .tooManyRequests:
                    vc.showDefaultToast(message: .AuthVerifyPhoneNumber(.tooManyRequests))
                case .otherError:
                    vc.showDefaultToast(message: .AuthVerifyPhoneNumber(.otherError))
                }
            }.disposed(by: disposedBag)
        
        //파베 에러
        signInViewModel.authValidCode
            .withUnretained(self)
            .bind { vc, reponse in
                switch reponse {
                case .success:
//                    guard let idtoken = UserDefaults.idtoken else { return }
//                    vc.apiViewModel.USerInfoNetwork(idtoken: idtoken)
                    let viewcontroller = NicknameViewController()
                    vc.showSelectedAlert(title: "첫방문을 환영합니다:)", message: "회원가입화면으로 넘어가시겠습니까?") { [weak self] _ in
                        let viewcontroller = NicknameViewController()
                        self?.transition(viewcontroller, .push)
                    }
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
//
//        //api 에러
//        apiViewModel.commonError
//            .withUnretained(self)
//            .bind { vc, response in
//                switch response {
//                case .Success:
//
//                case .FirebaseTokenError:
//                    vc.showDefaultToast(message: .defaultSignupMessage(.FirebaseTokenError)) {
//
//                        guard let idtoken = UserDefaults.idtoken else {
//                            print("idtoken오류 🔴", #file, #function)
//                            return }
//                        vc.apiViewModel.USerInfoNetwork(idtoken: idtoken)
//                    }
//
//                case .NotsignUpUser:
//                    vc.showDefaultToast(message: .defaultSignupMessage(.NotsignUpUser)) { [weak self] in
//                        vc.showSelectedAlert(title: "첫방문을 환영합니다:)", message: "회원가입화면으로 넘어가시겠습니까?") { _ in
//                            let viewcontroller = NicknameViewController()
//                            self?.transition(viewcontroller, .push)
//                        }
//                    }
//                case .ServerError:
//                    print("서버에러🔴", #function)
//                case .ClientError:
//                    vc.showDefaultToast(message: .defaultSignupMessage(.ClientError))
//                }
//            }.disposed(by: disposedBag)
//
//        apiViewModel.usererror
//            .withUnretained(self)
//            .bind { vc, error in
//                switch error {
//                case .SignInUser:
//                    vc.showDefaultToast(message: .Signup(.SignInUser)) {
//                        vc.setInitialViewController(to: HomeMapViewController())
//                    }
//                case .InvaliedNickName:
//                    print("여기서는 필요하지 않은 에러")
//                case .NotsignUpUser:
//                    print("여기서는 필요하지 않은 에러")
//                }
//            }.disposed(by: disposedBag)
    }
}
