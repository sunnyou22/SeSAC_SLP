//
//  MyPageListViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/16.
//

import UIKit
import SnapKit

struct List: Hashable {
    var title: String
}

enum MyPageListIcon: String, CaseIterable {
    case notice
    case faq
    case qna
    case setting_alarm
    case permit
}

final class MyPageListViewController: UICollectionViewController {

    var list = [
        List(title: "공지사항"),
        List(title: "자주 묻는 질문"),
        List(title: "1:1문의"),
        List(title: "알림 설정"),
        List(title: "이용약관")
        ]
    
    var cellResistration: UICollectionView.CellRegistration<UICollectionViewListCell, List>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            //MARK: 헤더 넣기
        collectionView.register(MyPageHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MyPageHeaderView")
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.headerMode = .firstItemInSection
        configuration.showsSeparators = true
        configuration.backgroundColor = .brown
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.collectionViewLayout = layout

        cellResistration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
           
            var content = UIListContentConfiguration.valueCell()
            
            content.image = UIImage(named: MyPageListIcon.allCases[indexPath.row].rawValue)
            content.text = itemIdentifier.title
            content.imageToTextPadding = 12
            content.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
            cell.contentConfiguration = content
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MyPageHeaderView", for: indexPath) as! MyPageHeaderView
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    //cellResistration 호출
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = list[indexPath.row]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellResistration, for: indexPath, item: item)
        
        return cell
    }
}



//extension MyPageListViewController {
//
//    //collectionViewLayout이 UICOllectionViewLayout이기때문에 타입 맞춰줌
//    private func createLayout() -> UICollectionViewLayout {
//        //14+ 컬렉션뷰를 테이블뷰 스타일처럼 사용 가능(List Configuration). 전반적인 설정 담당
//        //컬렉션뷰 스타일이랑 관련있고 셀이랑은 관련이 없음
//
//        return layout
//    }
//
//}

/*
 //
 //  MyPageListViewController.swift
 //  SeSAC_SLP
 //
 //  Created by 방선우 on 2022/11/16.
 //

 import UIKit
 import SnapKit

 //class CollectionView: BaseView {
 //    let collectionView: UICollectionView = {
 //        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
 //        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.reuseIdentifier)
 //        return view
 //    }()
 //
 //    override init(frame: CGRect) {
 //        super.init(frame: frame)
 //    }
 //
 //    required init?(coder: NSCoder) {
 //        fatalError("init(coder:) has not been implemented")
 //    }
 //
 //    override func configure() {
 //        self.addSubview(collectionView)
 //    }
 //
 //    override func setConstraints() {
 //        collectionView.snp.makeConstraints { make in
 //            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
 //            make.bottom.equalTo(self.snp.bottom).offset(-100)
 //        }
 //    }
 //}


 struct List: Hashable {
     var title: String
 }

 enum MyPageListIcon: String, CaseIterable {
     case notice
     case faq
     case qna
     case setting_alarm
     case permit
 }

 final class MyPageListViewController: UICollectionViewController {

 //    let mainview = CollectionView()
     
     override func loadView() {
 //        view = mainview
     }
     
     override init(collectionViewLayout layout: UICollectionViewLayout) {
         super.init(collectionViewLayout: layout)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     var list = [
         List(title: "공지사항"),
         List(title: "자주 묻는 질문"),
         List(title: "1:1문의"),
         List(title: "알림 설정"),
         List(title: "이용약관")
         ]
     
     var cellResistration: UICollectionView.CellRegistration<UICollectionViewListCell, List>!
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
 //        collectionView = mainview.collectionView
         
         collectionView.collectionViewLayout = createLayout()
         
         var config = UICollectionLayoutListConfiguration(appearance: .plain)
 //
 //        config.headerMode = .firstItemInSection
 //        config.showsSeparators = true
 //        config.backgroundColor = .brown
 //
 //
         cellResistration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
             var content = UIListContentConfiguration.valueCell()
             content.image = UIImage(named: MyPageListIcon.allCases[indexPath.row].rawValue)
             content.text = itemIdentifier.title
             content.imageToTextPadding = 12
             content.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
             cell.contentConfiguration = content
         })
         
     }
     
     override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return list.count
     }
     
     //cellResistration 호출
     override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let item = list[indexPath.row]
         let cell = collectionView.dequeueConfiguredReusableCell(using: cellResistration, for: indexPath, item: item)
         return cell
     }
 }



 extension MyPageListViewController {
     
     //collectionViewLayout이 UICOllectionViewLayout이기때문에 타입 맞춰줌
     private func createLayout() -> UICollectionViewLayout {
         //14+ 컬렉션뷰를 테이블뷰 스타일처럼 사용 가능(List Configuration). 전반적인 설정 담당
         //컬렉션뷰 스타일이랑 관련있고 셀이랑은 관련이 없음
         var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
         configuration.showsSeparators = false
         configuration.backgroundColor = .brown
         
         let layout = UICollectionViewCompositionalLayout.list(using: configuration)
         return layout
     }
     
 }

 */
