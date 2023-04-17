//
//  BatteryHealthViewModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/26/23.
//

import Foundation

class BatteryHealthViewModel {
	
	init(vehicleInfo: Vehicle, transactionID: String, healthScore: Int) {
		self.vehicleInfo = vehicleInfo
		self.transactionId = transactionID
		self.healthScore = healthScore
	}
	
	public var vehicleInfo: Vehicle?
	public var transactionId: String?
	public var healthScore: Int?
}
