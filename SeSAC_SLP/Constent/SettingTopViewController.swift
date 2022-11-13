//
//  SettingTopViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit
extension UIViewController {
    var topViewController: UIViewController? {
        return self.topViewController(currtentViewController: self)
    }
    
    func topViewController(currtentViewController: UIViewController) -> UIViewController {
        
        //최상탄 뷰컨이 탭바일때
        if let tabBarController = currtentViewController as? UITabBarController, let selectedViewController = tabBarController.selectedViewController {
            return self.topViewController(currtentViewController: selectedViewController)
            
        } else if let navigationController = currtentViewController as? UINavigationController, let visibleViewController = navigationController.visibleViewController {
            return self.topViewController(currtentViewController: visibleViewController)
            
        } else if let presentedViewController = currtentViewController.presentedViewController {
            return self.topViewController(currtentViewController: presentedViewController)
            
        } else {
            return currtentViewController
        }
    }
}

class LoadingIndicator {
    static func showLoading() {
        DispatchQueue.main.async {
            // 최상단에 있는 window 객체 획득
            guard let window = UIApplication.shared.windows.last else { return }

            let loadingIndicatorView: UIActivityIndicatorView
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = UIActivityIndicatorView(style: .large)
                /// 다른 UI가 눌리지 않도록 indicatorView의 크기를 full로 할당
                loadingIndicatorView.frame = window.frame
                loadingIndicatorView.color = .brown
                window.addSubview(loadingIndicatorView)
            }

            loadingIndicatorView.startAnimating()
        }
    }

    static func hideLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
}
