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
 
    
    let viewmodel = TableViewViewModel()
    let disposedBag = DisposeBag()
    
    //컬렉션뷰 선언
    var backcollectionView: UICollectionView = {
        let view = BaseCollectionView(frame: .zero, collectionViewLayout: .init())
        view.register(BackCollectionViewCell.self, forCellWithReuseIdentifier: BackCollectionViewCell.reuseIdentifier)
        view.backgroundColor = .cyan
        return view
    }()

    
    let stackView = FixedView()
    
    var tableViewData = [CellData()] // 리스트 선언
    
    var expandableTableView = ExpandableTableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(expandableTableView)
        expandableTableView.tableHeaderView = expandableTableView.header
        expandableTableView.tableHeaderView?.frame.size.height = 204
        //        expandableTableView.rowHeight =
        
        expandableTableView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        tableViewData = [
            CellData(opened: false, title: "이름입니다.", setionData: ["새싹 타이틀", "새싹리뷰"])
        ]
        expandableTableView.delegate = self
        expandableTableView.dataSource = self
      
        
        backcollectionView.collectionViewLayout = collectionViewLayout()
        view.addSubview(backcollectionView)
        backcollectionView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        backcollectionView.delegate = self
        backcollectionView.dataSource = self
        
        
        expandableTableView.rowHeight = UITableView.automaticDimension
        expandableTableView.estimatedRowHeight = 130

    }
    
    override func configure() {
      
    }
    
    override func setContents() {
     
    }
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let width = UIScreen.main.bounds.width - (spacing * 2)
        layout.itemSize = CGSize(width: width, height: width * 1.2)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        //        layout.minimumInteritemSpacing = spacing * 2 // 행에 많이 있을 때
        layout.minimumLineSpacing = spacing * 2
        return layout
    }
}


extension SetMyInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackCollectionViewCell.reuseIdentifier, for: indexPath) as? BackCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.item == 0 {
            cell.contentView.addSubview(expandableTableView)
            expandableTableView.snp.makeConstraints { make in
                make.edges.equalTo(cell.contentView.snp.edges)
            }
            cell.label.text = "text"
            return cell
        } else if indexPath.item == 1 {
            cell.contentView.addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.edges.equalTo(cell.contentView.snp.edges)
            }
            
            cell.label.text = "text"
            return cell
        } else {
            return cell
        }
    }
}

    
    extension SetMyInfoViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return tableView.rowHeight
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            
            return tableViewData.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tableViewData[section].opened == true {
                print(tableViewData[section].setionData.count)
                return tableViewData[section].setionData.count + 1
            } else {
                return 1
            }
        }
        
        
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

    return UITableView.automaticDimension

    }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandableTableViewCell.reuseIdentifier, for: indexPath) as? ExpandableTableViewCell else { return UITableViewCell() }
                cell.lable.text = tableViewData[indexPath.section].title
                cell.horizontalStackView.isHidden = true
                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandableTableViewCell.reuseIdentifier, for: indexPath) as? ExpandableTableViewCell else { return UITableViewCell() }
                cell.lable.text = tableViewData[indexPath.section].setionData[indexPath.row - 1]
                return cell
            } else if indexPath.row == 2 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandableTextTableViewCell.reuseIdentifier, for: indexPath) as? ExpandableTextTableViewCell else { return UITableViewCell() }
                cell.lable.text = tableViewData[indexPath.section].setionData[indexPath.row - 1]
                return cell
            }
            return UITableViewCell()
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.row == 0 {
                tableViewData[indexPath.section].opened = !tableViewData[indexPath.section].opened
                tableView.reloadSections([indexPath.section], with: .none)
            }
            //        tableView.reloadSections([indexPath.section], with: .none) => 여기서 Indexpath.row fade로 셀 숨기기
            
            print("📍\([indexPath.section]), 📍\([indexPath.row])")
        }
    }

//extension SetMyInfoViewController: UITextViewDelegate {
//    
//    func textViewDidChange(_ textView: UITextView) {
//    
//    
//      override func willTransition(
//        to newCollection: UITraitCollection,
//        with coordinator: UIViewControllerTransitionCoordinator
//        ) {
//        super.willTransition(to: newCollection, with: coordinator)
//
//        // 현재 방향
//            let bottom = expandableTableView.snp.bottom
//        
//        // 방향에 따른 label 높이 값 조정
//            expandableTableView.snp.updateConstraints { make in
//                make.bottom.equalTo(bottom ? textView.snp.bottom)
//        }
//        
//        // 방향에 따른 font 크기 값 조정
//        lblTimer.font = UIFont.systemFont(ofSize: isPortrait ? 20 : 32, weight: .light)
//      }
//    }
//}
//}
