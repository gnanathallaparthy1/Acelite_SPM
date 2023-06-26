//
//  FirebaseLogging.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 5/4/23.
//

import Foundation
import Firebase

class FirebaseLogging {
	public static let instance = FirebaseLogging()
	private init(){}
	   
	
	func logEvent(eventName: String , parameters: [String : String]?) {
		Analytics.logEvent(eventName, parameters: parameters)
	}
	
	func logScreen(screenName: String) {
		Analytics.logEvent(AnalyticsEventScreenView,
						   parameters: [AnalyticsParameterScreenName: screenName])
	}
	
	func setUserProperty(value: String , forProperty: String) {
		Analytics.setUserProperty(value, forName: forProperty)
	}
	
}
