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
    let userStatus = PublishRelay<UserStatus>()
    let queueSearchStatus = PublishRelay<QueueSearchStatus>()
    
    //
    //MAKR: - 모델로 빼기
    func USerInfoNetwork(idtoken: String) {
        let api = SeSACAPI.getUserInfo
        
        Network.shared.requestSeSAC(type: GetUerIfo.self, url: api.url, parameter: nil, method: .get, headers: api.getheader(idtoken: idtoken)) { [weak self] data, statusCode  in
            
            guard let data = data else {
                print("userData 가져오기 실패 🔴")
                
                guard let userStatus = UserStatus(rawValue: statusCode) else { return }
                
                switch userStatus {
                case .Success:
                    self?.userStatus.accept(.Success)
                case .SignInUser:
                    self?.userStatus.accept(.SignInUser)
                case .InvaliedNickName:
                    self?.userStatus.accept(.InvaliedNickName)
                case .FirebaseTokenError:
                    self?.userStatus.accept(.FirebaseTokenError)
                    FirebaseManager.shared.getIDTokenForcingRefresh()
                case .NotsignUpUser:
                    self?.userStatus.accept(.NotsignUpUser)
                case .ServerError:
                    self?.userStatus.accept(.ServerError)
                case .ClientError:
                    self?.userStatus.accept(.ClientError)
                }
                return
            }
            //성공
            print("로그인 성공 혹은 유저 정보가져오기 성공 ✅", data)
            UserDefaults.getUerIfo = [data]
        }
    }
    
    // 공통요소로 빼기 -> 위치가 이동할 때마다 호출해줘야함
    func fetchMapData(lat: Double, long: Double, idtoken: String) {
        let api = SeSACAPI.searchSurroundings(lat: lat, long: long)
        Network.shared.requestSeSAC(type: SearchSurroundings.self, url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { [weak self] data , statusCode  in
            
            guard let data = data else {
                print("맵 좌표값 받기 에러 🔴", #file, #function)
                
                guard let queueSearchStatus = QueueSearchStatus(rawValue: statusCode) else { return }
                
                switch queueSearchStatus {
                    
                case .Success:
                    self?.queueSearchStatus.accept(.Success)
                case .FirebaseTokenError:
                    FirebaseManager.shared.getIDTokenForcingRefresh()
                    self?.queueSearchStatus.accept(.FirebaseTokenError)
                case .NotsignUpUser:
                    self?.queueSearchStatus.accept(.NotsignUpUser)
                case .ServerError:
                    self?.queueSearchStatus.accept(.ServerError)
                case .ClientError:
                    self?.queueSearchStatus.accept(.ClientError)
                }
                return
            }
            print("맵 좌표값에 대한 응답값 받기 성공 ✅")
            dump(data)
            UserDefaults.searchData = [data]
            print(UserDefaults.searchData, " 🔴 🔴 🔴 인코딩이 잘 됐나요~")
        }
    }
}
    
