//
//  Commands.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 2/9/23.
//

import Foundation
class DataManager {
static let shared = DataManager()
	
enum BLECommand {
	case ATZ
	case ATE0
	case ATS0
	case ATSP
	case ODOMETER_HEADER
	case ODOMETER_PID	
	case STATE_OF_CHARGE_FLOW_HEADER
	case STATE_OF_CHARGE_FLOW_DATA
	case ENERGY_TO_EMPTY
	case BMS_CAPACITY
	case PACK_TEMPERATURE
	case PACK_VOLTAGE
	case PACK_CURRENT
	case CELL_VOLTAGE
	case BATTERY_AGE
	case DIAGNOSTIC_SESSION
	case MISC_COMMANDS
	case NONE
}

	struct TestCommandCustom {
	//let protocols
	let commandType: CommandType
	let challenge: TestCommandChallenge?
	let response: TestCommandResponse?
	let validation: TestCommandValidation?
	//var protocol: TestCommandProtocol? = null,
//	var index: Int = 0,
//	var label: String? = null,
//	var deviceRawResponse: String? = null,
//	var numberOfTimesExecuted: Int = 0,
//	var batteryTestInstructionsSet: Int = 0,
//	var isHeaderCommandCompleted: Boolean = false,
//	var isFlowControlHeaderCompleted: Boolean = false,
//	var isFlowControlDataCompleted: Boolean = false,
//	var isFlowControlNormalCommandCompleted: Boolean = false,
//	var deviceByteArray: ByteArray? = null,
//	var commandDetails: CommandDetails? = null
}

enum CommandType {
	case ODOMETER
	case STATE_OF_CHARGE
//	case ENERGY_TO_EMPTY
//	case BMS_CAPACITY
//	case PACK_TEMPERATURE
//	case PACK_VOLTAGE
//	case PACK_CURRENT
//	case CELL_VOLTAGE
//	case BATTERY_AGE
//	case DIAGNOSTIC_SESSION
//	case MISC_COMMANDS
	
	var description: String {
	 get {
		 switch self {
		 case .ODOMETER:
			 return "odometer"
		 case .STATE_OF_CHARGE:
			 return "stateOfCharge"
//		 case .List:
//			 return "Station List"
//		 case .Specific(let stationNumber):
//			 return "Station #\(stationNumber)"
		 }
	 }
	 }
}

struct TestCommandChallenge {
	let header: String?
	let pid: String?
	let isFlowControlAvailable: Bool
	let flowControlData: String?
	let flowControlHeader: String?
}


	struct TestCommandResponse {
	let startByte: Int?
	let endByte: Int?
	let multiplier: Float?
	let constant: Double?
	let numberOfCells: Int?
	let bytesPerCell: Int?
	let startCellCount: Int?
	let endCellCount: Int?
	let bytesPaddedBetweenCells: Int?
	let multiplierComment: String?
	let numberOfSensors: Int?
	let bytesPerSensors: Int?
	let startSensorsCount: Int?
	let endSensorsCount: Int?
	let bytesPaddedBetweenSensors: Int?
}

struct TestCommandValidation {
	let numberOfFrames: Int?
	let lowerBounds: Float?
	let upperBounds: Float?
}

enum InstructionType: CaseIterable {
	case FLOW_CONTROL_HEADER
	case FLOW_CONTROL_DATA
	case FLOW_CONTROL_NORMAL_COMMAND
	case HEADER
	case PID
	case NONE
	var description: String {
		get {
			switch self {				
			case .FLOW_CONTROL_HEADER:
				return "FLOW_CONTROL_HEADER"
			case .FLOW_CONTROL_DATA:
				return "FLOW_CONTROL_DATA"
			case .FLOW_CONTROL_NORMAL_COMMAND:
				return "FLOW_CONTROL_NORMAL_COMMAND"
			case .HEADER:
				return "FLOW_HEADER"
			case .PID:
				return "FLOW_PID"
			case .NONE:
				return ""
			}
		}
	}
}
	

}

enum CommandType: CaseIterable {
	case ODOMETER
	case STATEOFCHARGE
	case ENERGY_TO_EMPTY
	case BMS_CAPACITY
	case PACK_TEMPERATURE
	case PACK_VOLTAGE
	case PACK_CURRENT
	case CELL_VOLTAGE
	case BATTERY_AGE
	case DIAGNOSTIC_SESSION
	case MISC_COMMANDS
	case Other
	
	var description: String {
	 get {
		 switch self {
		 case .ODOMETER:
			 return "odometer"
		 case .STATEOFCHARGE:
			 return "stateOfCharge"
		 case .ENERGY_TO_EMPTY:
			 return "energyToEmpty"
		 case .BMS_CAPACITY:
			 return "bmsCapacity"
		 case .PACK_TEMPERATURE:
			 return "packTemperature"
		 case .PACK_VOLTAGE:
			 return "packVoltage"
		 case .PACK_CURRENT:
			 return "packCurrent"
		 case .CELL_VOLTAGE:
			 return "cellVoltage"
		 case .BATTERY_AGE:
			 return ""
		 case .DIAGNOSTIC_SESSION:
			 return "diagnosticSession"
		 case .MISC_COMMANDS:
			 return ""
		 case .Other:
			 return ""
		 }
	 }
	 }
}

enum InstructionType: CaseIterable {
	case FLOW_CONTROL_HEADER
	case FLOW_CONTROL_DATA
	case FLOW_CONTROL_NORMAL_COMMAND
	case HEADER
	case PID
	case NONE
	var description: String {
		get {
			switch self {
			case .FLOW_CONTROL_HEADER:
				return "FLOW_CONTROL_HEADER"
			case .FLOW_CONTROL_DATA:
				return "FLOW_CONTROL_DATA"
			case .FLOW_CONTROL_NORMAL_COMMAND:
				return "FLOW_CONTROL_NORMAL_COMMAND"
			case .HEADER:
				return "FLOW_HEADER"
			case .PID:
				return "FLOW_PID"
			case .NONE:
				return ""
			}
		}
	}
}
	

class TestCommandExecution {

	var type: CommandType = .Other
	var resProtocol : ProtocolClass?
	var challenge: Challenge?
	var response: OdometerResponse?
	var validation: Validation?
	var deviceReponse: String = ""
	var reqeustByteInString: String = ""
	var isFlowController: Bool = false
	var deviceByteArray = [UInt8]()
	var deviceData: Data?
	var instructionType: InstructionType = .NONE
	
	init(type: CommandType, resProtocal: ProtocolClass, challenge: Challenge, response: OdometerResponse, validation: Validation) {
		self.type = type
		self.resProtocol = resProtocal
		self.challenge = challenge
		self.response = response
		self.validation = validation
		if challenge.flowControl != nil {
			self.isFlowController = true
		}
	}
	
}

class TestCommandDiagnosticExecution {

	var type: CommandType?
	var resProtocol : ProtocolClass?
	var challenge: DiagnosticSessionChallenge?
	var deviceByteArray = [UInt8]()
	
	init(type: CommandType, resProtocal: ProtocolClass, challenge: DiagnosticSessionChallenge) {
		self.type = type
		self.resProtocol = resProtocal
		self.challenge = challenge
	}
}

