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
    let viewModel = SignUpViewModel()
    let disposedBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        mainView.inputTextField.addTarget(self, action: #selector(changedTextfield), for: .editingChanged)
        print( UserDefaults.idtoken, "🔓")
        print("저나번호☎️", UserDefaults.phoneNumber, UserDefaults.repostNum)
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
//                vc.mainView.nextButton.isEnabled = bool ? true : false
                vc.mainView.nextButton.backgroundColor = bool ? .setBrandColor(color: .green) : .setGray(color: .gray6)
            }.disposed(by: disposedBag)
        
        mainView.rePostButton.rx
            .tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.setVerification(num: UserDefaults.repostNum!)
                print("UserDefaults.repostNum ☎️", UserDefaults.repostNum)
            }.disposed(by: disposedBag)
        
        mainView.nextButton.rx
            .tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.credential()
                print(" UserDefaults.phoneNumber, UserDefaults.repostNum ☎️", UserDefaults.phoneNumber, UserDefaults.repostNum)
                
            }.disposed(by: disposedBag)
    }
    
    // Rx로 바꿔줘야함
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
        
        print(verificationID,"✖️", verificationCode, "🔓", #function)
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            if let error = error {
                
                switch error {
                case AuthErrorCode.missingVerificationID:
                    self?.view.makeToast("전화 번호 인증 실패", position: .center) // 타이머의 시간이 지났을 때의 메서드에 해당 오류를 던져야함
                case AuthErrorCode.invalidVerificationID:
                    self?.view.makeToast("전화 번호 인증 실패", position: .center)
                case AuthErrorCode.invalidUserToken:
                    self?.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.", position: .center)
                default:
                    self?.view.makeToast("에러가 발생했습니다. 다시 시도해주세요.", position: .center)
                }
                
                print("Unable to login with Phone : error[\(error)] 🔴")
                return
            } else {
                self?.getNetwork()
                print("Phone Number user is signed in \(String(describing: result?.user.uid))  ☎️✅")
            }
            
        }
    }
    
    //MARK: 서버랑 소통 - 토큰인증
    func getNetwork() {
  
        guard let phoneNum = UserDefaults.phoneNumber else {
            
            mainView.makeToast("유효하지 않는 번호입니다. 다시 입력해주세요", duration: 0.8, position: .center)
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        guard let DBidtoken = UserDefaults.idtoken else {
            print("🔴 Idtoken 없음", #function)
            return
        }
        
        viewModel.logInNetwork(phoneNumber: phoneNum, idtoken: DBidtoken) { [weak self] response in
            
            switch response {
                
            case SignUpError.Success:
                print(#function, "로그인 성공 ✅", response)
                self?.mainView.makeToast("이미 가입한 회원입니다.", duration: 0.7, position: .center) { didTap in
                    let viewcontroller = HomeViewController()
                    self?.transition(viewcontroller, .presentFullScreen)
                }
                
            case SignUpError.FirebaseTokenError:
                print(#function, "idtoken만료 🔴", response)
                    guard let DBitoken = self?.getIDTokenForcingRefresh() else { return }
                    UserDefaults.idtoken = DBitoken
                self?.mainView.makeToast("인증이력이 있으시군요! 회원가입화면으로 이동하겠습니다.", duration: 0.7, position: .center) { didTap in
                    let viewcontroller = NicknameViewController()
                    self?.transition(viewcontroller, .push)
                }
                
            case SignUpError.NotsignUpUser:
                print(#function, "신규가입자 🔴", response)
                let alert = UIAlertController(title: "첫방문을 환영합니다:)", message: "회원가입화면으로 넘어가시겠습니까?", preferredStyle: .alert)
                let ok = UIAlertAction(title: "네", style: .default) { [weak self] _ in
                    guard let DBitoken = self?.getIDTokenForcingRefresh() else { return }
                    UserDefaults.idtoken = DBitoken
                    let viewcontroller = NicknameViewController()
                    self?.transition(viewcontroller, .push)
                }
                
                let cancel = UIAlertAction(title: "아니오", style: .cancel)
                alert.addAction(ok)
                alert.addAction(cancel)
                
                self?.present(alert, animated: true)
            default:
                print(#function, "알 수 없는 응답값 🟠", response)
                // 경우의 수 생각해보기 ☑️
                self?.mainView.makeToast("알 수 없는 에러가 발생했습니다. 앱을 재실행해주세요!", duration: 0.7, position: .center)
            }
            
            
        }
    }
    
    func getIDTokenForcingRefresh() -> String? {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print(error, "🔴 idtoken을 받아올 수 없습니다.")
                return
            } else {
                guard let idtoken = idToken else { return }
                UserDefaults.idtoken = idtoken
            }
        }
        return UserDefaults.idtoken
    }
    
    //MARK: 파베랑 소통 - 번호 인증
    func setVerification(num: String) {
        
        // verifyPhoneNumber 메서드는 원래 요청이 시간 초과되지 않는 한 두 번째 SMS를 보내지 않습니다.
    
        Auth.auth().languageCode = "kr"
        PhoneAuthProvider.provider()
            .verifyPhoneNumber("+82\(num)", uiDelegate: nil) { [weak self] (verificationID, error) in
                
                UserDefaults.phoneNumber = "+82\(num)"
                print("☎️ UserDefaults.phoneNumber 가 잘 설정됐남 ",  UserDefaults.phoneNumber)
                if let error = error {
                    switch error {
                    case AuthErrorCode.invalidPhoneNumber:
                        self?.view.makeToast("잘못된 전화번호 형식입니다.", position: .center)
                  
                    case AuthErrorCode.tooManyRequests:
                        self?.view.makeToast("과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요.", position: .center)
                    
                    default:
                        print(#function, "파베 에러들 중 하나 발생 🔴")
                        self?.view.makeToast("에러가 발생했습니다. 다시 시도해주세요", position: .center)
                    }
                    print(error.localizedDescription, error, "🔴")
                    return
                } else {
                    let viewcontroller = VerificationViewController()
                    self?.transition(viewcontroller, .push)
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    print("success ✅")
                }
            }
    }
}
