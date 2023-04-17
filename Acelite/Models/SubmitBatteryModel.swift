//
//  SubmitBatteryModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 4/4/23.
//

import Foundation

// MARK: - SubmitBatteryDataWithStateOfCharge
struct SubmitBatteryDataWithStateOfCharge: Codable {
	let data: DataClass
}
//
//// MARK: - DataClass
//struct DataClass: Codable {
//	let submitBatteryDataFilesWithStateOfCharge: SubmitBatteryDataFilesWithStateOfCharge
//}

// MARK: - SubmitBatteryDataFilesWithStateOfCharge
struct SubmitBatteryDataFilesWithStateOfCharge: Codable {
	let estimatedRange: EstimatedRange?
	let batteryScore: BatteryScore?
}

// MARK: - BatteryScore
struct BatteryScore: Codable {
	let score: Int
	let grade, health: String
	let factorsUsed: [FactorsUsed]
}

// MARK: - FactorsUsed
struct FactorsUsed: Codable {
	let name, type: String
}

// MARK: - EstimatedRange
struct EstimatedRange: Codable {
	let estimatedRangeMin, estimatedRangeMax: JSONNull?
}
