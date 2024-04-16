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
	static let ATCF = "ATCF"
	static let ATCM = "ATCM"

	static let ATFCSH = "ATFCSH"
	static let ATFCSD = "ATFCSD"
	static let ATFCSM1 = "ATFCSM1"
	static let FF = "FF"
	static let SEVEN_F = "7F"
	static let SEVEN_FFF = "7FFF"
	static let ALL_F = "FFFF"
	static let NO_DATA = "NO DATA"
	static let NO_DATA_R = "NO DATA\r\r>"
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
	static let OFFLINE_MESSAGE = "Looks like there is no internet connection. Please connect to Mobile data or Wifi."
	static let APP_UNSUBMITTED = "You have unsubmitted test results from running tests in offline mode."
	static let APP_RECONNECT_INTERNET_MESSAGE = "Internet connection is not available, but data will be retained and uploaded when connection is re-established."
	static let BATTERY_INSTRUCTIONS_DATA = "BatteryInstructionsData"
	static let BLUETOOTH_CLASSIC_STATE = "Bluetooth Classic device disconnected."
	
	static let BLUETOOTH_CLASSIC_MESSAGE = "Your Bluetooth Classic device has been disconnected. Clicking OK will take you to your device settings where your device connection can be re-established.\n\n"
	static let BLUETOOTH_CLASSIC_INSTRUCTION_MESSAGE = "After connecting, please close and re-launch the app for communication with device. "

	static let MAKE = "make"
	static let TRIM = "trim"
	static let MODEL = "model"
	static let VIN_NUMBER = "vinNumber"
	static let VIN_YEAR = "year"
	static let MID = "mid"
	
	static let DATE_TIME = "dateAndTime"
	static let FINAL_JSON_DATA = "finalJsonData"
	static let WORK_ORDER = "workOrder"
	static let VEHICAL = "vehical"
	static let BMS = "bms"
	static let STATE_OF_CHARGE = "stateOfCharge"
	static let ODOMETER = "odometer"
	static let BATTERY_INSTRUCTION_ID = "batteryInstructionId"
	static let CURRENT_ENERGY = "currentEnergy"
	static let NUMBER_OF_CELL = "numberOfCell"
	static let LOCATION_CODE = "locationCode"
	
	
	func currentDateTime() -> String {
		let dateFormatter : DateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let date = Date()
		let dateString = dateFormatter.string(from: date)
		return dateString
	}
}
