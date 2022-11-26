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
 
        guard let idtoken = UserDefaults.idtoken else {
            let onboarding = OnboardingViewController()
           setInitialViewController(to: onboarding)
            return
        }
        
        idToken = idtoken
        configure()
        setContents()
    }
    
    func configure() {
        navigationItem.title = ""
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
//        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    func setContents() { }
}
