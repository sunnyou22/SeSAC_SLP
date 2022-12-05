//
//  ShopViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/24.
//

import UIKit

//컬렉션뷰로도 구현해보기

class ShopViewController: BaseViewController {
    
    var mainView = ShopView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContainerViewController()
        
    }

    func setContainerViewController() {
      
        let vc = ShopTabmanViewController()
        vc.willMove(toParent: self)
        mainView.tabmanView.addSubview(vc.view)
        vc.view.snp.makeConstraints { make in
            make.top.equalTo(mainView.tabmanView.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.addChild(vc)
        vc.didMove(toParent: self)
    }
}

