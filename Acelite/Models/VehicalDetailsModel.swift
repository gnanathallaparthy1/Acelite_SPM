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
	let diagnosticSession: DiagnosticSession?
	let batteryAge, miscCommands: JSONNull?
}

// MARK: - DiagnosticSession
struct DiagnosticSession: Codable {
	let diagnosticSessionProtocol: ProtocolClass
	let challenge: DiagnosticSessionChallenge

	enum CodingKeys: String, CodingKey {
		case diagnosticSessionProtocol = "protocol"
		case challenge
	}
}

// MARK: - DiagnosticSessionChallenge
struct DiagnosticSessionChallenge: Codable {
	let header, pid: String
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
	let elm327ProtocolPreset, obdLinkProtocolPreset: String?
}

// MARK: - OdometerResponse
struct OdometerResponse: Codable {
	let startByte, endByte: Int
	let numberOfCells, bytesPerCell: Int?
	let startCellCount, endCellCount, bytesPaddedBetweenCells: Int?
	let multiplier: Double
	let constant: Int
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
	let bmsCapacity: Odometer?
	let stateOfCharge, energyToEmpty: Odometer?

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


