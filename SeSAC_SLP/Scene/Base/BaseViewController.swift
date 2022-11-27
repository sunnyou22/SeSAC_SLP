//
//  BaseViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/07.
//

import UIKit

class BaseViewController: UIViewController, BaseDelegate {
    var idToken: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let idtoken = UserDefaults.idtoken else {
            let onboarding = OnboardingViewController()
            setInitialViewController(to: onboarding)
            print("토큰 없어서 온보딩으로 감", #file)
            return
        }
        idToken = idtoken
        
        configure()
        setConstraints()
        fetchData()
    }
    
    func configure() {
        navigationItem.title = ""
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        //        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    func setConstraints() { }
   
    func fetchData() { }
}
