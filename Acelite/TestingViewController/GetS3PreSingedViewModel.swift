//
//  GetS3PreSingedViewModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 2/27/23.
//

import Foundation

struct GetS3PreSinged: Codable {
	let data: S3PreSingedData
}

// MARK: - DataClass
struct S3PreSingedData: Codable {
	let getS3PreSingedURL: GetS3PreSingedURL
}

// MARK: - GetS3PreSingedURL
struct GetS3PreSingedURL: Codable {
	let url: String
	let transactionID: String
	let fields: Fields

	enum CodingKeys: String, CodingKey {
		case url
		case transactionID = "transactionId"
		case fields
	}
}

// MARK: - Fields
struct Fields: Codable {
	let key, awsAccessKeyID, xamzSecurityToken, policy: String
	let signature: String

	enum CodingKeys: String, CodingKey {
		case key
		case awsAccessKeyID = "AWSAccessKeyId"
		case xamzSecurityToken = "XAMZSecurityToken"
		case policy, signature
	}
}
