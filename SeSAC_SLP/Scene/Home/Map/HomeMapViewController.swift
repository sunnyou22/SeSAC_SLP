//
//  HomeMapViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/18.
//

import UIKit
import MapKit // 지도
import RxSwift
import RxCocoa
import RxMKMapView
import RxCoreLocation

enum UserMatchingStatus {
    case defaults
    case matched
    case matching
}

class HomeMapViewController: BaseViewController {
    
    var mainView = CustomMapView()
    let viewModel = MapViewModel()
    let disposedBag = DisposeBag()
    let manager = CLLocationManager()
    let sesacCoordinate = CLLocationCoordinate2D(latitude: 37.51818789942772, longitude: 126.88541765534976) //새싹 영등포 캠퍼스의 위치입니다. 여기서 시작하면 재밌을 것 같죠? 하하
    
    //버튼의 상태 나타내줄 때: 기본값은 디폴틍틍
    init(userStatus: UserMatchingStatus = .defaults) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //코어로케이션 매니저 설정
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        mainView.mapView.delegate = self
        mainView.mapView.showsUserLocation = true
        mainView.mapView.setUserTrackingMode(.none, animated: true)
        
        bindData()
        
        bindMapViewData()
        
        addCustomPin()
        
        guard let idtoken = UserDefaults.idtoken else {
            print("itocken만료")
            return
        }
        
        // 현재위치를 기준으로 최초로 불러오기
//        viewModel.fetchMapData(lat: (manager.location?.coordinate.latitude)!, long: (manager.location?.coordinate.longitude)!, idtoken: idtoken)
        viewModel.fetchMapData(lat: sesacCoordinate.latitude, long: sesacCoordinate.longitude, idtoken: idtoken)
        print(UserDefaults.searchData, "✅✅Userdefaults.searchData 디코뒹✅✅")
        addAnnotation()
    }
    
    private func addCustomPin() {
        let pin = MKPointAnnotation()
        //포인트 어노테이션은 뭔가요?
        pin.coordinate = sesacCoordinate
        pin.title = "새싹 영등포캠퍼스"
        pin.subtitle = "전체 3층짜리 건물"
        mainView.mapView.addAnnotation(pin)
    }
    
    func checkUserDevieceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
     
        //디바이스의 위치설정상태를 가져옴
        if #available(iOS 14.0, *) {
            authorizationStatus = manager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkUserDevieceLocationServiceAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 껴저 있어 위치 권한 요청을 할 수 없습니다")
        }
    }
    
    func checkUserDevieceLocationServiceAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOTDETERMINED")
            
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
            showSelectedAlert(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요\n설정창으로 이동하시겠습니까?") { _ in
                if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSetting)
                }
            }
     
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default: print("DEFAULT")
        }
    }
    
    func bindData() {
        /// Start Subscribing
        /// Works on simulator and device
        /// Subscribe to didUpdateLocations
        manager.rx
            .didUpdateLocations
            .debug("didUpdateLocations")
            .withUnretained(self)
            .subscribe(onNext: { vc, value in
                if let coordinate = value.locations.last?.coordinate {
                  // 일단 캠퍼스 위치로 검색하기
                    let region = MKCoordinateRegion(center: vc.sesacCoordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
                    vc.mainView.mapView.setRegion(region, animated: true)
                }
            })
            .disposed(by: disposedBag)
        
        /// Subscribe to didChangeAuthorization
        manager.rx
            .didChangeAuthorization
            .debug("didChangeAuthorization")
            .subscribe(onNext: { _ in
              
            })
            .disposed(by: disposedBag)
        
        /// Subscribe to placemark
        manager.rx
            .placemark
            .debug("placemark")
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
            })
            .disposed(by: disposedBag)
        
        manager.rx
            .placemark
            .subscribe(onNext: { placemark in
                guard let name = placemark.name,
                    let isoCountryCode = placemark.isoCountryCode,
                    let country = placemark.country,
                    let postalCode = placemark.postalCode,
                    let locality = placemark.locality,
                    let subLocality = placemark.subLocality else {
                        return print("oops it looks like your placemark could not be computed")
                }
                print("name: \(name)")
                print("isoCountryCode: \(isoCountryCode)")
                print("country: \(country)")
                print("postalCode: \(postalCode)")
                print("locality: \(locality)")
                print("subLocality: \(subLocality)")
            })
            .disposed(by: disposedBag)
        
        /// Subscribe to location
        manager.rx
            .location
            .debug("location")
            .subscribe(onNext: { _ in })
            .disposed(by: disposedBag)
        
        /// Subscribe to activityType
        manager.rx
            .activityType
            .debug("activityType")
            .subscribe(onNext: {_ in})
            .disposed(by: disposedBag)
        
        /// Subscribe to isEnabled
        manager.rx
            .isEnabled
            .debug("isEnabled")
            .subscribe(onNext: { _ in })
            .disposed(by: disposedBag)
        
        /// Subscribe to didError
        manager.rx
            .didError
            .debug("didError")
            .subscribe(onNext: { _ in })
            .disposed(by: disposedBag)
        
        ///Note works on Device
        
        /// Subscribe to didDetermineState
        manager.rx
            .didDetermineState
            .debug("didDetermineState")
            .subscribe(onNext: { _ in })
            .disposed(by: disposedBag)
        
        /// Subscribe to didReceiveRegion
        manager.rx
            .didReceiveRegion
            .debug("didReceiveRegion")
            .withUnretained(self)
            .subscribe(onNext: { vc, value in
             
            })
            .disposed(by: disposedBag)
        
        /// Subscribe to didResume
        manager.rx
            .didResume
            .debug("didResume")
            .subscribe(onNext: { _ in })
            .disposed(by: disposedBag)
    }
    
    func bindMapViewData() {
        mainView.mapView.rx.willStartLoadingMap
            .asDriver()
            .drive(onNext: {
                print("Map started loading")
            })
            .disposed(by: disposedBag)

        mainView.mapView.rx.didFinishLoadingMap
            .asDriver()
            .drive(onNext: {
                print("Map finished loading")
            })
            .disposed(by: disposedBag)

        mainView.mapView.rx.regionDidChangeAnimated
            .subscribe(onNext: { _ in
                print("Map region changed")
            })
            .disposed(by: disposedBag)

        mainView.mapView.rx.region
            .subscribe(onNext: { region in
                //5초 버퍼걸기 -> 스레드이용?
//                print("Map region is now \(region)")
//                guard let idtoken = UserDefaults.idtoken else {
//                    print("itocken만료")
//                    return
//                }
//                viewModel.fetchMapData(lat: region.center.latitude, long: region.center.longitude, idtoken: idtoken)
            })
            .disposed(by: disposedBag)
    }
}


