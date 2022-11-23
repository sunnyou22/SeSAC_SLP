//
//  SearchViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/17.
//

/*
 1. 네비게이션바에 서치바 커스텀 넣기
 2. 네이바히든하고,,,? 서치바랑 버튼 넣기....되나...?
 3. 네비바그룹을 넣을 수 없나 Fixspacing
 */

import UIKit

import SnapKit
import Toast
import RxSwift
import RxCocoa
import CoreLocation
import RxKeyboard
import RxGesture


//MARK: - 헤더
class SearchHeaderView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(self)
            make.verticalEdges.equalTo(self)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let label: UILabel = {
        let view = UILabel()
        view.text = "test"
        view.font = .title4_R14
        return view
    }()
}

enum Section: Int, CaseIterable {
    case quo
    case wish
    
    var title: String {
        switch self {
        case .quo:
            return "지금 주변에는"
        case .wish:
            return "내가 하고싶은"
        }
    }
}

//MARK: - 서치 뷰컨
class SearchViewController: BaseViewController {
    
    lazy var width = view.frame.size.width //화면 너비
    lazy var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 28, height: 0))
    
    var fromQueueDB = UserDefaults.searchData?[0].fromQueueDB ?? []
    var fromRecommend = UserDefaults.searchData?[0].fromRecommend ?? []
    
    var currentLocation: CLLocationCoordinate2D?
