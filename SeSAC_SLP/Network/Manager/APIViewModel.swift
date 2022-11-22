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
    let usererror = PublishRelay<ServerError.UserError>()
   
    let commonError = PublishRelay<ServerError.CommonError>()
    
    //MAKR: - 모델로 빼기
    func USerInfoNetwork(idtoken: String) {
        let api = SeSACAPI.getUserInfo
        
        Network.shared.requestSeSAC(type: GetUerIfo.self, url: api.url, parameter: nil, method: .get, headers: api.getheader(idtoken: idtoken)) { [weak self] response in

            switch response {
            case .success(let success):
                print("로그인 성공 혹은 유저 정보가져오기 성공 ✅", success)
                UserDefaults.getUerIfo = [success]
                
                self?.usererror.accept(.SignInUser)
//                self?.usererror.accept(.NotsignUpUser)
            case .failure:
                print("실ㅍㅐ")
    
            }
            // 수정하자..에러. // 그래 이거는 실패일때만 ㄸ떳지
        } errorHandler: { [weak self] statusCode in
            
            guard let userError = ServerError.UserError(rawValue: statusCode) else { return }
            guard let commonError = ServerError.CommonError(rawValue: statusCode) else { return }
            
            switch commonError {
                
            case .Success:
                self?.commonError.accept(.Success)
            case .FirebaseTokenError:

//                FirebaseManager.shared.getIDTokenForcingRefresh()
                self?.commonError.accept(.FirebaseTokenError)
            case .NotsignUpUser:

                self?.commonError.accept(.NotsignUpUser)
            case .ServerError:

                self?.commonError.accept(.ServerError)
            case .ClientError:

                self?.commonError.accept(.ClientError)
            }
            
            switch userError {
            case .SignInUser:
                self?.usererror.accept(.SignInUser)
            case .InvaliedNickName:
                self?.usererror.accept(.InvaliedNickName)
            case .NotsignUpUser:
                self?.usererror.accept(.NotsignUpUser)
            }
        }
    }
 
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

