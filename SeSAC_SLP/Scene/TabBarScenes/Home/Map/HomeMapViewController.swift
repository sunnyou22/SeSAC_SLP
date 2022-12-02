//
//  HomeMapViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/18.
//

/*
 현재위치로 돌아와도 지금 새싹 위치를 기본을 맞춰놨음 구현하고 나서 지워주기
 */

import UIKit
import MapKit // 지도
import RxSwift
import RxCocoa
import RxMKMapView
import RxCoreLocation

enum UserMatchingStatus: Int {
    case waiting = 0
    case matched = 1
    case search
    
    var stringValue: String {
        switch self {
        case .waiting:
            return "waiting"
        case .matched:
            return "matched"
        case .search:
            return "search"
        }
    }
    
    var ploationgButtonImage: UIImage {
        switch self {
        case .waiting, .matched, .search:
            return UIImage(named: self.stringValue)!
        }
    }
}

class HomeMapViewController: BaseViewController {
    var userMatchingStatus: UserMatchingStatus?
    var mainView = CustomMapView()
    let commonAPIviewModel = CommonServerManager()
    let viewModel = MapViewModel()
    var disposedBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        //MARK: - viewDidLoad
        super.viewDidLoad()
        
        //코어로케이션 매니저 설정
        viewModel.manager.requestWhenInUseAuthorization()
        mainView.mapView.delegate = self
        mainView.mapView.showsUserLocation = false // 내 위치 지도에 표시
        mainView.mapView.setUserTrackingMode(.none, animated: true) // 내 위치를 기준으로 움직이기 위함
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK: - viewWillAppear        super.viewWillAppear(animated)
        // 바인드로 맵에 대한 데이터 갱신
        bindMapData()
        
        // 에러
        bindDataError()
        
        // 뷰그려주기
        bindMapViewData()
        
        // 현재위치를 기준으로 최초로 불러오기
        
        //        viewModel.fetchMapData(lat: (manager.location?.coordinate.latitude)!, long: (manager.location?.coordinate.longitude)!, idtoken: idtoken)
        commonAPIviewModel.fetchMapData(lat: MapViewModel.LandmarkLocation.sesacLocation.latitude, long: MapViewModel.LandmarkLocation.sesacLocation.longitude, idtoken: idToken)
        
