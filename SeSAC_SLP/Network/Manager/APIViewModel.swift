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
    let commonerror = PublishRelay<ServerError.CommonError>()
    let usererror = PublishRelay<ServerError.UserError>()
    //    let transitionEvent = PublishRelay<SignUpError>()
    
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
                    self?.commonerror.accept(.Success)
                    return
                }
                
                self?.usererror.accept(.SignInUser)
            case .failure( _):
                print("살페")
                //                self?.GetUerIfo.onError(failure)
            }
        } errorHandler: { [weak self] statusCode in
            
            guard let commonError = ServerError.CommonError(rawValue: statusCode) else { return }
            
            switch commonError {
                
            case .Success:
                LoadingIndicator.hideLoading()
                self?.commonerror.accept(.Success)
            case .FirebaseTokenError:
                guard let DBitoken = FirebaseManager.shared.getIDTokenForcingRefresh() else { return }
                UserDefaults.idtoken = DBitoken
                LoadingIndicator.hideLoading()
                self?.commonerror.accept(.FirebaseTokenError)
            case .NotsignUpUser:
                LoadingIndicator.hideLoading()
                self?.commonerror.accept(.NotsignUpUser)
            case .ServerError:
                LoadingIndicator.hideLoading()
                self?.commonerror.accept(.ServerError)
            case .ClientError:
                LoadingIndicator.hideLoading()
                self?.commonerror.accept(.ClientError)
            }
        }
    }
    
    
}

