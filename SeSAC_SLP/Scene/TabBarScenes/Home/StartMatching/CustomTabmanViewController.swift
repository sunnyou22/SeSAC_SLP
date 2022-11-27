//
//  CustomTabmanViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/20.
//

import UIKit

import Pageboy
import Tabman
import RxSwift
import RxCocoa

final class CustomTabmanViewController: TabmanViewController {
    
    let nearVC = StartMatcingViewController(type: .near, viewModel: .init(type: .near))
    let requestVC = StartMatcingViewController(type: .request, viewModel: .init(type: .request))
    let bag = DisposeBag()
    
    private var viewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers.append(nearVC)
        viewControllers.append(requestVC)
        
        self.dataSource = self
        
        setBarConfig()
        
        
        
        let rightBarButton = UIBarButtonItem(title: "찾기", style: .plain, target: self, action: nil)
        
       self.navigationItem.rightBarButtonItem = rightBarButton
        
        guard let test = self.navigationItem.rightBarButtonItem else { return }
        
        test.rx
            .tap
            .bind { _ in
                print("눌리나여")
            }.disposed(by: bag)
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
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        // 플로팅 버튼 상태 바꿔주기 이후 서버통신이 성공했을 때 이벤트를 주도록 변경하기
//        MapViewModel.ploatingButtonSet.accept(.waiting)
//
//        //플로팅 버튼 테스트용
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
//            self?.showSelectedAlert(title: "플로팅 테스트", message: "플로팅버튼 상태 테스트입니다") { _ in
//                MapViewModel.ploatingButtonSet.accept(.matched)
//
//            }
//        }
//    }
}

extension CustomTabmanViewController: TMBarDataSource, PageboyViewControllerDataSource {
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
        let title: String = index == 0 ? StartMatcingViewController.Vctype.near.title : StartMatcingViewController.Vctype.request.title
        item.title = title
        return item
    }
}
