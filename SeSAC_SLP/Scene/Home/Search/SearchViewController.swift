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

class SearchViewController: BaseViewController {
    
    var mainView = SearchView()
    var wishList: Set<String> = [] {
        didSet {
            mainView.collectionView.reloadData()
            print(wishList)
        }
    }
    let dumy = ["a", "bbbbb", "cccccccccc", "dddd"]
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.collectionViewLayout = mainView.configureCollectionViewLayout()
        mainView.collectionView.register(SearchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchHeaderView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.backgroundColor = .setBaseColor(color: .white)
        let width = view.frame.size.width //화면 너비
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 28, height: 0))
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        
        searchBar.delegate = self
    }
}

extension SearchViewController: UISearchBarDelegate {
  
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        
        let studyList = searchBar.text?.split(separator: " ").map { Array(String($0).trimmingCharacters(in: .whitespaces)) }
        guard let studyList = studyList else { return }
        
        let a = studyList.flatMap {$0}
        
        studyList.forEach { strEl in
            wishList.insert(String(strEl))
        }
    }
    
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
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
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  
        return section == 0 ? dumy.count : wishList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollecitionViewCell.reuseIdentifier, for: indexPath) as? SearchCollecitionViewCell else { return UICollectionViewCell() }
        if indexPath.section == 0 {
            cell.label.text = dumy[indexPath.item]
//            cell.border
            return cell
        } else {
             let sortedWishList = wishList.sorted()
            cell.label.text = sortedWishList[indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}
 
