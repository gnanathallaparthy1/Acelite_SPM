//
//  SubmitBatteryFilesWithSOCModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/3/23.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let submitBatteryDataFileWithSOC = try? JSONDecoder().decode(SubmitBatteryDataFileWithSOC.self, from: jsonData)

import Foundation

// MARK: - SubmitBatteryDataFileWithSOC
struct SubmitBatteryDataFileWithSOC: Encodable {
	var data: SOCClass
}

// MARK: - DataClass
struct SOCClass: Codable {
	var submitBatteryDataFilesWithStateOfCharge: SubmitBatteryDataFilesWithStateOfCharge
}

// MARK: - SubmitBatteryDataFilesWithStateOfCharge
struct SubmitBatteryDataFilesWithStateOfCharge: Codable {
	var estimatedRange: EstimatedRange?
	var batteryScore: BatteryScore?
}

// MARK: - BatteryScore
struct BatteryScore: Codable {
	var score: Int?
	var grade, health: String?
	var factorsUsed: [FactorsUsed]?
}

// MARK: - FactorsUsed
struct FactorsUsed: Codable {
	var name, type: String?
}

// MARK: - EstimatedRange
struct EstimatedRange: Codable {
	var estimatedRangeMin, estimatedRangeMax: JSONNull?
}
