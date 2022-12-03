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
    
    private let rightBarButton = UIBarButtonItem(title: "찾기중단", style: .plain, target: nil, action: nil)
    let nearVC = StartMatcingViewController(type: .near, viewModel: .init(type: .near))
    let requestVC = StartMatcingViewController(type: .requested, viewModel: .init(type: .requested))
    
    private let commonServer = CommonServerManager()
    private let bag = DisposeBag()
    
    private var viewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers.append(nearVC)
        viewControllers.append(requestVC)
        
        self.dataSource = self
        
        setBarConfig()
        setNavigationBar()
        bind()
    }
    
    func setNavigationBar() {
        
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func bind() {
        
        guard let idtoken = UserDefaults.idtoken else {
            let onboarding = OnboardingViewController()
            setInitialViewController(to: onboarding)
            print("토큰 없어서 온보딩으로 감", #file)
            return
        }
        
        rightBarButton.rx
            .tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.commonServer.delete(idtoken: idtoken)
            }.disposed(by: bag)
        
        commonServer.deleteStatus
            .withUnretained(self)
            .bind { vc, statusCode in
                switch statusCode {
                case .success:
                    print("찾기중단 성공")
                    guard let viewControllers : [UIViewController] = vc.navigationController?.viewControllers as? [UIViewController] else { return  }
                    vc.navigationController?.popToViewController(viewControllers[viewControllers.count - 3 ], animated: true)
                case .matched:
                    vc.showDefaultToast(message: .DeleteStatus(.matched))
                case .firebaseTokenError:
                    FirebaseManager.shared.getIDTokenForcingRefresh()
                    vc.showDefaultToast(message: .DeleteStatus(.firebaseTokenError))
                case .notsignUpUser:
                    vc.showDefaultToast(message: .DeleteStatus(.notsignUpUser))
                case .serverError:
                    vc.showDefaultToast(message: .DeleteStatus(.serverError))
                case .clientError:
                    vc.showDefaultToast(message: .DeleteStatus(.clientError))
                }
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
        let title: String = index == 0 ? StartMatcingViewController.Vctype.near.title : StartMatcingViewController.Vctype.requested.title
        item.title = title
        return item
    }
}
