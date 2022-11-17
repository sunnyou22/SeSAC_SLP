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

enum Section: String {
    case quo = "자주찾는 스터티"
    case wish = "원하는 스터디"
}
//
struct SearchList: Codable, Hashable {
    let name: String
}

class SearchViewController: BaseViewController, UICollectionViewDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        <#code#>
    }
    
    
    var searchView = SearchView()
    
    var list = [SearchList]()
    
    override func loadView() {
        view = searchView
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var cellRegistration: UICollectionView.CellRegistration<SearchCollecitionViewCell, SearchList>!
    private var dataSource: UICollectionViewDiffableDataSource<Section, SearchList>!
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        searchView.collectionView.delegate = self
        setupSearchController()
        //        setupSearchController()
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //0 레이아웃
        searchView.collectionView.collectionViewLayout = configureCollectionViewLayout()
        //1 데이터소스
        configurationDataSource()
        
        //2 어플라이
//        configurationView()
    }

}
    
    
extension SearchViewController {
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        return UICollectionViewCompositionalLayout.init(sectionProvider: { sectionIndex, environment in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(128), heightDimension: .estimated(128))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.edgeSpacing = .init(leading: .fixed(8), top: .fixed(8), trailing: .fixed(8), bottom: .fixed(8))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(128))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }, configuration: configuration)
    }
    //레이아웃
//    private func configurationView() {
//        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment -> NSCollectionLayoutSection? in
//            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
//            configuration.headerMode = .firstItemInSection
//            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnviroment)
//            return section
//        }
//        searchView.collectionView.collectionViewLayout = layout
//    }

    private func setupSearchController() {
        searchController.searchBar.placeholder = "원하는 키워드를 입력해주세요"
        searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.searchController = searchController
        self.navigationItem.title = title
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        self.navigationController?.navigationBar.prefersLargeTitles = true
   
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .cyan
        navigationItem.scrollEdgeAppearance = barAppearance
    }


    //데이터소스
    private func configurationDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SearchCollecitionViewCell, SearchList>  { cell, indexPath, itemIdentifier in // 셀을 어떤 데이터에 기반해서 넣어줄꺼야?
            //세부내용 추가
            cell.lable.text = itemIdentifier.name
        }
        
        //셀을 반영
        dataSource = UICollectionViewDiffableDataSource(collectionView: searchView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
        
        func applySnapShot(text: String = "안") {
            //초기 옵셔널 오류 방지
            
            var snapshot = dataSource.snapshot()
            snapshot.appendSections([.quo])
            snapshot.appendItems(list, toSection: .quo)
//            snapshot.appendItems(Nitem.compactMap({ $0 }), toSection: .night)
            
//            print("🤯🤯🤯🤯🤯🤯🤯 🟢 Mitem : \(Mitem),  🟢 Nitem: \(Nitem), 🟢 morningFilteredArr: \(morningFilteredArr), 🟢 nightFilteredArr: \(nightFilteredArr)🚀🚀🚀🚀🚀")
            
            dataSource.apply(snapshot, animatingDifferences: true)
        }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text else { return
        }
        
        list.append(SearchList(name: text))
        dataSource.snapshot().deleteItems(<#T##identifiers: [SearchList]##[SearchList]#>)
        applySnapShot()

    }
}

//    var mainView = SearchView()
//
//    let searchController = UISearchController(searchResultsController: nil)
//    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
////    private var cellRegistration: UICollectionView.CellRegistration<SearchCollecitionViewCell, String>!
////    let recommand: [String]
////    let testStudyList: [String]
////    let wishStudy = [String]()
////
//    override func loadView() {
//        view = mainView
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        mainView.collectionView.collectionViewLayout = configureCollectionViewLayout()
////        configurationDataSource()
//
//        mainView.collectionView.delegate = self
//
//        mainView.backgroundColor = .setBaseColor(color: .white)
//        let width = view.frame.size.width //화면 너비
//        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 28, height: 0))
//        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
//    }
//}
//
//extension SearchViewController: UISearchBarDelegate {
//
//    func configureCollectionViewLayout() -> UICollectionViewLayout {
//        let configuration = UICollectionViewCompositionalLayoutConfiguration()
//
//        return UICollectionViewCompositionalLayout.init(sectionProvider: { sectionIndex, environment in
//
//            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(128), heightDimension: .estimated(128))
//            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//            item.edgeSpacing = .init(leading: .fixed(8), top: .fixed(8), trailing: .fixed(8), bottom: .fixed(8))
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(128))
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//            let section = NSCollectionLayoutSection(group: group)
//
//            return section
//        }, configuration: configuration)
//    }
//
//
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//
//        guard let text = searchBar.text else { return }
//
//        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
//        snapshot.appendSections([.wish])
//        snapshot.appendItems([text])
//        self.dataSource.apply(snapshot)
//    }
//
//    private func configurationDataSource() {
//        let cellRegistration = UICollectionView.CellRegistration<SearchCollecitionViewCell, String>  { cell, indexPath, itemIdentifier in // 셀을 어떤 데이터에 기반해서 넣어줄꺼야?
//            //세부내용 추가
//            cell.lable.text = itemIdentifier
//        }
//
//        //셀을 반영
//        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView) { collectionView, indexPath, itemIdentifier in
//            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
//            return cell
//        }
//
//    }
//
//}
