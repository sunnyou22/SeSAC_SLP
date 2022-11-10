//
//  AppDelegate.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/07.
//

import UIKit
import FirebaseCore
//import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
 
//        //메세지 대리자 설정
//        Messaging.messaging().delegate = self
        
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

//extension AppDelegate: MessagingDelegate {
//
//    //사용자가 앱을 삭제하거나, 핸드폰 기종을 바꿀 때 등으로 토큰에 대한 정보가 바뀔 때 불리는 메서드
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//      print("Firebase registration token: \(String(describing: fcmToken))")
////        UserDefaults.standard.set(idToken, forKey: "FCMToken")
//
//      let dataDict: [String: String] = ["token": fcmToken ?? ""]
//      NotificationCenter.default.post(
//        name: Notification.Name("FCMToken"),
//        object: nil,
//        userInfo: dataDict
//      )
//      // TODO: If necessary send token to application server.
//      // Note: This callback is fired at each app startup and whenever a new token is generated.
//    }
//
//}

