//
//  AppDelegate.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/07.
//

import UIKit
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
 
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        
        application.registerForRemoteNotifications()
        
        //메세지 대리자 설정
        Messaging.messaging().delegate = self
        
        //MARK: 네비게이션 백버튼
        let backButtonImage = UIImage(named: Icon.navigationBackButton.rawValue)
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        UINavigationBar.appearance().tintColor = .setBaseColor(color: .black)
        
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    enum PushKey: String, CaseIterable {
        case matched
        case dodge
        case studyAccepted
        case studyRequest
        
        var topViewcontroller: UIViewController {
            switch self {
            case .matched:
                return ChatViewController()
            case .dodge:
                return HomeMapViewController()
            case .studyAccepted:
                return StartMatcingViewController(type: .near, viewModel: .init(type: .near))
            case .studyRequest:
                return HomeMapViewController()
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.body) // 바디는 알림메세지의 내용
        print(response.notification.request.content.userInfo)// 파이어베이스에서 등록했던 키 밸류
        
        let userInfo = response.notification.request.content.userInfo
        guard let topViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
        
        for key in userInfo.keys {
            print(key, "반복문 들어옴")
           if let key = key as? String, let viewController = AppDelegate.PushKey(rawValue: key)?.topViewcontroller {
                print(key, viewController, topViewController, "화면전환")
               topViewController.setInitialViewController(to: viewController) // 네비게이션 바 아이템 점검해야함
               break
           }
        }
    }
    
    
    //포그라운드 알림 수신: 로컬/푸시 동일
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.badge, .sound, .banner, .list]) // 뱃지카운팅은 올라가면 좋겠을 때ㅔ
    }
}

extension AppDelegate: MessagingDelegate {

    //사용자가 앱을 삭제하거나, 핸드폰 기종을 바꿀 때 등으로 토큰에 대한 정보가 바뀔 때 불리는 메서드
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")
        
        UserDefaults.FCMToken = fcmToken!
        print(UserDefaults.FCMToken, fcmToken!)

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

