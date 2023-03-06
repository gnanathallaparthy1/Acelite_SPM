//
//  VehicalDetailsModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 1/26/23.
//


import Foundation

// MARK: - Welcome
struct Welcome: Codable {
	let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
	let vehicle: Vehicle
}


// MARK: - Vehicle
struct Vehicle: Codable {
	let make, modelName: String
	let year: Int
	let vin, mid, manufacturer, bodyStyle: String
	let bodyType, trimName, title, vehicleType: String
	let getBatteryTestInstructions: [GetBatteryTestInstruction]?
}

// MARK: - GetBatteryTestInstruction
struct GetBatteryTestInstruction: Codable {
	let testCommands: TestCommands?
}

// MARK: - TestCommands
struct TestCommands: Codable {
	let id: String
	let vehicleProfile: VehicleProfile?
	let odometer: Odometer?
	let stateOfHealthCommands: StateOfHealthCommands?
	let sampledCommands: SampledCommands
	let batteryAge, diagnosticSession, miscCommands: JSONNull?
}

enum ItemType: String, Decodable {
	case video
	case recipe
}

// MARK: - Odometer
struct Odometer: Codable {
	let odometerProtocol: ProtocolClass?
	let challenge: Challenge?
	let response: OdometerResponse
	let validation: Validation

	enum CodingKeys: String, CodingKey {
		case odometerProtocol = "protocol"
		case challenge, response, validation
	}
}

// MARK: - Challenge
struct Challenge: Codable {
	let header, pid: String
	let flowControl: FlowControl?
}

// MARK: - FlowControl
struct FlowControl: Codable {
	let flowControlHeader, flowControlData: String?
}

// MARK: - ProtocolClass
struct ProtocolClass: Codable {
	let elm327ProtocolPreset, obdLinkProtocolPreset: String
}

// MARK: - OdometerResponse
struct OdometerResponse: Codable {
	let startByte, endByte: Int
	let multiplier, constant: Double
}

// MARK: - Validation
struct Validation: Codable {
	let numberOfFrames: Int
	let lowerBounds, upperBounds: Double
}

// MARK: - SampledCommands
struct SampledCommands: Codable {
	let sampledCommandsProtocol: ProtocolClass
	let packTemperature: [PackTemperature]
	let packVoltage, packCurrent: Odometer
	let cellVoltage: [CellVoltage]

	enum CodingKeys: String, CodingKey {
		case sampledCommandsProtocol = "protocol"
		case packTemperature, packVoltage, packCurrent, cellVoltage
	}
}

// MARK: - CellVoltage
struct CellVoltage: Codable {
	let challenge: Challenge
	let response: CellVoltageResponse
	let validation: Validation
}

// MARK: - CellVoltageResponse
struct CellVoltageResponse: Codable {
	let startByte, endByte, numberOfCells, bytesPerCell: Int
	let startCellCount, endCellCount, bytesPaddedBetweenCells: Int
	let multiplier: Double
	let constant: Int
}

// MARK: - PackTemperature
struct PackTemperature: Codable {
	let challenge: Challenge
	let response: PackTemperatureResponse
	let validation: Validation
}

// MARK: - PackTemperatureResponse
struct PackTemperatureResponse: Codable {
	let startByte, endByte, numberOfSensors, bytesPerSensors: Int
	let startSensorsCount, endSensorsCount, bytesPaddedBetweenSensors, multiplier: Int
	let constant: Int
}

// MARK: - StateOfHealthCommands
struct StateOfHealthCommands: Codable {
	let stateOfCharge: Odometer?
	let energyToEmpty: Double?
}

// MARK: - VehicleProfile
struct VehicleProfile: Codable {
	let nominalVoltage, energyAtBirth: Double?
	let batteryType: String?
	let capacityAtBirth: Double?
	let rangeAtBirth, designChargeCycles: Double?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

