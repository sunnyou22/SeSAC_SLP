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
import RxCoreLocation
import CoreLocation

final class MapViewModel {
    
    struct LandmarkLocation {
        static let sesacLocation = CLLocationCoordinate2D(latitude: 37.51818789942772, longitude: 126.88541765534976)
    }
   
    static let ploatingButtonSet: PublishRelay<UserMatchingStatus> = PublishRelay()
    
    let manager = CLLocationManager()
    let matchingStatus = PublishRelay<MyQueueStatus>()
    //    let commonError = PublishRelay<ServerStatus.Common>()
    var transitionToSearcnVC: ControlEvent<UserMatchingStatus>?
    let checkAuthorizationStatus = PublishRelay<CLAuthorizationStatus>()
    lazy var setdefaultLocation: BehaviorRelay<CLLocationCoordinate2D> = BehaviorRelay(value: MapViewModel.LandmarkLocation.sesacLocation)
    
    // 이후 터치 이벤트받아서 알엑스로 전환
    func checkUserDevieceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        //디바이스의 위치설정상태를 가져옴
        if #available(iOS 14.0, *) {
            authorizationStatus = manager.authorizationStatus
            checkUserDevieceLocationServiceAuthorization(authorizationStatus)
            setdefaultLocation.accept(MapViewModel.LandmarkLocation.sesacLocation)
            print("위치 서비스가 껴저 있어 위치 권한 요청을 할 수 없습니다")
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
            checkUserDevieceLocationServiceAuthorization(authorizationStatus)
            setdefaultLocation.accept(MapViewModel.LandmarkLocation.sesacLocation)
            print("위치 서비스가 껴저 있어 위치 권한 요청을 할 수 없습니다")
        }
    }

    func setcurrentRegion(location: CLLocation?, completion: @escaping ((MKCoordinateRegion) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if let coordinate = location?.coordinate {
                
                // 현재 위치의 반경을 700으로 정해주기
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 700, longitudinalMeters: 700)
                completion(region)
            }
        }
    }
    
    func checkUserDevieceLocationServiceAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
            checkAuthorizationStatus.accept(.restricted)
            checkAuthorizationStatus.accept(.denied)
        case .authorizedWhenInUse:
            manager.startUpdatingLocation() // 이게 있어야 didUpdateLocation메서드가 호출
        default: print("DEFAULT")
        }
    }
    
    //어노테이션 추가 메서드 /v1/queue/search
    func addAnnotations() -> [MKPointAnnotation] {
        let UserData = UserDefaults.searchData
        var annotations = [MKPointAnnotation]()
        UserData?.forEach({ search in
            search.fromQueueDB.forEach { data in
                let center = CLLocationCoordinate2D(latitude: data.lat, longitude: data.long)
                let annotation = MKPointAnnotation()
                let region = MKCoordinateRegion(center: center, latitudinalMeters: 700, longitudinalMeters: 700)
                
                annotation.coordinate = center
                annotation.title = "\(data.nick)"
                annotations.append(annotation)
            }
        })
        return annotations
    }
    
    //5초 마다 상태 확인 필요 /v1/queue/myQueueState
    func getMatchStatus(idtoken: String) {
        let api = SeSACAPI.matchingStatus
        
        Network.shared.receiveRequestSeSAC(type: MatchStatus.self, url: api.url, method: .get, headers: api.getheader(idtoken: idtoken)) { [weak self] data, statusCode  in
            
            guard let myQueueStatus = MyQueueStatus(rawValue: statusCode) else { return }
            self?.matchingStatus.accept(myQueueStatus)
       
            guard let data = data else {
                print("MatchStatus 가져오기 실패 🔴")
                return
            }
            print("getMatchStatus🚀\n", data.matched ?? 100, data, myQueueStatus)
            MapViewModel.ploatingButtonSet.accept(.init(rawValue: data.matched ?? 2)!)
        }
    }
}

