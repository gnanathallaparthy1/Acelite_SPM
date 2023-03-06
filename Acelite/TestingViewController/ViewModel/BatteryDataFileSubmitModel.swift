//
//  BatteryDataFileSubmitModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/2/23.
//

import Foundation
/*
// MARK: - SubmitBatteryDataFileWithSOC
struct SubmitBatteryDataFileWithSOC: Codable {
	let errors: [Error]
	let data: BatteryDataClass
}

// MARK: - DataClass
struct BatteryDataClass: Codable {
	let submitBatteryDataFilesWithStateOfCharge: JSONNull?
}

// MARK: - Error
struct Error: Codable {
	let message: String
	let extensions: ErrorExtensions
}

// MARK: - ErrorExtensions
struct ErrorExtensions: Codable {
	let code, serviceName: String
	let extensions: ExtensionsExtensions
	let exception: Exception
}

// MARK: - Exception
struct Exception: Codable {
	let message: String
	let locations: [Location]
	let path: [String]
}

// MARK: - Location
struct Location: Codable {
	let line, column: Int
}

// MARK: - ExtensionsExtensions
struct ExtensionsExtensions: Codable {
	let code, correlationID, transactionID: String

	enum CodingKeys: String, CodingKey {
		case code
		case correlationID = "correlationId"
		case transactionID = "transactionId"
	}
}
*/
//// MARK: - Encode/decode helpers
//
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



