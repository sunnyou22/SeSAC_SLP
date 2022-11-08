//
//  SignUPViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/07.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    let mainView: UIView = SignView()
    var viewtype: CommonSignView
    
    init(viewtype: CommonSignView, view: UIView) {
        self.viewtype = viewtype
        self.mainView = view
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
}