	public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
		return true
	}

	public var hashValue: Int {
		return 0
	}

	public init() {}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if !container.decodeNil() {
			throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
		}
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encodeNil()
	}
}
//// MARK: - VehicalInformation
//struct VehicalInformation: Codable {
//	let data: DataClass
//}
//
//// MARK: - DataClass
//struct DataClass: Codable {
//	let vehicle: Vehicle
//	//let getBatteryTestInstruction : GetBatteryTestInstruction
//}
//
//// MARK: - Vehicle
//public struct Vehicle: Codable {
//	let make, modelName: String
//	let year: Int
//	let vin: String?
//	let mid, manufacturer, bodyStyle: String
//	let bodyType, trimName, title, vehicleType: String
//	let getBatteryTestInstructions: [GetBatteryTestInstruction]
//}
//
//// MARK: - GetBatteryTestInstruction
//public struct GetBatteryTestInstruction: Codable {
//	let testCommands: TestCommands
//}
//
//// MARK: - TestCommands
//public struct TestCommands: Codable {
//	let id: String?
//	let vehicleProfile: VehicleProfile?
//	let odometer: Odometer?
//	let stateOfHealthCommands: StateOfHealthCommands?
//	let sampledCommands: SampledCommands?
//	let batteryAge, diagnosticSession, miscCommands: JSONNull?
//}
//
//// MARK: - Odometer
//public struct Odometer: Codable {
//	let odometerProtocol: ProtocolClass?
//	let challenge: Challenge?
//	let response: OdometerResponse?
//	let validation: Validation?
//
//	enum CodingKeys: String, CodingKey {
//		case odometerProtocol = "protocol"
//		case challenge, response, validation
//	}
//}
//
//// MARK: - Challenge
//public struct Challenge: Codable {
//	let header, pid: String
//	let flowControl: FlowControl?
//}
//
//// MARK: - FlowControl
//public struct FlowControl: Codable {
//	let flowControlHeader, flowControlData: String?
//}
//
//// MARK: - ProtocolClass
//public struct ProtocolClass: Codable {
//	let elm327ProtocolPreset, obdLinkProtocolPreset: String?
//}
//
//// MARK: - OdometerResponse
//public struct OdometerResponse: Codable {
//	let startByte, endByte: Int?
//	let multiplier, constant: Double?
//}
//
//// MARK: - Validation
//public struct Validation: Codable {
//	let numberOfFrames: Int?
//	let lowerBounds, upperBounds: Double?
//}
//
//// MARK: - SampledCommands
//public struct SampledCommands: Codable {
//	let sampledCommandsProtocol: ProtocolClass?
//	let packTemperature: [PackTemperature]?
//	let packVoltage, packCurrent: Odometer?
//	let cellVoltage: [CellVoltage]?
//
//	enum CodingKeys: String, CodingKey {
//		case sampledCommandsProtocol = "protocol"
//		case packTemperature, packVoltage, packCurrent, cellVoltage
//	}
//}
//
//// MARK: - CellVoltage
//public struct CellVoltage: Codable {
//	let challenge: Challenge?
//	let response: CellVoltageResponse?
//	let validation: Validation?
//}
//
//// MARK: - CellVoltageResponse
//public struct CellVoltageResponse: Codable {
//	let startByte, endByte, numberOfCells, bytesPerCell: Int?
//	let startCellCount, endCellCount, bytesPaddedBetweenCells: Int?
//	let multiplier: Double?
//	let constant: Int?
//}
//
//// MARK: - PackTemperature
//public struct PackTemperature: Codable {
//	let challenge: Challenge?
//	let response: PackTemperatureResponse?
//	let validation: Validation?
//}
//
//// MARK: - PackTemperatureResponse
//public struct PackTemperatureResponse: Codable {
//	let startByte, endByte, numberOfSensors, bytesPerSensors: Int?
//	let startSensorsCount, endSensorsCount, bytesPaddedBetweenSensors, multiplier: Int?
//	let constant: Int?
//}
//
//// MARK: - StateOfHealthCommands
//public struct StateOfHealthCommands: Codable {
//	let stateOfCharge: Odometer?
//	let energyToEmpty: JSONNull?
//}
//
//// MARK: - VehicleProfile
//public struct VehicleProfile: Codable {
//	let nominalVoltage, energyAtBirth: Int?
//	let batteryType: String?
//	let capacityAtBirth: Double?
//	let rangeAtBirth, designChargeCycles: JSONNull?
//}
//let vehicalData = value["data"] as? [String: Any] ?? [: ]

