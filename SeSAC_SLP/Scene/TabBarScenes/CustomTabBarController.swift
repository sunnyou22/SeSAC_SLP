//
//  CustomTabBarController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/24.
//

import UIKit

final class CustomTabBarController: UITabBarController {
    private let homeVC = HomeMapViewController()
    private let shopVC = ShopViewController() // 임시로 바꿈
    private let chatVC = SearchViewController()
    private let mypageVC = MyPageListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setUpAppearance()
    }
    
    private func configure() {
        
        let homeVC = UINavigationController(rootViewController: homeVC)
        let shopVC = UINavigationController(rootViewController: shopVC)
        let chatVC = UINavigationController(rootViewController: chatVC)
        let mypageVC = UINavigationController(rootViewController: mypageVC)
        
        setViewControllers([homeVC, shopVC, chatVC, mypageVC], animated: true)
        
        if let items = tabBar.items {
            for i in 0...(items.count - 1) {
                
                items[i].selectedImage = UIImage(named: "ic-\(TabBarIcon.allCases[i].rawValue)")
                items[i].image = UIImage(named: "inact_ic-\(TabBarIcon.allCases[i].rawValue)")
                items[i].title = TabBarIcon.allCases[i].Img
            }
        }
    }
    
    private func setUpAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .setBaseColor(color: .white)
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .setBrandColor(color: .green)
    }
}
