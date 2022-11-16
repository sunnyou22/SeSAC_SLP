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

class SearchViewController: BaseViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .setBaseColor(color: .white)
        let width = view.frame.size.width //화면 너비
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 28, height: 0))
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
}
