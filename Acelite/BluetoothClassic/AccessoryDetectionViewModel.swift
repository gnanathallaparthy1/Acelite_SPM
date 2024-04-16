//
//  AccessoryDetectionViewModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/18/24.
//

import Foundation
import ExternalAccessory
import UIKit

class AccessoryDetectionViewModel {
	var sessionController:SessionController?
	var accessoryList:[EAAccessory]?
	var selectedAccessory: EAAccessory!
	var selectedName: String = ""
	var finalFilterArray: [EAAccessory]?
	
	func getAccessoryList() -> [EAAccessory] {
		guard let accessoryList = self.accessoryList else { return [EAAccessory]() }
		return accessoryList
	}
	
	func getSessionController() -> SessionController {
		let sessionController = SessionController.sharedController
		BluetoothClassicSharedInstance.sharedInstance.setSessionController(sessionController: sessionController)
		return sessionController
	}
	
	func setSelectedAccessory(accessory: EAAccessory)  {
		self.selectedAccessory = accessory
		BluetoothClassicSharedInstance.sharedInstance.setAccessoryValue(accessory: accessory)
	}
	
	func getSelectedAccessory() -> EAAccessory {
		guard let accessory = BluetoothClassicSharedInstance.sharedInstance.selectedAccessory else { return self.selectedAccessory }
		return accessory
	}
	
	func getSelectedAccessoryProtocolString() -> String {
		if selectedName.contains("OBDLink") {
			guard let protocolString = BluetoothClassicSharedInstance.sharedInstance.selectedAccessory?.protocolStrings[0] else {return ""}
			return protocolString
		} else {
			guard let protocolString = BluetoothClassicSharedInstance.sharedInstance.selectedAccessory?.protocolStrings[0] else {return ""}
			return protocolString
		}
	}
	
}