        // 매칭상태가져오기 테스트
        commonAPIviewModel.getMatchStatus(idtoken: idToken)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 권한체크 - 화면이 뜰때마다
        viewModel.checkUserDevieceLocationServiceAuthorization()
        // 별도 위치 설정하지 않으면 현재 위치 추적하도록
        viewModel.manager.startUpdatingLocation()
        // ui는 willappear에서 그려주기
        bindUIData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //MARK: - viewDidDisappear
        super.viewDidDisappear(animated)
        viewModel.manager.stopUpdatingLocation()  // 화면이동시 계속 추적ㄴㄴ
        disposedBag = DisposeBag()
    }
    
    //MARK: Error
    func bindDataError() {
        
        //에러 메세지
        commonAPIviewModel.queueSearchStatus
            .withUnretained(self)
            .bind { vc, error in
                switch error {
                case .Success:
                    print("주변정보 불러오기 성공")
                case .FirebaseTokenError:
                    FirebaseManager.shared.getIDTokenForcingRefresh()
                    vc.showDefaultToast(message: .defaultQueueMessage(.FirebaseTokenError))
                case .ServerError:
                    vc.showDefaultToast(message: .defaultQueueMessage(.ServerError))
                case .ClientError:
                    vc.showDefaultToast(message: .defaultQueueMessage(.ClientError))
                case .NotsignUpUser:
                    vc.showDefaultToast(message: .defaultQueueMessage(.NotsignUpUser))
                }
            }.disposed(by: disposedBag)
    }
    
    //MARK: MapUI
    func bindUIData() {
        
        // 현재 위치버튼 클릭했을 때 이벤트
        mainView.currentLocationButton
            .rx
            .tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.mainView.mapView.showsUserLocation = true
                vc.mainView.mapView.setUserTrackingMode(.follow, animated: true)
            }.disposed(by: disposedBag)
        
        mainView.matchingButton
            .rx
            .tap
            .withUnretained(self)
            .bind { vc, _ in
                switch MapViewModel.ploatingButtonSet.value {
                case .search:
                    let viewcontrolller =  SearchViewController()
                    viewcontrolller.currentLocation = vc.viewModel.manager.location?.coordinate
                    vc.transition(viewcontrolller, .push)
                case .matched:
                    let viewcontrolller = ChatViewController()
                    vc.transition(viewcontrolller, .push)
                  
                case .waiting:
                    let viewcontrolller =  SearchViewController()
                    viewcontrolller.currentLocation = vc.viewModel.manager.location?.coordinate
                    vc.transition(viewcontrolller, .push)
                }
            }.disposed(by: disposedBag)
        
        //플로팅버튼 이미지 셋팅
        MapViewModel.ploatingButtonSet
            .withUnretained(self)
            .asDriver(onErrorJustReturn: (self, .search))
            .drive(onNext: { vc, status in
                switch status {
                case .search:
                    vc.mainView.matchingButton.setImage(UserMatchingStatus.search.ploationgButtonImage, for: .normal)
                case .matched:
                    vc.mainView.matchingButton.setImage(UserMatchingStatus.matched.ploationgButtonImage, for: .normal)
                case .waiting:
                    vc.mainView.matchingButton.setImage(UserMatchingStatus.waiting.ploationgButtonImage, for: .normal)
                }
            }).disposed(by: disposedBag)
    }
    
    //MARK: Mapdata
    func bindMapData() {
        /// Start Subscribing
        /// Works on simulator and device
        /// Subscribe to didUpdateLocations
        //MARK: 5초마다 통신부분
        //        Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.instance)  // 글로벌로처리해줘야하나 고민하기
        //            .withUnretained(self)
        //            .bind { vc, value in
        //                guard let idtoken = UserDefaults.idtoken else { return }
        //                print(value, "==========================================================")
        //                vc.viewModel.getMatchStatus(idtoken: idtoken)
        //            }.disposed(by: disposedBag) // 화면에서 나갈 때 디스포스 백
        //
        viewModel.manager.rx
            .didUpdateLocations
            .debug("didUpdateLocations")
            .subscribe(onNext: { [weak self] value in
                guard let annotations = self?.viewModel.addAnnotations() else { return }
                self?.mainView.mapView.addAnnotations(annotations)
            }).disposed(by: disposedBag)
        
        //에러를 불러왔을 때 꼭 value가 이게 아니어도 될것같은데
        viewModel.checkAuthorizationStatus
            .withUnretained(self)
            .bind { vc, auth in
                switch auth {
                case .restricted, .denied:
                    vc.showSelectedAlert(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요\n설정창으로 이동하시겠습니까?") { _ in
                        if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSetting)
                        }
                    }
                default:
                    print("DEFAULT IN", #file, #function)
                }
            }.disposed(by: disposedBag)
        
        viewModel.setdefaultLocation
            .withUnretained(self)
            .bind { vc, location in
                let region = MKCoordinateRegion(center: location, latitudinalMeters: 700, longitudinalMeters: 700)
                vc.mainView.mapView.setRegion(region, animated: true)
            }.disposed(by: disposedBag)
        
        // Subscribe to didChangeAuthorization
        viewModel.manager.rx
            .didChangeAuthorization
            .debug("didChangeAuthorization")
            .withUnretained(self)
            .subscribe(onNext: { vc, value in
                vc.viewModel.checkUserDevieceLocationServiceAuthorization()
            }).disposed(by: disposedBag)
        
        viewModel.manager.rx
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
        viewModel.manager.rx
            .location
            .debug("location")
            .subscribe(onNext: { value in
            }).disposed(by: disposedBag)
    }
    
    //MARK: rxmapview
    func bindMapViewData() {
        mainView.mapView.rx.willStartLoadingMap
            .withUnretained(self)
            .asDriver(onErrorJustReturn: (self,  print("Map started loading")))
            .drive(onNext: { vc, _ in
               vc.viewModel.checkUserDevieceLocationServiceAuthorization()
                vc.commonAPIviewModel.getMatchStatus(idtoken: vc.idToken)
            })
            .disposed(by: disposedBag)
        
        mainView.mapView.rx.didFinishLoadingMap
            .asDriver()
            .drive(onNext: {
                print("Map finished loading")
            })
            .disposed(by: disposedBag)
        
        //
        mainView.mapView.rx.regionDidChangeAnimated
            .subscribe(onNext: { [weak self] _ in
                print("Map region changed")
                
                self?.mainView.mapView.isUserInteractionEnabled = false
                guard let location = self?.viewModel.manager.location?.coordinate else { return }
                guard let idtoken = UserDefaults.idtoken else {
                    print("itocken만료")
                    return
                }
                //움직일 때 마다 주변 정보를 받아옴
                self?.commonAPIviewModel.fetchMapData(lat: location.latitude, long: location.longitude, idtoken: idtoken)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self?.mainView.mapView.isUserInteractionEnabled = true
                }
            }).disposed(by: disposedBag)
        
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

