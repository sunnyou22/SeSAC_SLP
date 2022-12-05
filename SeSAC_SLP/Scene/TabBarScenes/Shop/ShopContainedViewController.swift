//
//  ShopContainedViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/06.
//

import UIKit


//MARK: 포함되는 뷰컨
class ShopContainedViewController: BaseViewController, Bindable {

    var mainview = ShopContainerView()
    
    var type: Vctype
    
    init(type: Vctype) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainview.collectionView.delegate = self
        mainview.collectionView.dataSource = self
       
        
        switch type {
            
        case .sesac:
            mainview.backgroundColor = .brown
            mainview.collectionView.collectionViewLayout = mainview.configureSesacCollectionViewLayout()
        case .backgruond:
            mainview.backgroundColor = .lightGray
            mainview.collectionView.collectionViewLayout = mainview.configureBackCollectionViewLayout()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    func bind() {

    }
}

extension ShopContainedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch type {
        case .sesac:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SesacCollectionViewCell.reuseIdentifier, for: indexPath) as? SesacCollectionViewCell else { return UICollectionViewCell() }
 
            return cell
        case .backgruond:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackgroundCollectionViewCell.reuseIdentifier, for: indexPath) as? BackgroundCollectionViewCell else { return UICollectionViewCell() }

            return cell
        }
    }
}


extension ShopContainedViewController {
    //뷰컨 타입
    enum Vctype: Int, CaseIterable {
         case sesac
         case backgruond
        
        var title: String {
            switch self {
            case .sesac:
                return "새싹"
            case .backgruond:
                return "배경"
            }
        }
     }
}

