//
//  WorkOrderViewModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 11/2/23.
//

import Foundation

class WorkOrderViewModel {
	var vehicleInfo:  Vehicle
	public var workOrder: String?
	var isShortProfile: Bool?
	
	init(vehicleInfo: Vehicle, workOrder: String?, isShortProfile: Bool) {
		self.vehicleInfo = vehicleInfo
		self.workOrder = workOrder
		//change later
		self.isShortProfile = isShortProfile
	}
	
}
