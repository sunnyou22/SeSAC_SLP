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
   
    static let ploatingButtonSet: BehaviorRelay<UserMatchingStatus> = BehaviorRelay(value: .search)
    
    let manager = CLLocationManager()
    
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
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
            checkUserDevieceLocationServiceAuthorization(authorizationStatus)
        }
    }
    
    // 나중에 현재위치 넣어줄때 사용하기
    func setcurrentRegion(location: CLLocationCoordinate2D, completion: @escaping ((MKCoordinateRegion) -> Void)) {
        // 현재 위치의 반경을 700으로 정해주기
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 700, longitudinalMeters: 700)
        completion(region)
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
            // 기본 새싹위치로 넣어주고 잇음
            setdefaultLocation.accept(MapViewModel.LandmarkLocation.sesacLocation)
        case .authorizedWhenInUse:
            setcurrentRegion(location: MapViewModel.LandmarkLocation.sesacLocation) { _ in
                print("들어오남")
            }
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
          
                annotation.coordinate = center
                annotation.title = "\(data.nick)"
                annotations.append(annotation)
            }
        })
        return annotations
    }
}

