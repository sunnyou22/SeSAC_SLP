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
    
    let bag = DisposeBag()
    
    let userStatus = PublishRelay<UserStatus>()
    let queueSearchStatus = PublishRelay<QueueSearchStatus>()
    let matchingStatus = PublishRelay<MyQueueStatus>()
    let deleteStatus = PublishRelay<DeleteStatus>()
    let userData: BehaviorRelay<[GetUerIfo]> = BehaviorRelay(value: [])
    //
    //MAKR: - 모델로 빼기
    
   final func UserInfoNetwork(idtoken: String, completion: ((GetUerIfo) -> Void)? = nil) {
        let api = SeSACAPI.getUserInfo
        
        Network.shared.receiveRequestSeSAC(type: GetUerIfo.self, url: api.url, parameter: nil, method: .get, headers: api.getheader(idtoken: idtoken))
           .debug("너는 어떻게 나오냐")
            .subscribe { [weak self] (data, statusCode) in
                guard let userStatus = UserStatus(rawValue: statusCode) else { return }
                guard let data = data else {
                    self?.userStatus.accept(userStatus)
                    return }
          
                self?.userData.accept([data])
              
                self?.userStatus.accept(userStatus)
            }.disposed(by: bag)
    }
        
    func fetchMapData(lat: Double, long: Double, idtoken: String) {
        let api = SeSACAPI.searchSurroundings(lat: lat, long: long)
        Network.shared.receiveRequestSeSAC(type: SearchSurroundings.self, url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken))
            .subscribe { [weak self] (data, statusCode) in
        
       guard let queueSearchStatus = QueueSearchStatus(rawValue: statusCode)  else { return }
            
            self?.queueSearchStatus.accept(queueSearchStatus)
            
            guard let data = data else {
                print("맵 좌표값에 대한 응답값 받기 에러 🔴 -> 함수 위치", #file, #function)
                return
            }
            
            UserDefaults.searchData = [data]
          
            print("주변 새싹 정보 받아오기 완료 유저디폴츠 출력✅🔗🔗🔗", #function, "/n", UserDefaults.searchData)
            }.disposed(by: bag)
    }
    
    /*
     guard let myQueueStatus = MyQueueStatus(rawValue: statusCode) else { return }
     self?.matchingStatus.accept(myQueueStatus)
     
     guard let result = data else {
         print("MatchStatus 가져오기 실패 🔴")
         MapViewModel.ploatingButtonSet.accept(UserMatchingStatus(rawValue: data?.matched ?? 2)!)
         return
     }
     
     print("getMatchStatus 메서드 매칭상태 출력 \n", result.matched ?? 100, result, myQueueStatus)
     UserDefaults.otherUid = result.matchedUid ?? ""
     // 호출할 때마다 유저의 상태를 알 수 잇도록
     MapViewModel.ploatingButtonSet.accept(UserMatchingStatus(rawValue: result.matched ?? 2)!)
 }
     */
    
    
    //5초 마다 상태 확인 필요 /v1/queue/myQueueState
    func getMatchStatus(idtoken: String) {
        let api = SeSACAPI.matchingStatus
        Network.shared.receiveRequestSeSAC(type: MatchStatus.self, url: api.url, method: .get, headers: api.getheader(idtoken: idtoken))
            .subscribe { [weak self] (data, statusCode) in
                guard let myQueueStatus = MyQueueStatus(rawValue: statusCode) else { return }
                self?.matchingStatus.accept(myQueueStatus)
                guard let result = data else { return }
                UserDefaults.otherUid = result.matchedUid ?? ""
                MapViewModel.ploatingButtonSet.accept(UserMatchingStatus(rawValue: result.matched ?? 2)!)
                print("getMatchStatus 메서드 매칭상태 출력 \n", result.matched ?? 100, result, myQueueStatus)
            }.disposed(by: bag)
    }
        
        func delete(idtoken: String) {
            
            let api = SeSACAPI.delete
            
            Network.shared.sendRequestSeSAC(url: api.url, method: .delete, headers: api.getheader(idtoken: idtoken)) { [weak self] statusCode in
                
                guard let delete = DeleteStatus(rawValue: statusCode) else { return }
                self?.deleteStatus.accept(delete)
                
                //            MapViewModel.ploatingButtonSet.accept(.init(rawValue: data.matched ?? 2)!)
            }
        }
    }
    
    
