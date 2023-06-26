//
//  AppDelegate.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 12/21/22.
//

import UIKit
import FirebaseCore
import Firebase
import FirebaseMessaging
@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
	let gcmMessageIDKey = "gcm.Message_ID"
	let notificationCenter = UNUserNotificationCenter.current()
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		
		let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound, .sound]
		UNUserNotificationCenter.current().requestAuthorization(
			options: authOptions,
			completionHandler: { _, _ in }
		)
		
		application.registerForRemoteNotifications()
		FirebaseApp.configure()
		
		//Messaging
		Messaging.messaging().delegate = self
		UNUserNotificationCenter.current().delegate = self
		//Register for Push notifications
		notificationCenter.delegate = self
		
		//Remote Notification Navigation
		if let option = launchOptions {
			let info = option[UIApplication.LaunchOptionsKey.remoteNotification]
			if (info != nil) {
				//self.goAnotherVC()
			}
		}
		
		return true
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		Messaging.messaging().apnsToken = deviceToken
	}
	
	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
		print("Firebase registration token: \(String(describing: fcmToken))")
		let dataDict: [String: String] = ["token": fcmToken ?? "",
										  "content-available" : "true"]
		NotificationCenter.default.post(
			name: Notification.Name("FCMToken"),
			object: nil,
			userInfo: dataDict
		)
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		
		print("i am not available in simulator :( \(error)")
	}
	
	
	private func setupFirebaseConfigFiles(fileName: String) {
		//load a named file
		let filePath = Bundle.main.path(forResource: fileName, ofType: "plist")
		guard let fileopts = FirebaseOptions(contentsOfFile: filePath!)  else {
			//print("file not found")
			return
			
		}
		FirebaseApp.configure(options: fileopts)
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
	// Receive displayed notifications for iOS 10 devices.
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								willPresent notification: UNNotification) async
	-> UNNotificationPresentationOptions {
		let userInfo = notification.request.content.userInfo
		print(userInfo)
		
		// Change this to your preferred presentation option
		return [[.alert, .sound]]
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								didReceive response: UNNotificationResponse) async {
		let userInfo = response.notification.request.content.userInfo
		let application = UIApplication.shared
		
		if(application.applicationState == .active || application.applicationState == .inactive){
			NotificationCenter.default.post(name:NSNotification.Name("identifier"), object: userInfo)
			
		}
	}
}


