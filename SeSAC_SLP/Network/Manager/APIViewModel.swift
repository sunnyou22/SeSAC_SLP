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

            switch response {
            case .success(let success):
                print("로그인 성공 혹은 유저 정보가져오기 성공 ✅", success)
                //                self?.GetUerIfo.onNext(success)
            
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
    
    let detailError = PublishRelay<ServerError.QueueError>()
    let commonError = PublishRelay<ServerError.CommonError>()
    
    // 공통요소로 빼기 -> 위치가 이동할 때마다 호출해줘야함
    func fetchMapData(lat: Double, long: Double, idtoken: String) {
        let api = SeSACAPI.searchSurroundings(lat: lat, long: long)
        Network.shared.requestSeSAC(type: SearchSurroundings.self, url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { response in
            
            switch response {
            case .success(let success):
                dump(success)
                //                print(success)
                // 응답값을 받아와야함
                
                UserDefaults.searchData = [success]
                print(UserDefaults.searchData, " 🔴 🔴 🔴 인코딩이 잘 됐나요~")
                
                print("맵 좌표값에 대한 응답값 받기 성공 ✅")
            case .failure(let error):
                print("맵 좌표값 받기 에러 🔴", #file, #function)
                print(error)
                
            }
        } errorHandler: { [weak self] statusCode in
         
            guard let commonError = ServerError.CommonError(rawValue: statusCode) else { return }
           
            switch commonError {
            case .Success:
                self?.commonError.accept(.Success)
            case .FirebaseTokenError:
                self?.commonError.accept(.FirebaseTokenError)
            case .ServerError:
                self?.commonError.accept(.ServerError)
            case .ClientError:
                self?.commonError.accept(.ClientError)
            case .NotsignUpUser:
                self?.commonError.accept(.NotsignUpUser)
            }
        }
    }
}

