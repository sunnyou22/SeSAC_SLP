//
//  SetMyInfoViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/15.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class SetMyInfoViewController: BaseViewController {
    
//    let viewmodel = TableViewViewModel()
    let disposedBag = DisposeBag()
    
    let fixStackView = FixedView()
    
    let headerView = Header()
    
    var expandableTableView = ExpandableStackView().setStackViewLayout(axis: .vertical, color: .brown)
    
    let bodyStackView: UIStackView = {
        let view = UIStackView()
       return view.setStackViewLayout(axis: .vertical, color: .brown)
    }()
    
    var isExpanded = false
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .setBaseColor(color: .white)
        view.isPagingEnabled = false
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    override func configure() {
        [headerView, expandableTableView, fixStackView].forEach { bodyStackView.addArrangedSubview($0) }
        
        scrollView.addSubview(bodyStackView)
        view.addSubview(scrollView)
    }
    
    override func setContents() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
