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

    func USerInfoNetwork(idtoken: String, completion: ((GetUerIfo) -> Void)? = nil) {
        let api = SeSACAPI.getUserInfo
        
        Network.shared.receiveRequestSeSAC(type: GetUerIfo.self, url: api.url, parameter: nil, method: .get, headers: api.getheader(idtoken: idtoken)) { [weak self] data, statusCode  in
            
            guard let userStatus = UserStatus(rawValue: statusCode) else { return }
            self?.userStatus.accept(userStatus)
            
            guard let data = data else {
                print("userData 가져오기 실패 🔴")
                return
            }
            
            print("로그인 성공 혹은 유저 정보가져오기 성공 ✅", data)
            
            //성공
            completion?(data)
        }
    }
    
    // 공통요소로 빼기 -> /v1/queue/search, 위치가 이동할 때, 검색화면에서 최초 주변 유저정보를 받아올 때
    func fetchMapData(lat: Double, long: Double, idtoken: String) {
        let api = SeSACAPI.searchSurroundings(lat: lat, long: long)
        Network.shared.receiveRequestSeSAC(type: SearchSurroundings.self, url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { [weak self] data , statusCode  in
            
            guard let queueSearchStatus = QueueSearchStatus(rawValue: statusCode) else { return }
           
            self?.queueSearchStatus.accept(queueSearchStatus)
            
            guard let data = data else {
                print("맵 좌표값에 대한 응답값 받기 에러 🔴 -> 함수 위치", #file, #function)
                return
            }
            
            UserDefaults.searchData = [data]
            print("주변 새싹 정보 받아오기 완료 유저디폴츠 출력✅", #function, "/n", UserDefaults.searchData)
        }
    }
}
    
