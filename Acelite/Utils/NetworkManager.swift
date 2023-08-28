//
//  Connection.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 8/12/23.
//

import Foundation
import Reachability

class NetworkManager: NSObject {
	
	var reachability: Reachability!
	
	static let sharedInstance: NetworkManager = { return NetworkManager() }()
	
	
	override init() {
		super.init()
		
		reachability = try! Reachability()
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(networkStatusChanged(_:)),
			name: .reachabilityChanged,
			object: reachability
		)
		
		do {
			try reachability.startNotifier()
		} catch {
			print("Unable to start notifier")
		}
	}
	
	@objc func networkStatusChanged(_ notification: Notification) {
			if self.reachability.connection == .unavailable {
				NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "Network"), object: ["Network": "unavailable"], userInfo: nil)
			} else {
				NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "Network"), object: ["Network": "available"], userInfo: nil)
			}
			//print(self.reachability.connection)
		}
		//print(self.reachability.connection)
	//}
	
	static func stopNotifier() -> Void {
		do {
			try (NetworkManager.sharedInstance.reachability).startNotifier()
		} catch {
			print("Error stopping notifier")
		}
	}
	
	static func isReachable(completed: @escaping (NetworkManager) -> Void) {
		if (NetworkManager.sharedInstance.reachability).connection != .none {
			completed(NetworkManager.sharedInstance)
		}
	}
	
	static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
		if (NetworkManager.sharedInstance.reachability).connection == .none {
			completed(NetworkManager.sharedInstance)
		}
	}
	
	static func isReachableViaWWAN(completed: @escaping (NetworkManager) -> Void) {
		if (NetworkManager.sharedInstance.reachability).connection == .cellular {
			completed(NetworkManager.sharedInstance)
		}
	}
	
	static func isReachableViaWiFi(completed: @escaping (NetworkManager) -> Void) {
		if (NetworkManager.sharedInstance.reachability).connection == .wifi {
			completed(NetworkManager.sharedInstance)
		}
	}
}
