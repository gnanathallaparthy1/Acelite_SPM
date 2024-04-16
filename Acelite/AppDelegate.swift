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
import CoreData
import ExternalAccessory

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
	let gcmMessageIDKey = "gcm.Message_ID"
	let notificationCenter = UNUserNotificationCenter.current()
	

	
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		print(BuildConfig().getXapiKey())
		print(BuildConfig().getBaseUrl())
		
		let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound, .sound]
		UNUserNotificationCenter.current().requestAuthorization(
			options: authOptions,
			completionHandler: { _, _ in }
		)
		
		application.registerForRemoteNotifications()
		
#if DEV
		setupFirebaseConfigFiles(fileName: "GoogleService-Info_Dev")
#else
		setupFirebaseConfigFiles(fileName: "GoogleService-Info")
#endif
		//setupFirebaseConfigFiles(fileName: "GoogleService-Info")
		
	
		
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
		
#if DEV
	  print("This is a Development Environment")
#else
		print("This is a Production Environment")
#endif
		
		
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
	
	// MARK: - Core Data stack

	lazy var persistentContainer: NSPersistentContainer = {
		/*
		 The persistent container for the application. This implementation
		 creates and returns a container, having loaded the store for the
		 application to it. This property is optional since there are legitimate
		 error conditions that could cause the creation of the store to fail.
		*/
		// BatteryInstructionsData
		//
		let container = NSPersistentContainer(name: "VinData")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				 
				/*
				 Typical reasons for an error here include:
				 * The parent directory does not exist, cannot be created, or disallows writing.
				 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
				 * The device is out of space.
				 * The store could not be migrated to the current model version.
				 Check the error message to determine what the actual problem was.
				 */
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
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
		
		print("remote notification data", userInfo)
		guard let screenName: String = userInfo["screen"] as? String , screenName == "testable_models"  else { return  }
		if(application.applicationState == .active || application.applicationState == .inactive){
			NotificationCenter.default.post(name:NSNotification.Name("identifier"), object: userInfo)
			
		}
	}
	
	
}

extension AppDelegate {
	
	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
		self.saveContext()
	}
	
	// MARK: - Core Data Saving support

	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}

}


