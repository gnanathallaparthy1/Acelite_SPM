//
//  FirebaseConstants.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 5/4/23.
//

import Foundation

struct UserProperty {
	let productType = "product_type"
	let flowType = "flow_type"
}

struct ClassNames {
	static let obdiConnect = "obdi_connect"
	static let bluetoothScan = "bluetooth_scan"
	static let enterVin = "enter_vin"
	static let vehicleInformation = "vehicle_information"
	static let workOrder = "work_order"
	static let testInstructions = "test_instructions"
	static let confirmation = "confirmation"
	static let scanHistory = "scan_history"
	static let testableModels = "testable_models"
}

struct BluetoothScreenEvents {
	static let bleScanStart = "ble_scan_start"
	static let bleScanStop = "ble_scan_stop"
	static let bleDeniedPermission = "ble_denied_permission"
	static let bleConnect = "ble_connect"
	static let bleTest = "ble_test"
	static let bleDisconnect = "ble_disconnect"
	static let bleConnectionSuccess = "ble_connection_success"
	static let bleConnectionFailure = "ble_connection_failure"
}

struct EnterVinScreenEvents {
	static let vinScanner = "vin_scanner"
	static let vehicleInfoSuccess = "vehicle_info_success"
	static let vehicleInfoError = "vehicle_info_error"
}

struct WorkOrderScreenEvents {
	static let workOrderScanner = "work_order_scanner"
	static let workOrderInput = "work_order_input"
	
}

struct TestInstructionsScreenEvents {
	static let instructionsStep1Started = "instructions_step_1_started"
	static let instructionsStep2Started = "instructions_step_2_started"
	static let instructionsStep3Started = "instructions_step_3_started"
	static let s3PreSignedUrlError = "s3_pre_signed_url_error"
	static let s3PreSignedUrlSuccess = "s3_pre_signed_url_success"
	static let uploadFileSuccess = "upload_file_success"
	static let uploadFileError = "upload_file_error"
	static let submitBatteryFilesSuccess = "submit_battery_files_success"
	static let submitBatteryFilesError = "submit_battery_files_error"
	
}

struct ConfirmationScreenEvents {
	static let confirmation = "confirmation"
}

struct Parameters {
	static let score = "score"
	static let batteryTestInstructionsId = "batter_test_instructions_id"
	static let submitType = "submit_type"
	static let errorCode = "error_code"
	static let fileType = "file_type"
	static let vinNumber = "vin_number"
	static let error = "error"
	static let workOrder = "work_order"
}
struct UserProperties {
	static let productType = "product_type"
	static let flowType = "flow_type"
}
