//
//  StartMatcingViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/26.
//

import UIKit

class StartMatcingViewController: BaseViewController {
    
    var type: Vctype
    let mainView = StartMatchingView()
    
    let viewModel: StartMatchingViewModel
    let commonAPIviewModel = CommonServerManager()
    
    // 탭맨에서 초기화됨
    init(type: Vctype, viewModel: StartMatchingViewModel) {
        self.type = type
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch type {
        case .near:
            view.backgroundColor = .lightGray
        case .request:
            view.backgroundColor = .darkGray
        }
        
       
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.collectionViewLayout = collectionViewLayout()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

extension StartMatcingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        viewModel.data.value.count
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StartMatchingCollectionViewCell.reuseIdentifier, for: indexPath) as? StartMatchingCollectionViewCell else { return UICollectionViewCell()}
        var name = cell.cardView.nicknameView.nameLabel.text
        var titletitleStackView = cell.cardView.expandableView.titleStackView
        var wishStudy = cell.cardView.expandableView.whishStudyView
        var review =  cell.cardView.expandableView.reviewLabel.text
        
        return BaseCollectionViewCell()
    }
    
//    // 공통으로 쓰이는 섹션 레이아웃
//    func configureCollectionViewLayout() -> UICollectionViewLayout {
//        let configuration = UICollectionViewCompositionalLayoutConfiguration()
//
//        return UICollectionViewCompositionalLayout.init(sectionProvider: { sectionIndex, environment in
//
//            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
//            //아이템
//            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//            item.edgeSpacing = .init(leading: .none, top: .fixed(8), trailing: .none, bottom: .fixed(8))
//
//            // 그룹
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(32))
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//            group.interItemSpacing = .fixed(8)
//
//            // 섹션
//            let section = NSCollectionLayoutSection(group: group)
////            section.interGroupSpacing = 12
////            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 76, trailing: 16)
//            configuration.scrollDirection = .vertical
//            return section
//        }, configuration: configuration)
//    }
//
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 20
        let width = UIScreen.main.bounds.width - (spacing * 2)
        layout.itemSize = CGSize(width: width, height: width * 1.2)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        //        layout.minimumInteritemSpacing = spacing * 2 // 행에 많이 있을 때
        layout.minimumLineSpacing = spacing * 2
        return layout
    }
}

extension StartMatcingViewController {
    //MARK: - 뷰컨 타입
    enum Vctype {
        case near
        case request
        
        var title: String {
            switch self {
            case .near:
                return "주변 새싹"
            case .request:
                return "받은 요청"
            }
        }
    }
}
