//
//  OfflineViewModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 10/11/23.
//

import Foundation

enum SubmitApiResponse: String, CaseIterable {
	
	case CURRENT_CAPACITY_GT_CAPACITY_AT_BIRTH
	case CURRENT_ENERGY_GT_ENERGY_AT_BIRTH
	case INVALID_INSTRUCTION_SET_ID
	case MISSING_REQUIRED_FILENAME
	case NO_DISCHARGE_DETECTED
	case OUT_OF_BOUNDS_STATE_OF_CHARGE
	case SOC_OR_BMS_CAPACITY_REQUIRED
	case BLUETOOTH_CLASSIC
	case NONE
	
	var message: String {
		get {
			switch self {
			case .CURRENT_CAPACITY_GT_CAPACITY_AT_BIRTH:
				return "This vehicle is showing a battery capacity at a higher value than at the vehicle's manufacturing specs. Please alert battery health support of this vehicle's year, make, model, and trim - EVB_support@coxautoinc.com. \n Please proceed onto testing other vehicles."
			case .CURRENT_ENERGY_GT_ENERGY_AT_BIRTH:
				return "This vehicle is showing a battery energy level at a higher value than at the vehicle's manufacturing specs. Please alert battery health support of this vehicle's year, make, model, and trim - EVB_support@coxautoinc.com.\n Please proceed onto testing other vehicles."
			case .INVALID_INSTRUCTION_SET_ID:
				return "Data uploaded shows an invalid instruction set ID. \n Please alert battery health support of this vehicle's year, make, model, and trim - EVB_support@coxautoinc.com."
			case .MISSING_REQUIRED_FILENAME:
				return "Data uploaded shows a missing required file name.\n Please alert battery health support of this vehicle's year, make, model, and trim - EVB_support@coxautoinc.com."
			case .NO_DISCHARGE_DETECTED:
				return "Discharge and neutral battery states not detected. Please retry test ensuring that you are following on-screen instructions regarding climate control ON/OFF states. \nIf this issue persists after following testing procedures closely, please reach out to EVB_support@coxautoinc.com for assistance."
			case .OUT_OF_BOUNDS_STATE_OF_CHARGE:
				return "This vehicle's battery is reading at an invalid state of charge. Please alert battery health support of this vehicle's year, make, model, and trim - EVB_support@coxautoinc.com."
			case .SOC_OR_BMS_CAPACITY_REQUIRED:
				return "SOC_OR_BMS_CAPACITY_REQUIRED"
			case .BLUETOOTH_CLASSIC:
				return "blc"
			case .NONE:
				return ""
			
			}
		}
	}
	
}


class OfflineViewModel {
	
	var submitApiResponse = SubmitApiResponse.NONE
	init(submitApiResponse: SubmitApiResponse = SubmitApiResponse.NONE) {

		self.submitApiResponse = submitApiResponse
	}
	
}
