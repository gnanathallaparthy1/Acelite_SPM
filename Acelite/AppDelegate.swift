//
//  AppDelegate.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 12/21/22.
//

import UIKit
import FirebaseCore
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		
//		#if PROD
//		print("PROD")
//
//		#elseif DEV
//		print("DEV")
//		
//		#endif
        #if PROD
		
		setupFirebaseConfigFiles(fileName: "GoogleService-Info-Prod")
		
		#elseif DEV
		setupFirebaseConfigFiles(fileName: "GoogleService-Info")
	   
		#endif
		
		
		
		//FirebaseApp.configure()
		UIApplication.shared.isIdleTimerDisabled = true
		return true
	}
	
	private func setupFirebaseConfigFiles(fileName: String) {
			//load a named file
			let filePath = Bundle.main.path(forResource: fileName, ofType: "plist")
			guard let fileopts = FirebaseOptions(contentsOfFile: filePath!)  else {
				print("file not found")
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

