//
//  BaseViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/07.
//

import UIKit

class BaseViewController: UIViewController {
    
    var idToken: String = "토큰이 들어오지 않음 \(#file)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        
        guard let idtoken = UserDefaults.idtoken else {
            let onboarding = OnboardingViewController()
           setInitialViewController(to: onboarding)
            return
        }
        
        idToken = idtoken
    }
    
    func configure() { }
    func setContents() { }
}
