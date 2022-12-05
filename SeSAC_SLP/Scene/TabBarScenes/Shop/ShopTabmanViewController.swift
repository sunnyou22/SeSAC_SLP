//
//  ShopTabmanViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/05.
//

import UIKit

import Pageboy
import Tabman

//MARK: 탭맨
class ShopTabmanViewController: TabmanViewController {
    
    private var viewControllers = [UIViewController]()
    
    let sesacVC = ShopContainedViewController(type: .sesac)
    let backgruondVC = ShopContainedViewController(type: .backgruond)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers.append(sesacVC)
        viewControllers.append(backgruondVC)
        
        self.dataSource = self
        setBarConfig()
    }
}

extension ShopTabmanViewController: TMBarDataSource, PageboyViewControllerDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        let item = TMBarItem(title: "")
        let title: String = index == 0 ? ShopContainedViewController.Vctype.sesac.title : ShopContainedViewController.Vctype.backgruond .title
        item.title = title
        return item
    }
 
    func setBarConfig() {
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.indicator.weight = .custom(value: 1)
        bar.indicator.tintColor = .setBrandColor(color: .green)
        
        // tap center
        bar.layout.contentMode = .fit
        bar.layout.interButtonSpacing = 8
        bar.buttons.customize { button in
            button.tintColor = .setBaseColor(color: .black)
            button.selectedTintColor = .black
            button.selectedFont = UIFont.title3_M14
        }
        
        addBar(bar, dataSource: self, at: .top)
    }
}


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
        case .backgruond:
            mainview.backgroundColor = .lightGray
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SesacCollectionViewCell.reuseIdentifier, for: indexPath) as? SesacCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .brown
        return cell
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
