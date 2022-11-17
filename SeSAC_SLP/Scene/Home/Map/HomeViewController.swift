//
//  HomeViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/13.
//

import UIKit
import MapKit // 지도
import CoreLocation

class HomeViewController: BaseViewController {
    
    var mainView = CustomMapView()
    
    let locationManager = CLLocationManager()
    let sesacCoordinate = CLLocationCoordinate2D(latitude: 37.51818789942772, longitude: 126.88541765534976) //새싹 영등포 캠퍼스의 위치입니다. 여기서 시작하면 재밌을 것 같죠? 하하
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mainView.mapView.delegate = self
        
        locationManager.requestWhenInUseAuthorization() //권한요정
        
        mainView.mapView.showsUserLocation = true
        mainView.mapView.setUserTrackingMode(.follow, animated: true)
       
        
        
        mainView.matchingButton.addTarget(self, action: #selector(test), for: .touchUpInside)
        
        //현재위치 넣기
    }
    
    
    @objc func test() {
        transition(SearchViewController(), .push)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let currentLocation = locationManager.location else {
            locationManager.requestWhenInUseAuthorization()
            print("54365413213251212312121231321321321")
            return
        }
        
        mainView.mapView.showsUserLocation = true
        
        mainView.mapView.setUserTrackingMode(.follow, animated: true)

        addCustomPin()
        
        //지역지정하기
//        mainView.mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.latitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
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
            authorizationStatus = locationManager.authorizationStatus
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
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
            showSelectedAlert(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요\n설정창으로 이동하시겠습니까?") { _ in
                if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSetting)
                }
            }
     
        case .authorizedWhenInUse:
          
            locationManager.startUpdatingLocation()
        default: print("DEFAULT")
        }
    }
    
    // 지도에 핀 추가
    func setResionAndAnntation(center: CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mainView.mapView.setRegion(region, animated: true)
        
        //어노테이션 설정
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        mainView.mapView.addAnnotation(annotation)
    }
}

extension HomeViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        if let coordinate = locations.last?.coordinate {
            setResionAndAnntation(center: coordinate)
        }
    }
    
    //위치6. 사용자의 위치를 못 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDevieceLocationServiceAuthorization()
    }
}

extension HomeViewController {
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
}
