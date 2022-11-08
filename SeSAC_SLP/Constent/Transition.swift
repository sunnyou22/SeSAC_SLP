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
}
