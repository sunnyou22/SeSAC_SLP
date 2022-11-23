//
//  SearchViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/17.
//

/*
 1. 스크롤하면 키보드 내리기
 */

import UIKit

import SnapKit
import Toast
import RxSwift
import RxCocoa
import CoreLocation
import RxKeyboard
import RxGesture

// 화면에 어떤 뷰를 뭘 넣어줄거야
// 구독은 뷰와의 연결성을 주면서 뷰에 어떤 형태의 값을 그려줄지 동작하는 부분

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
        view.font = .title4_R14
        return view
    }()
}

enum AroundSection: Int, CaseIterable {
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
    
    //값전달
    var currentLocation: CLLocationCoordinate2D?
    var mainView = SearchView()
    // 서버보내는 시점에 기본값 anything 넣기
    var wishList: Set<String> = [] {
        didSet {
            mainView.secondCollectionView.reloadData()
            print(wishList)
        }
    }
    
    let commonAPIviewModel = CommonServerManager()
    let viewModel = SearchViewModel()
    let disposedBag = DisposeBag()
    let sesacCoordinate = CLLocationCoordinate2D(latitude: 37.51818789942772, longitude: 126.88541765534976)
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        //MARK: - viewDidLoad
        super.viewDidLoad()
        // 지금주변에는 컬렉션 뷰
        mainView.topCollectionView.dataSource = self
        mainView.topCollectionView.delegate = self
        mainView.topCollectionView.collectionViewLayout = mainView.topCollectionViewViewLayout()
        mainView.topCollectionView.register(SearchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchHeaderView")
        
        //내가 하고싶은 컬렉션뷰
        mainView.secondCollectionView.dataSource = self
        mainView.secondCollectionView.delegate = self
        mainView.secondCollectionView.collectionViewLayout = mainView.secondCollectionViewLayout()
        mainView.secondCollectionView.register(SearchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchHeaderView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK: - viewWillAppear
        super.viewWillAppear(animated)
        mainView.backgroundColor = .setBaseColor(color: .white)
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        //        searchBar.delegate = self
        
        //유아이 바인드
        bindDataUI()
        
        guard let idtoken = UserDefaults.idtoken else {
            print("itocken만료")
            return
        }
        
        // 앞에서 사용자의 현위치 값전달
        guard let currentLocation = currentLocation else {
            print("사용자의 위치를 받아올 수 없음 🔴", #function)
            return
        }
        
        //유저디폴츠 UserDefaults.searchData에 값을 넣어주고 있음 새싹위치로 테스트
        commonAPIviewModel.fetchMapData(lat: sesacCoordinate.latitude, long: sesacCoordinate.longitude, idtoken: idtoken)
        print("좌표값🤛", currentLocation.latitude, currentLocation.longitude, Array(wishList), "\n ", UserDefaults.searchData)
    }
    
    //MARK: - bindUI
    
    func bindDataUI() {
        
        let input = SearchViewModel.Input(tapSearchButton: mainView.searchButton.rx.tap, searchbarsearchButtonClicked: searchBar.rx.searchButtonClicked)
        let output = viewModel.transform(input: input)
        
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
        
        mainView.rx.tapGesture()
            .when(.recognized)
            .asDriver{ _ in .never() }
            .drive { [weak self] _ in
                self?.searchBar.resignFirstResponder()
            }.disposed(by: disposedBag)
        
        output.tapSearchButton
            .withUnretained(self)
            .bind { vc, _ in
                let viewcontroller = TabmanViewController()
                guard let currentLocation = vc.currentLocation else {
                    print("사용자의 위치를 받아올 수 없음 🔴", #function)
                    return
                }
                guard let idtoken = UserDefaults.idtoken else {
                    print("itocken만료 🔴")
                    return
                }
                // Test
                vc.viewModel.searchSeSACMate(lat: vc.sesacCoordinate.latitude, long: vc.sesacCoordinate.longitude, studylist: Array(vc.wishList), idtoken: idtoken)
                vc.transition(viewcontroller, .push)
            }.disposed(by: disposedBag)
        
        searchBar.rx
            .text
            .orEmpty
            .changed
            .map { str in
                return str.split(separator: " ").map { Array(arrayLiteral: String($0).trimmingCharacters(in: .whitespaces)) }.flatMap { addwishList in
                    return addwishList
                }
            }.bind { [weak self] addwishList in
                self?.viewModel.searchList.accept(addwishList)
                print(addwishList)
            }.disposed(by: disposedBag)
        
        output.searchbarsearchButtonClicked
            .asDriver()
            .drive { [weak self] _ in
                let searchlist = Set(self?.viewModel.searchList.value ?? [])
                self?.viewModel.InvalidWishList()
                self?.viewModel.searchList.accept(searchlist.sorted())
                self?.mainView.secondCollectionView.reloadData()
                self?.searchBar.text = ""
            }.disposed(by: disposedBag)
        
        viewModel.validWishList
            .withUnretained(self)
            .bind { vc, bool in
                if bool {
                    vc.mainView.makeToast("8개 이상은 입력하실 수 없습니다!", duration: 1, position: .center )
                }
            }.disposed(by: disposedBag)
        
    }
    //
    //    func showSearchToolBar() {
    //        searchBar.inputAccessoryView = mainView.searchButton
    //    }
}

//MARK: - Colleciton
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case mainView.topCollectionView:
            return AroundSection.allCases.count
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
                    header.label.text = AroundSection.allCases[indexPath.section].title
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
                    header.label.text = AroundSection.allCases[1].title
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
            return section == 0 ? viewModel.fromRecommend.count : viewModel.studyList.value.count
        case mainView.secondCollectionView:
            return viewModel.wishList.value.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case mainView.topCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopSearchCollecitionViewCell.reuseIdentifier, for: indexPath) as? TopSearchCollecitionViewCell else { return UICollectionViewCell() }
            if indexPath.section == 0 {
                cell.label.text = viewModel.fromRecommend[indexPath.item]
                cell.customView.layer.borderColor = UIColor.setStatus(color: .error).cgColor // 색 바꾸기
                return cell
            } else if indexPath.section == 1 {
                cell.label.text = viewModel.studyList.value[indexPath.item]
                cell.customView.layer.borderColor = UIColor.setBaseColor(color: .black).cgColor // 색 바꾸기
                return cell
            }
            
        case mainView.secondCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecondSearchCollecitionViewCell.reuseIdentifier, for: indexPath) as? SecondSearchCollecitionViewCell else { return UICollectionViewCell() }
            
            var sortedWishList: [String] = []
            sortedWishList += viewModel.wishList.value.sorted()
            cell.label.text = sortedWishList[indexPath.item]
            cell.customView.layer.borderColor = UIColor.setBrandColor(color: .green).cgColor
            return cell
        default:
            return UICollectionViewCell()
        }
        return UICollectionViewCell()
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        if indexPath.section == 0 {
    //            wishList.insert(dumy[indexPath.item])
    //        }
    //    }
}
