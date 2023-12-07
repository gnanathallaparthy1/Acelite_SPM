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
	public var minEstimatedRange : Float?
	public var maxEstimatedRange : Float?
	
	init(vehicleInfo: Vehicle, transactionID: String, testIntructionsId: String, healthScore: Float, grade: VehicleGrade, health: String, rangeAtBirth: Double?, minEstimatedRnge: Float?, maxEstimatedRnge: Float?) {
		self.vehicleInfo = vehicleInfo
		self.transactionId = transactionID
		self.testInstructionsId = testIntructionsId
		self.healthScore = healthScore
		self.grade = grade
		self.health = health
		self.rangeAtBirth = rangeAtBirth
		self.minEstimatedRange = minEstimatedRnge
		self.maxEstimatedRange = maxEstimatedRnge
	}
//	init(healthScore: Float) {
//		// grade: VehicleGrade) {
//		self.healthScore = healthScore
//		//self.grade = grade
//	}
}
