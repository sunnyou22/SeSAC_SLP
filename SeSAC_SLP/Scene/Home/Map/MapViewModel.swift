//
//  MapViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/18.
//

import Foundation
import RxCocoa
import RxSwift

class MapViewModel {
    
    static let ploatingButtonSet: PublishRelay<UserMatchingStatus> = PublishRelay()
    
    let detailError = PublishRelay<ServerError.QueueError>()
    let commonError = PublishRelay<ServerError.CommonError>()
    
    // 공통요소로 빼기 -> 위치가 이동할 때마다 호출해줘야함
    func fetchMapData(lat: Double, long: Double, idtoken: String) {
        let api = SeSACAPI.search(lat: lat, long: long)
        Network.shared.requestSeSAC(type: Search.self, url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { response in
            
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
            guard let detailError = ServerError.QueueError(rawValue: statusCode) else { return }
            guard let commonError = ServerError.CommonError(rawValue: statusCode) else { return }
            
            switch detailError {
            case .threeTimesReport:
                self?.detailError.accept(.threeTimesReport)
            case .firstPenalty:
                self?.detailError.accept(.firstPenalty)
            case .secondPenalty:
                self?.detailError.accept(.secondPenalty)
            case .thirdPenalty:
                self?.detailError.accept(.thirdPenalty)
            }
            
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
            return
        }
    }
    
    func getMatchStatus(idtoken: String) {
        let api = SeSACAPI.matchingStatus
        
        Network.shared.requestSeSAC(type: MatchStatus.self, url: api.url, method: .get, headers: api.getheader(idtoken: idtoken)) { response in
            switch response {
            case .success(let data):
                print("getMatchStatus🚀\n", data)
            case .failure(let error):
                print("getMatchStatus error 🔴\n", error)
                
            }
        } errorHandler: { <#Int#> in
            <#code#>
        }

    }
}