//struct Vehicle: Codable {
//	var make: String
//	var modelName: String
//	var year: Int
//	var vin: String
//	var mid: String
//	var manufacturer: String
//	var bodyStyle: String
//	var bodyType: String
//	var trimName: String
//	var title: String
//	var vehicleType: String
//	var getBatteryTestInstructions: [TestCommands]
//}
//
//struct FlowControl: Codable {
//	var flowControlHeader: String
//	var flowControlData: String
//}
//
//struct Challenge: Codable {
//	var header: String
//	var pid: String
//	var flowControl: FlowControl
//}
//
//struct Protocoll: Codable {
//	var elm327ProtocolPreset: String
//	var obdLinkProtocolPreset: String
//}
//
//struct Response: Codable {
//	var startByte: Int?
//	var endByte:  Int?
//	var numberOfSensors:  Int?
//	var bytesPerSensors:  Int?
//	var startSensorsCount:  Int?
//	var endSensorsCount:  Int?
//	var bytesPaddedBetweenSensors: Int?
//	var multiplier:  Int?
//	var constant: Int?
//
//}
//
//struct Validation: Codable {
//	var numberOfFrames: Int
//	var lowerBounds: Int
//	var upperBounds: Int
//}
//
//
//struct TestCommands: Codable {
//	var id: String
//	var vehicleProfile: VehicleProfile
//	var odometer: Odometer
//	var stateOfHealthCommands: StateOfHealthCommands
//	var sampledCommands: SampledCommands
//	var batteryAge: String?
//	var diagnosticSession: String?
//	var miscCommands: String?
//}
//
//struct VehicleProfile: Codable {
//	var nominalVoltage: Int
//	var energyAtBirth: Int
//	var batteryType: String
//	var capacityAtBirth: Float
//	var rangeAtBirth: String?
//	var designChargeCycles: String?
//}
//
//struct Odometer: Codable {
//	var protocoll: Protocoll
//	var challenge: Challenge
//	var response: Response
//	var validation: Validation
//}
//
//struct StateOfCharge: Codable {
//	var protocoll: Protocoll
//	var challenge: Challenge
//	var response: Response
//	var validation: Validation
//}
//
//struct StateOfHealthCommands: Codable {
//	var stateOfCharge: StateOfCharge
//	var energyToEmpty: String?
//}
//
//struct PackTemperature: Codable {
//	var challenge: Challenge
//	var response: Response
//	var validation: Validation
//}
//
//struct PackVoltage: Codable {
//	var challenge: Challenge
//	var response: Response
//	var validation: Validation
//}
//
//struct PackCurrent: Codable {
//	var challenge: Challenge
//	var response: Response
//	var validation: Validation
//}
//
//struct CellVoltage: Codable {
//	var challenge: Challenge
//	var response: Response
//	var validation: Validation
//}
//
//
//struct SampledCommands: Codable {
//	var protocoll: Protocoll
//	var packTemperature: [PackTemperature]
//	var packVoltage: PackVoltage
//	var packCurrent: PackCurrent
//}
// MARK: - Encode/decode helpers

//class JSONNull: Codable, Hashable {
//
//	public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//		return true
//	}
//
//	public var hashValue: Int {
//		return 0
//	}
//
//	public init() {}
//
//	public required init(from decoder: Decoder) throws {
//		let container = try decoder.singleValueContainer()
//		if !container.decodeNil() {
//			throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//		}
//	}
//
//	public func encode(to encoder: Encoder) throws {
//		var container = encoder.singleValueContainer()
//		try container.encodeNil()
//	}
//}


