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
//        let viewModel = ManagementViewModel()
        let disposeBag = DisposeBag()
        var cardToggle: Bool = false
            
        override func loadView() {
           view = mainView
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
    
   
}
