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
	public var testInstructionsId: String?
	public var health: String?
	public var grade: VehicleGrade?
	public var healthScore : Float?
	public var rangeAtBirth : Double?
	public var minEstimatedRange : Double?
	public var maxEstimatedRange : Double?
	public var bmsCapacity: Double? = 0.0
	init(vehicleInfo: Vehicle, transactionID: String, testIntructionsId: String, healthScore: Float, grade: VehicleGrade, health: String, rangeAtBirth: Double?, minEstimatedRnge: Double?, maxEstimatedRnge: Double?, bmsCapacity: Double?) {
		self.vehicleInfo = vehicleInfo
		self.transactionId = transactionID
		self.testInstructionsId = testIntructionsId
		self.healthScore = healthScore
		self.grade = grade
		self.health = health
		self.rangeAtBirth = rangeAtBirth
		self.minEstimatedRange = minEstimatedRnge
		self.maxEstimatedRange = maxEstimatedRnge
		self.bmsCapacity = bmsCapacity
	}
//	init(healthScore: Float) {
//		// grade: VehicleGrade) {
//		self.healthScore = healthScore
//		//self.grade = grade
//	}
}
