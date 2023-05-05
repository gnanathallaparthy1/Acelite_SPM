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
	public var health: String?
	public var grade: VehicleGrade?
	public var healthScore : Float?
	
	init(vehicleInfo: Vehicle, transactionID: String, healthScore: Float, grade: VehicleGrade, health: String) {
		self.vehicleInfo = vehicleInfo
		self.transactionId = transactionID
		self.healthScore = healthScore
		self.grade = grade
		self.health = health
	}
//	init(healthScore: String, grade: VehicleGrade) {
//		self.healthScore = healthScore
//		self.grade = grade
//	}
}
