//
//  SceneDelegate.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/07.
//

import UIKit
import Network

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    //네트워크 불안정 모니터, 네트워크 감지에 필요한 모니터 인스턴스 생성
    var errorWindow: UIWindow?
    var networkMonitor: NetworkMonitor = NetworkMonitor()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let vc = LaunchScreenViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        //네트워크 체크
        networkMonitor.startMonitoring { [weak self] connectionStatus in
            switch connectionStatus {
            case .satisfied:
                self?.removeNetworkErrorWindow()
                print("dismiss networkError View if is present")
            case .unsatisfied:
                self?.loadNetworkErrorWindow(on: scene)
                print("No Internet!! show network Error View")
            default:
                break
            }
        }
    }
    
    private func loadNetworkErrorWindow(on scene: UIScene) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.windowLevel = .statusBar
            window.makeKeyAndVisible() // 이걸해줘야 화면에 보임
            
            let noNetworkView = NoNetWorkView(frame: window.bounds)
            window.addSubview(noNetworkView)
            self.errorWindow = window
        }
    }
    
    private func removeNetworkErrorWindow() {
        errorWindow?.resignKey()
        errorWindow?.isHidden = true
        errorWindow = nil
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        
        networkMonitor.stopMonitoring()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

