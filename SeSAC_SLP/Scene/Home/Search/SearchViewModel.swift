//
//  SearchViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/20.
//

import Foundation

import RxCocoa
import RxSwift
import MapKit
import CoreLocation

final class SearchViewModel {
    
    var tapSearchBar: ControlEvent<Void>?
    var clickSearchButton: ControlEvent<Void>?
    
    let detailError = PublishRelay<ServerStatus.QueueError>()
    let commonError = PublishRelay<ServerStatus.Common>()
    
    //새싹찾기 버튼 클릭
    func searchSeSACMate(lat: Double, long: Double, studylist: [String]?, idtoken: String) {
        
        // 사용자는 anything문자열을 볼 수 없음
        let api = SeSACAPI.search(lat: lat, long: long, studylist: studylist ?? ["Anything"])
        
        Network.shared.requestSeSAC(type: Search.self, url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { response in
            switch response {
                
            case .success(let data):
                print("getMatchStatus🚀\n", data)
                MapViewModel.ploatingButtonSet.accept(.waiting)
                
                print("파라미터 🔴\n", api.parameter, "🔴 URL\n", api.url, "🔴 api", api)
                
            case .failure(let error):
                print("getMatchStatus error 🔴\n", error)
            }
        } statusHandler: { [weak self] statusCode in
            
            guard let commonError = ServerStatus.Common(rawValue: statusCode) else { return }
            
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
            
            guard let detailError = ServerStatus.QueueError(rawValue: statusCode) else { return }
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
        }

    }
}
