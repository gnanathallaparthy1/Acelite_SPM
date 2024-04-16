//
//  BluetoothClassicSharedInstance.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/18/24.
//

import Foundation
import ExternalAccessory

class BluetoothClassicSharedInstance {
	
	static let sharedInstance = BluetoothClassicSharedInstance()
	var sessionController: SessionController?
	var selectedAccessory: EAAccessory!
	var protocolStringName: String?
	   init(){}

	func setSessionController(sessionController: SessionController) {
		self.sessionController =  sessionController
		print(Date(), "shared instance sessionsController",BluetoothClassicSharedInstance.sharedInstance.sessionController ?? "", to: &Log.log)
	}
	
	func setAccessoryValue(accessory: EAAccessory) {
		self.selectedAccessory = accessory
	}
	
	func setProtocolStringName(protocolStringName: String) {
		self.protocolStringName = protocolStringName
	}
	
}
