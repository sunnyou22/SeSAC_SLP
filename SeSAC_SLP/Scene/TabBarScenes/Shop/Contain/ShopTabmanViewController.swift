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
    
    let sesacVC = ShopContainedViewController(vctype: .sesac)
    let backgruondVC = ShopContainedViewController(vctype: .backgruond)
    
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
