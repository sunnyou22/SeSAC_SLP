//
//  SearchViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/17.
//

/*
 1. 스크롤하면 키보드 내리기
 2. 셀삭제하기
 3. 셀 클릭하면 데이터 넣어줘야함
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

//MARK: - 서치 뷰컨

final class SearchViewController: BaseViewController {
    
    //값전달
    var currentLocation: CLLocationCoordinate2D?
    var mainView = SearchView()
    
    let commonAPIviewModel = CommonServerManager()
    let viewModel = SearchViewModel()
    let disposedBag = DisposeBag()
    let sesacCoordinate = CLLocationCoordinate2D(latitude: 37.51818789942772, longitude: 126.88541765534976)
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //유저디폴츠 UserDefaults.searchData에 값을 넣어주고 있음 새싹위치로 테스트
        commonAPIviewModel.fetchMapData(lat: sesacCoordinate.latitude, long: sesacCoordinate.longitude, idtoken: idToken)
        
                bindDataUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        // 앞에서 사용자의 현위치 값전달
        //        guard let currentLocation = currentLocation else {
        //            print("사용자의 위치를 받아올 수 없음 🔴", #function)
        //            return
        //        }
        //        print("좌표값🤛", currentLocation.latitude, currentLocation.longitude, Array(wishList), "\n ", UserDefaults.searchData)
    }
    
    override func configure() {
        super.configure()
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mainView.searchBar)
        
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.collectionViewLayout = mainView.configureCollectionViewLayout()
        mainView.collectionView.register(SearchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchHeaderView.reuseIdentifier)
    }
    
    //MARK: - bindUI
    
    func bindDataUI() {
        
        let input = SearchViewModel.Input(tapSearchButton: mainView.searchButton.rx.tap, searchbarsearchButtonClicked: mainView.searchBar.rx.searchButtonClicked)
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
        //
        mainView.rx.gesture(.swipe(direction: .down))
            .when(.recognized)
            .asDriver{ _ in .never() }
            .drive { [weak self] _ in
                self?.mainView.searchBar.resignFirstResponder()
            }.disposed(by: disposedBag)
        
        output.tapSearchButton
            .withUnretained(self)
            .asDriver(onErrorJustReturn: (self, print("서치바검색")))
            .drive { vc, _ in
                let viewcontroller = CustomTabmanViewController()
                guard let currentLocation = vc.currentLocation else {
                    print("사용자의 위치를 받아올 수 없음 🔴", #function)
                    return
                }
             
                // 캠퍼스 위치로 Test
                vc.viewModel.searchSeSACMate(lat: vc.sesacCoordinate.latitude, long: vc.sesacCoordinate.longitude, studylist: vc.viewModel.wishList.value.sorted(), idtoken: vc.idToken)
                
                vc.transition(viewcontroller, .push)
                viewcontroller.nearVC.viewModel.wishList = vc.viewModel.wishList.value
            }.disposed(by: disposedBag)
        
        mainView.searchBar.rx
            .text
            .orEmpty
            .changed
            .map { str in
                return str.split(separator: " ").map { Array(arrayLiteral: String($0).trimmingCharacters(in: .whitespaces)) }.flatMap { addwishList in
                    return addwishList
                }
            }.bind { [weak self] addwishList in
                self?.viewModel.searchList.accept(addwishList)
            }.disposed(by: disposedBag)
        
        //        output.searchList
        //            .withUnretained(self)
        //            .bind { vc, list in
        //               vc.viewModel.InvalidWishList()
        //            }
        //
        output.searchbarsearchButtonClicked
            .asDriver()
            .drive { [weak self] _ in
                let searchlist = Set(self?.viewModel.searchList.value ?? [])
                
                self?.viewModel.searchList.accept(searchlist.sorted())
                self?.mainView.collectionView.reloadData() // 뷰모델로 리로드 다 빼기
                self?.mainView.searchBar.text = ""
            }.disposed(by: disposedBag)
        
        viewModel.validWishList
            .withUnretained(self)
            .bind { vc, bool in
                if bool {
                    vc.mainView.makeToast("8개 이상은 입력하실 수 없습니다!", duration: 1, position: .center )
                }
            }.disposed(by: disposedBag)
    }
}

//MARK: - Colleciton
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SearchHeaderView.Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if indexPath.section == 0 {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchHeaderView.reuseIdentifier, for: indexPath) as! SearchHeaderView
                header.label.text = SearchHeaderView.Section.allCases[indexPath.section].title
                return header
                
            } else {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchHeaderView.reuseIdentifier, for: indexPath) as! SearchHeaderView
                header.label.text = SearchHeaderView.Section.allCases[indexPath.section].title
                return header
            }
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.countAroundStudylist()
        return section == 0 ? viewModel.fromRecommend.count + viewModel.studyList.value.count : viewModel.wishList.value.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollecitionViewCell.reuseIdentifier, for: indexPath) as? SearchCollecitionViewCell else { return UICollectionViewCell() }
        
        if indexPath.section == 0 {
            let quoList = viewModel.fromRecommend + viewModel.studyList.value
            //fromRecommend.count
            if indexPath.item <= viewModel.fromRecommend.count {
                guard let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollecitionViewCell.reuseIdentifier, for: indexPath) as? SearchCollecitionViewCell else { return UICollectionViewCell() }
                
                cell1.label.text = quoList[indexPath.item]
                cell1.xbutton.isHidden = true
                cell1.customView.layer.borderColor = UIColor.setStatus(color: .success).cgColor // 색 바꾸기
                // fromRecommend.count, indexPath.row <= fromQueueDB.count
                return cell1
            } else if indexPath.item > viewModel.studyList.value.count {
                guard let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollecitionViewCell.reuseIdentifier, for: indexPath) as? SearchCollecitionViewCell else { return UICollectionViewCell() }
                
                cell3.label.text = quoList[indexPath.item]
                cell3.xbutton.isHidden = true
                cell3.customView.layer.borderColor = UIColor.setBaseColor(color: .black).cgColor // 색 바꾸기
                return cell3
            }
            return cell
            
        } else if indexPath.section == 1 {
            guard let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollecitionViewCell.reuseIdentifier, for: indexPath) as? SearchCollecitionViewCell else { return UICollectionViewCell() }
            
            var sortedWishList: [String] = []
            sortedWishList += viewModel.wishList.value.sorted()
            cell2.label.text = sortedWishList[indexPath.item]
            cell2.xbutton.isHidden = false
            cell2.customView.layer.borderColor = UIColor.setBrandColor(color: .green).cgColor
            return cell2
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            print("들어왔따4", indexPath.row)
            viewModel.setWishList(addWishList: [viewModel.fromRecommend[indexPath.item]])
            
        case 1:
            print("들어왔따5", indexPath.row)
            //안됨
            collectionView.deselectItem(at: indexPath, animated: true)
            var test = viewModel.wishList.value
            test.removeAll { str in
                str == viewModel.wishList.value[indexPath.item]
            }
            collectionView.reloadData()
        default:
            print("들어왔따6", indexPath.row)
            break
        }
    }
    
}