// MARK: - MKMapView Delegates
extension HomeMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        var annotationView = mainView.mapView.dequeueReusableAnnotationView(withIdentifier: "customAnnotation")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customAnnotation")
            annotationView?.canShowCallout = false // 어노테이션에 추가 정보 달거니~?
            annotationView?.contentMode = .scaleAspectFit // 어노테이션 이미지 사이즈모드는 뭐니?
            
        } else {
            annotationView?.annotation = annotation
        }
        
        let sesacImage: UIImage = UIImage(named: "sesac_face_1")!
        let size = CGSize(width: 85, height: 85) // 초기사이즈 설정
        UIGraphicsBeginImageContext(size) // 코어그래픽에 객체의 정보를 담음 이제 이걸로 지지고 볶을 거임 // 그리기 씌작
//        annotationView?.image = UIImage(named: "sesac_face_1")
        
        sesacImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext() // 그리기 끝난 값을 넣어줌
        annotationView?.image = resizedImage
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { $0.alpha = 0.0 }

        UIView.animate(withDuration: 0.4,
                       animations: {
                        views.forEach { $0.alpha = 1.0 }
                       })
    }
    
    
    func addAnnotation() {
        let UserData = UserDefaults.searchData
        
        UserData?.forEach({ search in
            search.fromQueueDB.forEach { data in
                let center = CLLocationCoordinate2D(latitude: data.lat, longitude: data.long)
                let annotation = MKPointAnnotation()
                let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mainView.mapView.setRegion(region, animated: true)
                annotation.coordinate = center
                annotation.title = "\(data.gender)"
                mainView.mapView.addAnnotation(annotation)
            }
            
        })
        
       
    }
}

// MARK: - Map Annotation and Helpers
class PointOfInterest: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?

    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}

extension MKCoordinateRegion {
    func contains(poi: PointOfInterest) -> Bool {
        return abs(self.center.latitude - poi.coordinate.latitude) <= self.span.latitudeDelta / 2.0
            && abs(self.center.longitude - poi.coordinate.longitude) <= self.span.longitudeDelta / 2.0
    }
}
