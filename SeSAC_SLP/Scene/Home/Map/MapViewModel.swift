//
//  MapViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/18.
//

import Foundation
import RxCocoa
import RxSwift
import MapKit
import CoreLocation

class MapViewModel {
    
    static let ploatingButtonSet: PublishRelay<UserMatchingStatus> = PublishRelay()
    
    let matchingStatus = PublishRelay<MyQueueStatus>()
    //    let commonError = PublishRelay<ServerStatus.Common>()
    
    var transitionToSearcnVC: ControlEvent<UserMatchingStatus>?
    
    //어노테이션 추가 메서드
    func addAnnotations() -> [MKPointAnnotation] {
        
        let UserData = UserDefaults.searchData
        var annotations = [MKPointAnnotation]()
        UserData?.forEach({ search in
            search.fromQueueDB.forEach { data in
                let center = CLLocationCoordinate2D(latitude: data.lat, longitude: data.long)
                let annotation = MKPointAnnotation()
                let region = MKCoordinateRegion(center: center, latitudinalMeters: 700, longitudinalMeters: 700)
                
                annotation.coordinate = center
                annotation.title = "\(data.gender)"
                annotations.append(annotation)
            }
        })
        return annotations
    }
    
    //5초 마다 상태 확인 필요 /v1/queue/myQueueState
    func getMatchStatus(idtoken: String) {
        let api = SeSACAPI.matchingStatus
        
        Network.shared.requestSeSAC(type: MatchStatus.self, url: api.url, method: .get, headers: api.getheader(idtoken: idtoken)) { [weak self] data, statusCode  in
            
            guard let data = data else {
                print("MatchStatus 가져오기 실패 🔴")
                MapViewModel.ploatingButtonSet.accept(.defaults)
                
                guard let myQueueStatus = MyQueueStatus(rawValue: statusCode) else { return }
                
                switch myQueueStatus {
                case .Success:
                    print("reponse를 정상적으로 받은 뒤 에러 🔴")
                    self?.matchingStatus.accept(.Success)
                case .defaultStatus:
                    self?.matchingStatus.accept(.defaultStatus)
                case .FirebaseTokenError:
                    FirebaseManager.shared.getIDTokenForcingRefresh()
                    self?.matchingStatus.accept(.FirebaseTokenError)
                case .NotsignUpUser:
                    self?.matchingStatus.accept(.NotsignUpUser)
                case .ServerError:
                    self?.matchingStatus.accept(.ServerError)
                case .ClientError:
                    self?.matchingStatus.accept(.ClientError)
                }
                return
            }
            print("getMatchStatus🚀\n", data.matched ?? 100, data)
            // 서버에서 매칭상태 받아오기
            self?.matchingStatus.accept(.Success)
            MapViewModel.ploatingButtonSet.accept(.init(rawValue: data.matched ?? 2)!)
        }
    }
}

