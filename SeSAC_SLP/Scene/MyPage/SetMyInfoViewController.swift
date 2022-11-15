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
    
    lazy var collectionView: UICollectionView = {
        let view = BaseCollectionView(frame: .zero, collectionViewLayout: .init())
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
        //        collectionView.delegate = self
        //        collectionView.dataSource = self
    }
    
    override func configure() {
//        collectionView.collectionViewLayout = collectionViewlayout()
//        view.addSubview(collectionView)
    }
    
    override func setContents() {
//        collectionView.snp.makeConstraints { make in
//            make.centerX.equalTo(view.snp.centerX)
//            make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
//        }
    }
    
    func collectionViewlayout() -> UICollectionViewFlowLayout { // 레이아웃을 따로 빼
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width, height: collectionView.frame.height)
        layout.minimumLineSpacing = 24
//        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return layout
    }
}

//
//extension SetMyInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 3
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackCollectionViewCell.reuseIdentifier, for: indexPath) as? BackCollectionViewCell else { return UICollectionViewCell() }
//
//        if indexPath.item == 0 {
//            cell.contentView.addSubview(tableView)
//            cell.label.isHidden = true
//            return cell
//        } else if indexPath.item == 1 {
//            cell.contentView.addSubview(stackView)
//            cell.label.isHidden = true
//            return cell
//        } else {
//            return cell
//        }
//    }
//}

extension SetMyInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return tableView.rowHeight
       }
    
    func numberOfSections(in tableView: UITableView) -> Int {
          return tableViewData.count
      }
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          if tableViewData[section].opened == true {
              // tableView Section이 열려있으면 Section Cell 하나에 sectionData 개수만큼 추가해줘야 함
              print(tableViewData[section].setionData.count)
              return tableViewData[section].setionData.count + 1
          } else {
              // tableView Section이 닫혀있을 경우에는 Section Cell 하나만 보여주면 됨
              return 1
          }
      }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandableTableViewCell.reuseIdentifier, for: indexPath) as? ExpandableTableViewCell else { return UITableViewCell() }
            cell.lable.text = tableViewData[indexPath.section].title
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandableTableViewCell.reuseIdentifier, for: indexPath) as? ExpandableTableViewCell else { return UITableViewCell() }
            cell.lable.text = tableViewData[indexPath.section].setionData[indexPath.row - 1]
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandableTextTableViewCell.reuseIdentifier, for: indexPath) as? ExpandableTextTableViewCell else { return UITableViewCell() }
            cell.lable.text = tableViewData[indexPath.section].setionData[indexPath.row - 1]
            return cell
        }
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


