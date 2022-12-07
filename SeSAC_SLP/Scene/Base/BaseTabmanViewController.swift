//
//  BaseTabmanViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/05.
//

//적용할지 고민해보기

import UIKit

import Pageboy
import Tabman

class BaseTwoTabmanViewController: TabmanViewController {
    var left: UIViewController
    var right: UIViewController
    
    private var viewControllers = [UIViewController]()
    
    init(left: UIViewController, right: UIViewController) {
        self.left = left
        self.right = right
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers.append(left)
        viewControllers.append(right)
        
        self.dataSource = self
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension BaseTwoTabmanViewController: TMBarDataSource, PageboyViewControllerDataSource {
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
        let title: String = index == 0 ? StartMatcingViewController.Vctype.near.title : StartMatcingViewController.Vctype.requested.title
        item.title = title
        return item
    }
 
}
