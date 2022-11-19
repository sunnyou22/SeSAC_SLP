//
//  SetMyInfoViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/15.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class SetMyInfoViewController: BaseViewController {
 
        let mainView = MyPageInfoScrollView()
       let apiViewModel = CommonServerManager()
        let disposeBag = DisposeBag()
        var cardToggle: Bool = false
            
        override func loadView() {
           view = mainView
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            mainView.cardView.nicknameView.toggleButton.addTarget(self, action: #selector(test), for: .touchUpInside)
            print(UserDefaults.idtoken)
            guard let idtoken = UserDefaults.idtoken else {
                print("다음 버튼을 눌렀는데 토큰이 없어 🔴")
                return }
            
            // 통신하기
//            apiViewModel.USerInfoNetwork(idtoken: idtoken)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setnavigation()
    }
    
    func setnavigation() {
        navigationItem.titleView?.tintColor = .setBaseColor(color: .black)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.setBaseColor(color: .black)]
        navigationItem.title = "정보관리"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(postToServer))
    }
        
    @objc func postToServer() {
        
    }
    
    @objc func test() {
        mainView.cardView.expandableView.isHidden =  !mainView.cardView.expandableView.isHidden
    }
   
}
