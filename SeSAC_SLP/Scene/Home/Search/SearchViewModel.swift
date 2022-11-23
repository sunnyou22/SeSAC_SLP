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
    
    let queueStatus = PublishRelay<ServerStatus.QueueError>()
    //    let commonError = PublishRelay<ServerStatus.Common>()
    
    //새싹찾기 버튼 클릭
    func searchSeSACMate(lat: Double, long: Double, studylist: [String], idtoken: String) {
        let api = SeSACAPI.search(lat: lat, lon: long, studylist: studylist)
        Network.shared.sendRequestSeSAC(url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { statuscode in
            print(statuscode)
        }
//    func searchSeSACMate(lat: Double, long: Double, studylist: [String], idtoken: String) {
//
//        print(lat, long, studylist, idtoken, " ===========================")
//        // 사용자는 anything문자열을 볼 수 없음
//        let api = SeSACAPI.search(lat: lat, long: long, studylist: studylist)
//
//        print(api, "api@@@@@@@@@@@@@@@@@")
//
//        Network.shared.requestSeSAC(type: Search.self, url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { [weak self] data, statusCode in
//
//            guard let data = data else {
//                print("QueueStatus 가져오기 실패 🔴")
//                guard let queueStatus = QueueStatus(rawValue: statusCode) else { return }
//
//                switch queueStatus {
//                case .threeTimesReport:
//                    self?.queueStatus.accept(.threeTimesReport)
//                case .firstPenalty:
//                    self?.queueStatus.accept(.firstPenalty)
//                case .secondPenalty:
//                    self?.queueStatus.accept(.secondPenalty)
//                case .thirdPenalty:
//                    self?.queueStatus.accept(.thirdPenalty)
//                }
//                return
//            }
//
//            print("getMatchStatus🚀\n", data)
//            MapViewModel.ploatingButtonSet.accept(.waiting)
//
//            print("파라미터 🔴\n", api.parameter, "🔴 URL\n", api.url, "🔴 api", api)
//
//        }
    }
}

