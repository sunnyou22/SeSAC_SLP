//
//  APIViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/19.
//

import Foundation

import RxCocoa
import RxSwift
import Alamofire
import FirebaseAuth

//manager로 넣어줄건지 고민해보기

final class CommonServerManager {
   
    let authValidCode = PublishRelay<AuthCredentialText>()
    let autoUserStaus = PublishRelay<SignUpError>()
    let transitionEvent = PublishRelay<SignUpError>()
    
    //MAKR: - 모델로 빼기
    func USerInfoNetwork(idtoken: String) {
        let api = SeSACAPI.getUserInfo
        
        Network.shared.requestSeSAC(type: GetUerIfo.self, url: api.url, parameter: nil, method: .get, headers: api.getheader(idtoken: idtoken)) { [weak self] response in
            
            LoadingIndicator.showLoading()
            
            switch response {
            case .success(let success):
                print("로그인 성공 혹은 유저 정보가져오기 성공 ✅", success)
                //                self?.GetUerIfo.onNext(success)
                LoadingIndicator.hideLoading()
                
                UserDefaults.getUerIfo = [success]
                
                // 여기에 이걸 넣어주는게 맞을까
                guard UserDefaults.phoneNumber != nil else {
                    self?.autoUserStaus.accept(.Success)
                    return
                }
                
                self?.autoUserStaus.accept(.SignInUser)
            case .failure(let failure):
                
                switch failure {
                case SignUpError.FirebaseTokenError:
                    LoadingIndicator.hideLoading()
                    
                    FirebaseManager.shared.getIDTokenForcingRefresh()
                    
                    print(#function, "idtoken만료 🔴", failure)
                    guard let DBitoken = FirebaseManager.shared.getIDTokenForcingRefresh() else { return }
                    UserDefaults.idtoken = DBitoken
                    self?.autoUserStaus.accept(.FirebaseTokenError)
                    
                case SignUpError.NotsignUpUser:
                    LoadingIndicator.hideLoading()
                    guard let DBitoken = FirebaseManager.shared.getIDTokenForcingRefresh() else { return }
                    UserDefaults.idtoken = DBitoken
                    self?.autoUserStaus.accept(.NotsignUpUser)
                default:
                    LoadingIndicator.hideLoading()
                   print("🔴 기타 에러, \(failure)")
                }
                //                self?.GetUerIfo.onError(failure)
            }
        }
    }
}
