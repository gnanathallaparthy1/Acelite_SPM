//
//  BatteryHealthViewModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/26/23.
//

import Foundation

class BatteryHealthViewModel {
	
	public var vehicleInfo: Vehicle?
	public var transactionId: String?
	public var grade: VehicleGrade?
	public var healthScore : String?
	
	init(vehicleInfo: Vehicle, transactionID: String, healthScore: String, grade: VehicleGrade) {
		self.vehicleInfo = vehicleInfo
		self.transactionId = transactionID
		self.healthScore = healthScore
		self.grade = grade
	}
}
