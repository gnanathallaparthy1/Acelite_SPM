//
//  Constants.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 1/26/23.
//

import Foundation

class Constants {
	static let BASE_URL = "https://www.google.com/"

	static let GRAPHQL_SCHEME = BuildConfig.GRAPHQL_SCHEME
	static let GRAPHQL_BASE_URL = BuildConfig.GRAPHQL_BASE_URL
	static let GRAPHQL_ENDPOINT = BuildConfig.GRAPHQL_ENDPOINT
	static let CODE_204 = "code_204"

	static let HEADER_GRAPHQL = BuildConfig.HEADER_GRAPHQL
	
	static let NEW_LINE_CHARACTER = "\r\n"
	
	static let ATZ = "ATZ"
	static let ATE0 = "ATE0"
	static let ATS0 = "ATS0"
	static let ATSP = "ATSP"
	static let ATSH = "ATSH"

	static let ATFCSH = "ATFCSH"
	static let ATFCSD = "ATFCSD"
	static let ATFCSM1 = "ATFCSM1"
	static let FF = "FF"
	static let SEVEN_F = "7F"
	static let SEVEN_FFF = "7FFF"
	static let ALL_F = "FFFF"
	static let NO_DATA = "NO DATA"
	static let OK = "OK"
	
	static let DELAY_BETWEEN_COMMANDS = 50
	/**
	 * Default protocol value.
	 */
	static let DEFAULT_PROTOCOL = "6"
	
	static let CARET = ">"
	static let QUESTION_MARK = "?"
	static let NODATA = "NODATA"
	static let ERROR = "ERROR"
	
	static let FILE_TYPE = ".json"
	static let ACELITE_TEST = "AceLite_Test"

	func currentDateTime() -> String {
		let dateFormatter : DateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let date = Date()
		let dateString = dateFormatter.string(from: date)
		return dateString
	}
}
