//
//  WorkOrderViewModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 11/2/23.
//

import Foundation
import FirebaseDatabase
import Firebase

protocol WorkOrderViewModelDelegate: AnyObject {
	func downloadLocations()
}

class WorkOrderViewModel {
	var vehicleInfo:  Vehicle
	public var workOrder: String?
	var isShortProfile: Bool?
	var remoteConfig = RemoteConfig.remoteConfig()
	 var locations : [[String: Any]]?
	var delegate: WorkOrderViewModelDelegate? = nil
	init(vehicleInfo: Vehicle, workOrder: String?, isShortProfile: Bool) {
		self.vehicleInfo = vehicleInfo
		self.workOrder = workOrder
		//change later
		self.isShortProfile = isShortProfile
		fetchLocationCodes()
	}
	
	func fetchLocationCodes() {
		
		remoteConfig.fetch(withExpirationDuration: 0) { [unowned self] (status, error) in
			guard error == nil else {
				
				return }
			print("got remote")
			remoteConfig.activate()
			let locationCodes = remoteConfig.configValue(forKey: "manheim_locations_code").jsonValue as? AnyObject
			if let arrayObject = locationCodes, arrayObject.count > 0 {
				let array = arrayObject.value(forKey: "locations") as? NSArray
				guard let locationCodeModel = array, locationCodeModel.count > 0 else {
				
					return
				}
				locations = locationCodeModel as? [[String : Any]]
				print("delegate", delegate)
				delegate?.downloadLocations()
			}
			
		}
			
			
	}
	
}
