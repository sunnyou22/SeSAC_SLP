//
//  Transition.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/08.
//

import UIKit

enum Transition {
    case push
    case presentFullScreen
    case navPresentFullScreen
}

extension UIViewController {
    
    func transition(_ to: UIViewController, _ transition: Transition) {
        switch transition {
        case .push:
            self.navigationController?.pushViewController(to, animated: true)
        case .presentFullScreen:
            present(to, animated: true)
        case .navPresentFullScreen:
            let nav = UINavigationController(rootViewController: to)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    func setInitialViewController(to: UIViewController) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 2
        sceneDelegate?.window?.layer.add(transition, forKey: kCATransition)
        
        let signViewController = to
        let nav = UINavigationController(rootViewController: signViewController)
        sceneDelegate?.window?.rootViewController = nav
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