//    var cell =  SearchCollecitionViewCell()
    var mainView = SearchView()
    var wishList: Set<String> = [] {
        didSet {
            mainView.secondCollectionView.reloadData()
            print(wishList)
        }
    }
    
    
    let dumy = ["a", "bbbbb", "cccccccccc", "dddd", "a", "bbbbb", "cccccccccc", "dddd", "a", "bbbbb", "cccccccccc", "dddd", "a", "bbbbb", "cccccccccc", "dddd", "a", "bbbbb", "cccccccccc", "dddd", "a", "bbbbb", "cccccccccc", "dddd", "a", "bbbbb", "cccccccccc", "dddd", "a", "bbbbb", "cccccccccc", "dddd"]
    
  
    
    let commonAPIviewModel = CommonServerManager()
    
    let viewModel = SearchViewModel()
    
    let disposedBag = DisposeBag()
    
    let sesacCoordinate = CLLocationCoordinate2D(latitude: 37.51818789942772, longitude: 126.88541765534976)
    
    override func loadView() {
        view = mainView
    }
    
    deinit {
        //화면에 들어올때마다 넣어주고있기 때문에 없...앨까>? 다음화면에서 어떻게 쓰일 수 있을지 생각
        UserDefaults.standard.removeObject(forKey: "searchData")
    }
    
    override func viewDidLoad() {
        //MARK: - viewDidLoad
        super.viewDidLoad()
        mainView.topCollectionView.dataSource = self
        mainView.topCollectionView.delegate = self
        mainView.topCollectionView.collectionViewLayout = mainView.configureCollectionViewLayout()
        mainView.topCollectionView.register(SearchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchHeaderView")
    
        mainView.secondCollectionView.dataSource = self
        mainView.secondCollectionView.delegate = self
        mainView.secondCollectionView.collectionViewLayout = mainView.configureCollectionViewLayout2()
        mainView.secondCollectionView.register(SearchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchHeaderView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK: - viewWillAppear
        super.viewWillAppear(animated)
        mainView.backgroundColor = .setBaseColor(color: .white)
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        searchBar.delegate = self
        
        //유아이 바인드
        bindDataUI()
        
        // 토큰갈아끼우기
        guard let idtoken = UserDefaults.idtoken else {
            print("itocken만료")
            return
        }
        
        //앞에서 사용자의 현위치 값전달
//        guard let currentLocation = currentLocation else {
//            print("사용자의 위치를 받아올 수 없음 🔴", #function)
//            return
//        }
        
        //유저디폴츠 UserDefaults.searchData에 값을 넣어주고 있음
        commonAPIviewModel.fetchMapData(lat: sesacCoordinate.latitude, long: sesacCoordinate.longitude, idtoken: idtoken)
//        print("좌표값🤛", currentLocation.latitude, currentLocation.longitude,  Array(wishList), "\n ", UserDefaults.searchData)
    }
    
    //MARK: - bindUI
    
    func bindDataUI() {
        //키보드 높이 받아오기
        RxKeyboard.instance.willShowVisibleHeight
            .drive(onNext: { [weak self] height in
                guard let self = self else { return }
                let height = height > 0 ? -height + (self.mainView.safeAreaInsets.bottom) : 0
                self.mainView.searchButton.snp.updateConstraints { make in
                    make.bottom.equalTo(self.mainView.safeAreaLayoutGuide).offset(height)
                    make.horizontalEdges.equalTo(self.mainView).inset(0)
                }
                
                self.mainView.layoutIfNeeded()
            }).disposed(by: disposedBag)
        
        //키보드 숨기기
        RxKeyboard.instance.isHidden
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] bool in
                if bool {
                    guard let self = self else { return }
                       self.mainView.searchButton.snp.updateConstraints { make in
                           make.horizontalEdges.equalTo(self.mainView).inset(16)
                           make.bottom.equalTo(self.mainView.safeAreaLayoutGuide).offset(-16)
                           make.height.equalTo(48)
                       }
                       
                       self.mainView.layoutIfNeeded()
                   }
            }).disposed(by: disposedBag)
            
        
        //되는지 실험해봐야함
        searchBar.rx.textDidEndEditing
            .bind { [weak self] _ in
                self?.mainView.endEditing(true)
            }.disposed(by: disposedBag)
        
        mainView.searchButton.rx
            .tap
            .withUnretained(self)
            .bind { vc, _ in
          //다음화면 이동 코드 필요
//                guard let currentLocation = vc.currentLocation else {
//                    print("사용자의 위치를 받아올 수 없음 🔴", #function)
//                    return
//                }
//
                guard let idtoken = UserDefaults.idtoken else {
                    print("itocken만료 🔴")
                    return
                }
//                print("좌표값🤛", currentLocation.latitude, currentLocation.longitude,  Array(vc.wishList))
                
                print(vc.sesacCoordinate.latitude, vc.sesacCoordinate.longitude, Array(vc.wishList), "############")
                
                vc.viewModel.searchSeSACMate(lat: vc.sesacCoordinate.latitude, long: vc.sesacCoordinate.longitude, studylist: Array(vc.wishList), idtoken: idtoken)
            }.disposed(by: disposedBag)
      
        mainView.rx.tapGesture()
            .when(.recognized)
            .asDriver{ _ in .never() }
            .drive { [weak self] _ in
                self?.searchBar.resignFirstResponder()
            }.disposed(by: disposedBag)
    }
    
    func showSearchToolBar() {
        searchBar.inputAccessoryView = mainView.searchButton
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        
        guard wishList.count != 8 else {
            view.makeToast("8개를 초과하여 등록하실 수 없습니다!", duration: 1, position: .center)
            return
        }
        let studyList = text.split(separator: " ").map { Array(String($0).trimmingCharacters(in: .whitespaces)) }
        studyList.forEach { strEl in
            wishList.insert(String(strEl))
            searchBar.text = ""
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showSearchToolBar()
//        guard let currentLocation = currentLocation else {
//            print("사용자의 위치를 받아올 수 없음 🔴", #function)
//            return
//        }
//        print("좌표값🤛", currentLocation.latitude, currentLocation.longitude,  Array(wishList))
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case mainView.topCollectionView:
            return Section.allCases.count
        case mainView.secondCollectionView:
            return 1
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == mainView.topCollectionView {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                if indexPath.section == 0 {
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchHeaderView", for: indexPath) as! SearchHeaderView
                    header.label.text = Section.allCases[indexPath.section].title
                    return header
                } else {
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchHeaderView", for: indexPath) as! SearchHeaderView
                    header.label.text = Section.allCases[indexPath.section].title
                    return header
                }
            default:
                return UICollectionReusableView()
            }
        } else if collectionView == mainView.secondCollectionView {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                if indexPath.section == 0 {
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchHeaderView", for: indexPath) as! SearchHeaderView
                    header.label.text = Section.allCases[indexPath.section].title
                    return header
                }
            default:
                return UICollectionReusableView()
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        switch collectionView {
        case mainView.topCollectionView:
            return section == 0 ? dumy.count : wishList.count
        case mainView.secondCollectionView:
            return wishList.count
        default:
            return 0
        }
//        fromRecommend.count + fromQueueDB.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let searchData = UserDefaults.searchData else {
            print("searchData없음🔴")
            return  UICollectionViewCell() }
        
        switch collectionView {
        case mainView.topCollectionView:
            if indexPath.section == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopSearchCollecitionViewCell.reuseIdentifier, for: indexPath) as? TopSearchCollecitionViewCell else { return UICollectionViewCell() }
                // 강제해제 연산자 하면 안됨 주변에 없을 수도 있기 때a뭄ㄴ

                //fromRecommend.count
                if indexPath.row <= 1 {
                    cell.label.text = dumy[indexPath.item]
//                    cell.xbutton.isHidden = true
                    cell.customView.layer.borderColor = UIColor.setStatus(color: .success).cgColor // 색 바꾸기
                    // fromRecommend.count, indexPath.row <= fromQueueDB.count
                } else if indexPath.row >  1 {
                    cell.label.text = dumy[indexPath.item]
//                    cell.xbutton.isHidden = true
                    cell.customView.layer.borderColor = UIColor.setBaseColor(color: .black).cgColor // 색 바꾸기
                }
                return cell
            } else if indexPath.section == 1 {
                guard let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: TopSearchCollecitionViewCell.reuseIdentifier, for: indexPath) as? TopSearchCollecitionViewCell else { return UICollectionViewCell() }
              
                    let sortedWishList = wishList.sorted()
                    cell2.label.text = sortedWishList[indexPath.item]
//                    cell2.xbutton.isHidden = false
                cell2.customView.layer.borderColor = UIColor.setBrandColor(color: .green).cgColor
                    return cell2
                
            }
        case mainView.secondCollectionView:
            guard let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: SecondSearchCollecitionViewCell.reuseIdentifier, for: indexPath) as? SecondSearchCollecitionViewCell else { return UICollectionViewCell() }
          
                let sortedWishList = wishList.sorted()
                cell3.label.text = sortedWishList[indexPath.item]
//                    cell2.xbutton.isHidden = false
            cell3.customView.layer.borderColor = UIColor.setBrandColor(color: .green).cgColor
                return cell3
        default:
            return UICollectionViewCell()
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            wishList.insert(dumy[indexPath.item])
        }
    }
    
//    //셀 재사용..?
//    func setCell(collectionView: UICollectionView, indexPath: IndexPath) -> SearchCollecitionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollecitionViewCell.reuseIdentifier, for: indexPath) as? SearchCollecitionViewCell else { return SearchCollecitionViewCell() }
//
//        return cell
//    }
}
 
