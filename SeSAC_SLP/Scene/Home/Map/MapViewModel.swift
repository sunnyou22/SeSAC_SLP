//
//  MapViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/18.
//

import Foundation
import RxCocoa
import RxSwift
import CoreLocation

class MapViewModel {
    
    static let ploatingButtonSet: PublishRelay<UserMatchingStatus> = PublishRelay()
  
    let detailError = PublishRelay<ServerError.QueueError>()
    let commonError = PublishRelay<ServerError.CommonError>()
    
    //5초 마다 상태 확인 필요
    func getMatchStatus(idtoken: String) {
        let api = SeSACAPI.matchingStatus

        Network.shared.requestSeSAC(type: MatchStatus.self, url: api.url, method: .get, headers: api.getheader(idtoken: idtoken)) {     response in
            switch response {
            case .success(let data):
                print("getMatchStatus🚀\n", data.matched ?? 100, data)
      
            case .failure(let error):
                print("getMatchStatus error 🔴\n", error)

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


/*

 
 */
