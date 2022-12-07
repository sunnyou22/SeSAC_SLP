//
//  ShopViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/24.
//

import UIKit

import RxCocoa
import RxSwift

//컬렉션뷰로도 구현해보기

class ShopViewController: BaseViewController, Sendableitem {
    
   
    var mainView = ShopView()
   let viewModel = ShopViewModel()
    let bag = DisposeBag()
    
    var sesacname: String?
    var backgroundname: String?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setContainerViewController()
        bind()
    }
    
    func bind() {
        viewModel.shopMyInfoStatus
            .withUnretained(self)
            .asDriver(onErrorJustReturn: (self, .notsignUpUser))
            .drive { (vc, status) in
                switch status {
                case .success:
                    print("새싹 썸넬 업데이트 성공")
                case .notowned:
                    vc.showDefaultToast(message: .ReceiptValidationStatus(.notsignUpUser))
                default:
                    print("기타에러")
                }
            }.disposed(by: bag)
        
        mainView.saveBtn.rx
            .tap
            .withUnretained(self)
            .asDriver(onErrorJustReturn: (self, print("저장버튼 구독")))
            .drive { (vc, _) in
                let sesacnum: Int = Int(String(vc.sesacname?.last ?? "1")) ?? 1
                let backgroundnum: Int = Int(String(vc.backgroundname?.last ?? "1")) ?? 1
                vc.viewModel.saveUserThunnail(sesec: sesacnum - 1, background: backgroundnum - 1, idtoken: vc.idToken)
                print(sesacnum, backgroundnum)
            }.disposed(by: bag)
    }
    
    func sendSesacimgStr(_ name: String) {
        mainView.sesac.image = UIImage(named: name)
        sesacname = name
    }
    
    func sendBackgroundimgStr(_ name: String) {
        mainView.background.image = UIImage(named: name)
        backgroundname = name
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
        vc.sesacVC.delegate = self
        vc.backgruondVC.delegate = self
    }
}

