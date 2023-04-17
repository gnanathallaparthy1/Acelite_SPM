//
//  BatteryHealthCheckViewModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/13/23.
//

import Foundation
import UIKit


protocol GetPreSignedUrlDelegate: AnyObject {
	func getTransactionIdInfo(viewModel: BatteryHealthCheckViewModel)
	func handleErrorTransactionID()
	func navigateToAnimationVC()
}

protocol UploadAndSubmitDataDelegate: AnyObject {
	func navigateToHealthScoreVC()
}

class BatteryHealthCheckViewModel {
	
	private var elm327ProtocolPreset: String?
	
	public var isTimeInProgress: Bool = true {
		didSet {
			self.stopTimer()
		}
		willSet {

		}
	}
	
	private var isDiagnosticSession: Bool = false
	
//	public var isLoopingTimeInProgress: Bool = false {
//		didSet {
//			self.stopTimer()
//		}
//		willSet {
//	
//		}
//	}
	private var normalCommandsList = [TestCommandExecution]()
	private var normalCommandsIndex = 0
	
	public var sampledCommandsList = [TestCommandExecution]()
	public var diagnosticCommand: TestCommandDiagnosticExecution?
	public var commandToRunInLoopIndex: Int = 0
	private var numberOfCellsProvided = 0
	
	private var cellVoltageList : Any?
	
	private var totalNumberOfPidCommandsRan = 0
	private var numberOfLogicsParsed = 0
	
	private var instructionTypeIndex: Int = 0
	private var testCommands: TestCommands?
	public var vehicleInfo: Vehicle?
	//var testCommand: TestCommand?
	var delegate:BleWriteReadProtocal?
	let commadQueue = DispatchQueue(label: "serial")
	public var packVoltageData = [Double]()
	public var packCurrentData = [Double]()
	public var packTemperatureData = [Double]()
	public var cellVoltageData = [Double]()
	public var stateOfCharge: Double?
	public var bms: Double?
	private var odometer: Double?
	private var transactionId: String?
	weak var preSignedDelegate: GetPreSignedUrlDelegate? = nil
	weak var uploadAndSubmitDelegate: UploadAndSubmitDataDelegate? = nil
	
	
	//var bleService = BluetoothServices()
	
	let dispatchGroup = DispatchGroup()
	var loopCount: Int = -1
	var preSignedData: GetS3PreSingedURL?
	var csvDispatchGroup = DispatchGroup()
	var countLoopCommand: Int = 0
	// Txt file variable
	
	var textCommands = ""
	var runLoopCommandIndex: Int = 0
	
	//Flowcontrol
	private var previousFlowControlHeader: String? = nil
	private var previousFlowControlData: String? = nil
	
	init(vehicleInfo: Vehicle) {
		self.vehicleInfo = vehicleInfo
	}
	
	
	private func stopTimer() {
		if self.isTimeInProgress == false {
			self.runCommandThatNeedToRunInLoop()
			
		}
	}
	
	public func handleInstructions() {
		guard let testCommand = self.vehicleInfo?.getBatteryTestInstructions, testCommand.count > 0 else {
			return
		}
		for command in testCommand {
			let odometer = command.testCommands?.odometer
			
			let commandCalss = TestCommandExecution(type: .ODOMETER , resProtocal: (odometer?.odometerProtocol)!, challenge: (odometer?.challenge)!, response: odometer!.response, validation: odometer!.validation)
			
			normalCommandsList.append(commandCalss)
			
			
			let stateOfCharge = command.testCommands?.stateOfHealthCommands?.stateOfCharge
			let bms = command.testCommands?.stateOfHealthCommands?.bmsCapacity
			if let elmProtocol  = stateOfCharge?.odometerProtocol, let chal = stateOfCharge?.challenge, let res = stateOfCharge?.response, let val = stateOfCharge?.validation {
				let stateOfChargeCommands = TestCommandExecution(type: .STATEOFCHARGE , resProtocal: elmProtocol, challenge: chal, response: res, validation: val)
				normalCommandsList.append(stateOfChargeCommands)
			}
			
			if let elmProtocol  = bms?.odometerProtocol, let chal = bms?.challenge, let res = bms?.response, let val = bms?.validation {
				
				let bmsComands = TestCommandExecution(type: .BMS_CAPACITY , resProtocal: elmProtocol, challenge: chal, response: res, validation: val)
				normalCommandsList.append(bmsComands)
			}
			
			let diagnosticSession = command.testCommands?.diagnosticSession
			if let diaChal = diagnosticSession?.challenge, let pro = diagnosticSession?.diagnosticSessionProtocol {
				isDiagnosticSession = true
				let diagno = TestCommandDiagnosticExecution(type: .DIAGNOSTIC_SESSION, resProtocal: pro, challenge: diaChal)
				self.diagnosticCommand = diagno
				
			}
		
			if let sp = command.testCommands?.sampledCommands {
				//MARK: - PackVoltage
				let packVoltage = sp.packVoltage
				let packVoltageTestCommand = TestCommandExecution(type: .PACK_VOLTAGE, resProtocal: sp.sampledCommandsProtocol, challenge: (packVoltage.challenge)!, response: packVoltage.response, validation: packVoltage.validation)
				packVoltageTestCommand.reqeustByteInString = packVoltage.challenge?.pid ?? ""
				sampledCommandsList.append(packVoltageTestCommand)
				
				//MARK: - PackCurrent
				let packCurrent = sp.packCurrent
				let packCurrentTestCommand = TestCommandExecution(type: .PACK_CURRENT, resProtocal: sp.sampledCommandsProtocol, challenge: (packCurrent.challenge)!, response: packCurrent.response, validation: packCurrent.validation)
				packCurrentTestCommand.reqeustByteInString = packCurrent.challenge?.pid ?? ""
				sampledCommandsList.append(packCurrentTestCommand)
				
				//MARK: - PackTemparature
				let packTemparature = sp.packTemperature
				for item in packTemparature {
					let response = OdometerResponse(startByte: item.response.startByte, endByte: item.response.endByte, numberOfCells: 0, bytesPerCell: 0, startCellCount: 0, endCellCount: 0, bytesPaddedBetweenCells: 0, multiplier: Double(item.response.multiplier), constant: item.response.constant)
					
					//let response = OdometerResponse(startByte: item.response.startByte, endByte: item.response.endByte, multiplier: Double(item.response.multiplier), constant: Double(item.response.constant))
					
					let packTempTestCommand = TestCommandExecution(type: .PACK_TEMPERATURE, resProtocal: sp.sampledCommandsProtocol, challenge: item.challenge, response: response, validation: item.validation)
					packTempTestCommand.reqeustByteInString = item.challenge.pid
					sampledCommandsList.append(packTempTestCommand)
				}
				
				//MARK: - CellVoltage
				let cellVoltage = sp.cellVoltage
				for item in cellVoltage {
					let response = OdometerResponse(startByte: item.response.startByte, endByte: item.response.endByte, numberOfCells: item.response.numberOfCells, bytesPerCell: item.response.bytesPerCell, startCellCount: item.response.startCellCount, endCellCount: item.response.endCellCount, bytesPaddedBetweenCells: item.response.bytesPaddedBetweenCells, multiplier: Double(item.response.multiplier), constant: item.response.constant)
					//let response = OdometerResponse(startByte: item.response.startByte, endByte: item.response.endByte, multiplier: Double(item.response.multiplier), constant: Double(item.response.constant))
					let cellVoltageTestCommand = TestCommandExecution(type: .CELL_VOLTAGE, resProtocal: sp.sampledCommandsProtocol, challenge: item.challenge, response: response, validation: item.validation)
					cellVoltageTestCommand.reqeustByteInString = item.challenge.pid
					sampledCommandsList.append(cellVoltageTestCommand)
				}
				
			}
			cellVoltageList = command.testCommands?.sampledCommands.cellVoltage
			numberOfCellsProvided = cellVoltageList.debugDescription.count
		}
		
		geteELM327ProtocolPreset()
		initialCommand()
	}
	
	func geteELM327ProtocolPreset()  {
		guard let testCommand = vehicleInfo?.getBatteryTestInstructions, testCommand.count > 0 else {
			return
		}
		let testCommands = testCommand[0].testCommands
		
		guard let elm327ProtocolOdometer =
				testCommands?.odometer?.odometerProtocol?.elm327ProtocolPreset else {
			return
		}
		guard let elm327ProtoclStateChange = testCommands?.stateOfHealthCommands?.stateOfCharge?.odometerProtocol?.elm327ProtocolPreset else {
			return
		}
		guard let elm327Sampled = testCommands?.sampledCommands.sampledCommandsProtocol.elm327ProtocolPreset else { return
		}
		if elm327ProtocolOdometer.count > 0 {
			self.elm327ProtocolPreset = elm327ProtocolOdometer
			return
		} else if elm327ProtoclStateChange.count > 0 {
			self.elm327ProtocolPreset = elm327ProtoclStateChange
			return
		} else if elm327Sampled.count > 0 {
			self.elm327ProtocolPreset = elm327Sampled
			return
		} else {
			self.elm327ProtocolPreset = Constants.DEFAULT_PROTOCOL
		}
		
	}
	
	// Executing Commands
	private func initialCommand() {
		
		let ATZ_Command = Constants.ATZ + Constants.NEW_LINE_CHARACTER
		////print("Inital Commands", Date(), to: &logger)
		//print("about to perform ATZ command write", Date(), to: &logger)
		Network.shared.bluetoothService?.writeBytesData(data: ATZ_Command, completionHandler: { data in
			NSLog("Initial command Log........")
			self.runATE0Command()
		})
	}
	
	private func runATE0Command() {
		let ATE0_Command = Constants.ATE0 + Constants.NEW_LINE_CHARACTER
		//print("about to perform ATE0 command write", Date(), to: &logger)
		Network.shared.bluetoothService?.writeBytesData(data: ATE0_Command, completionHandler: { data in
			//self.generateTxtCommandLogs(data: data)
			NSLog("ATEO Log........")
			self.runATS0Command()
		})
	}
	
	private func runATS0Command() {
		let ATS0_Command =  Constants.ATS0 + Constants.NEW_LINE_CHARACTER
		//print("about to perform ATSO command write", Date(), to: &logger)
		Network.shared.bluetoothService?.writeBytesData(data: ATS0_Command, completionHandler: { data in
			NSLog("ATSO Log........")
			self.runProtocolCommand()
		})
	}
	
	private func runProtocolCommand() {
		let elmValue = elm327ProtocolPreset?.replacingOccurrences(of: "_", with: "")
		let ATSP_Command = Constants.ATSP + "\(elmValue ?? Constants.DEFAULT_PROTOCOL)" + Constants.NEW_LINE_CHARACTER
		//print("about to perform ATSP command write", Date(), to: &logger)
		Network.shared.bluetoothService?.writeBytesData(data: ATSP_Command, completionHandler: { data in
			NSLog("Protocol Log........")
			if self.isDiagnosticSession == true {
				self.runDiagnosticCommand()
			}
			self.runNormalCommands()
		})
	}
	
	// MARK: - Normal Commands
	private func runDiagnosticCommand() {
//		NSLog("Normal Log........")
//		let totalNumberOfCommands = normalCommandsList.count
//		if (isTimeInProgress) {
//			if (normalCommandsIndex < totalNumberOfCommands) {
//				let command = normalCommandsList[normalCommandsIndex]
//				self.runTheCommand(indexValue: normalCommandsIndex, testCommand: command) { command in
//					self.parseResponse(testCommand: command, index: self.normalCommandsIndex)
//					if (self.normalCommandsIndex == totalNumberOfCommands - 1){
//						self.runCommandThatNeedToRunInLoop()
//					} else {
//						self.normalCommandsIndex += 1
//						self.runNormalCommands()
//					}
//				}
//			}
//		}
		if let header = diagnosticCommand?.challenge?.header {
			guard let pid = diagnosticCommand?.challenge?.pid else { return }
			let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
			Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
				let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
				Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data1 in
					//onCompletion!(testCommand)
				})
			})
			
		}
		
	}

	private func runNormalCommands() {
		NSLog("Normal Log........")
		let totalNumberOfCommands = normalCommandsList.count
		if (isTimeInProgress) {
			if (normalCommandsIndex < totalNumberOfCommands) {
				let command = normalCommandsList[normalCommandsIndex]
				self.runTheCommand(indexValue: normalCommandsIndex, testCommand: command) { command in
					self.parseResponse(testCommand: command, index: self.normalCommandsIndex)
					if (self.normalCommandsIndex == totalNumberOfCommands - 1){
						self.runCommandThatNeedToRunInLoop()
					} else {
						self.normalCommandsIndex += 1
						self.runNormalCommands()
					}
				}
			}
		}
	}
	
	private func runTheCommand(indexValue: Int, testCommand: TestCommandExecution, onCompletion: ((_ command : TestCommandExecution?) -> ())?) {
		//Network.shared.byteDataArray.removeAll()
		switch testCommand.type {
		case .ODOMETER:
			if let flowControl = testCommand.challenge?.flowControl {
				self.runFlowControlHeaderAndData(flowControl: flowControl, testCommand: testCommand) { command in
					if let header = testCommand.challenge?.header {
						guard let pid = testCommand.challenge?.pid else { return }
						let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
						Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
							let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
							Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data1 in
								testCommand.deviceReponse = data1
								NSLog("Odomoter Log........")
								//print("\(Constants().currentDateTime()):Odometer Data: \(data)", to: &logger)
								onCompletion!(testCommand)
							})
						})
						
					}
				}
			} else {
				if let header = testCommand.challenge?.header {
					guard let pid = testCommand.challenge?.pid else { return }
					let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
					Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
						let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
						Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data1 in
							testCommand.deviceReponse = data1
							//print("\(Constants().currentDateTime()):Odometer Data: \(data)", to: &logger)
							onCompletion!(testCommand)
						})
					})
					
				}
			}
			
		case .STATEOFCHARGE:
			//TODO Handle Flow Comtrol Data
			if let flowControl = testCommand.challenge?.flowControl {
				self.runFlowControlHeaderAndData(flowControl: flowControl, testCommand: testCommand) { command in
					if let header = testCommand.challenge?.header {
						guard let pid = testCommand.challenge?.pid else { return }
						let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
						Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
							let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
								Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data1 in
									testCommand.deviceReponse = data1
									
									onCompletion!(testCommand)
								})
							})
						})
					}
				}
			} else {
				
				if let header = testCommand.challenge?.header {
					guard let pid = testCommand.challenge?.pid else { return }
					let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
					Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
						let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
							Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data1 in
								testCommand.deviceReponse = data1
								
								onCompletion!(testCommand)
							})
						})
					})
				}
			}
			
			
		case .ENERGY_TO_EMPTY:
			//todod
			break
		case .BMS_CAPACITY:
			//todo
			// flowcontrol
			if let flowControl = testCommand.challenge?.flowControl {
				self.runFlowControlHeaderAndData(flowControl: flowControl, testCommand: testCommand) { command in
					//onCompletion!(testCommand)
					print("Flow-control-bms capacity completion")
					if let header = testCommand.challenge?.header {
						guard let pid = testCommand.challenge?.pid else { return }
						let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
							Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
								let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
									//sleep(2)
									Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
										testCommand.deviceReponse = data
										//print("\(Constants().currentDateTime()):BMS Data: \(data)", to: &logger)
										onCompletion!(testCommand)
									})
								})
							})
						})
					}
				}
			} else {
				if let header = testCommand.challenge?.header {
					guard let pid = testCommand.challenge?.pid else { return }
					let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
						Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
							let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
								//sleep(2)
								Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
									testCommand.deviceReponse = data
									//print("\(Constants().currentDateTime()):BMS Data: \(data)", to: &logger)
									onCompletion!(testCommand)
								})
							})
						})
					})
				}
			}
			
			
			break
		case .PACK_TEMPERATURE:
			// flowcontrol
			
			if let flowControl = testCommand.challenge?.flowControl {
				self.runFlowControlHeaderAndData(flowControl: flowControl, testCommand: testCommand) { command in
					//onCompletion!(testCommand)
					//print("Flow-control-pack_temperature completion")
					if let header = testCommand.challenge?.header {
						guard let pid = testCommand.challenge?.pid else { return }
						let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
							Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
								let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
								Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
									testCommand.deviceReponse = data
									//print("\(Constants().currentDateTime()):Pack temperature Data: \(data)", to: &logger)
									onCompletion!(testCommand)
								})
							})
						})
					}
				}
			} else {
				if let header = testCommand.challenge?.header {
					guard let pid = testCommand.challenge?.pid else { return }
					let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
						Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
							let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
							Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
								testCommand.deviceReponse = data
								//print("\(Constants().currentDateTime()):Pack temperature Data: \(data)", to: &logger)
								onCompletion!(testCommand)
							})
						})
					})
				}
			}
			break
		case .PACK_VOLTAGE:
			// flowcontrol
			if let flowControl = testCommand.challenge?.flowControl {
				self.runFlowControlHeaderAndData(flowControl: flowControl, testCommand: testCommand) { command in
					//onCompletion!(testCommand)
					print("Flow-control-pack_voltage completion")
					if let header = testCommand.challenge?.header {
						guard let pid = testCommand.challenge?.pid else { return }
						let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
							Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
								let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
								print("Pack Voltage pid", odometerPIDCommand)
								//self.generateTxtCommandLogs(data: "Pack Voltage PID: \(odometerPIDCommand)")
								Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
									testCommand.deviceReponse = data
									////print("\(Constants().currentDateTime()):Pack Voltage Data: \(data)", to: &logger)
									onCompletion!(testCommand)
								})
							})
						})
					}
				}
			} else {
				if let header = testCommand.challenge?.header {
					guard let pid = testCommand.challenge?.pid else { return }
					let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
					print("Pack Voltage header", ATSHOdometer_Command)
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
						Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
							let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
							print("Pack Voltage pid", odometerPIDCommand)
							//self.generateTxtCommandLogs(data: "Pack Voltage PID: \(odometerPIDCommand)")
							Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
								testCommand.deviceReponse = data
								////print("\(Constants().currentDateTime()):Pack Voltage Data: \(data)", to: &logger)
								onCompletion!(testCommand)
							})
						})
					})
				}
			}
			
			
			
			break
		case .PACK_CURRENT:
			// flowcontrol
			if let flowControl = testCommand.challenge?.flowControl {
				self.runFlowControlHeaderAndData(flowControl: flowControl, testCommand: testCommand) { command in
					//onCompletion!(testCommand)
					print("Flow-control-pack_current completion")
					if let header = testCommand.challenge?.header {
						guard let pid = testCommand.challenge?.pid else { return }
						let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
						print("Pack current header", ATSHOdometer_Command)
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
							Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
								let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
								print("Pack current pid", odometerPIDCommand)
								Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
									testCommand.deviceReponse = data
									////print("\(Constants().currentDateTime()):Pack Current Data: \(data)", to: &logger)
									onCompletion!(testCommand)
								})
							})
						})
					}
				}
			} else {
				if let header = testCommand.challenge?.header {
					guard let pid = testCommand.challenge?.pid else { return }
					let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
					print("Pack current header", ATSHOdometer_Command)
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
						Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
							let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
							print("Pack current pid", odometerPIDCommand)
							Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
								testCommand.deviceReponse = data
								////print("\(Constants().currentDateTime()):Pack Current Data: \(data)", to: &logger)
								onCompletion!(testCommand)
							})
						})
					})
				}
				
			}
			
			
			
			break
		case .CELL_VOLTAGE:
			// flowcontrol
			
			if let flowControl = testCommand.challenge?.flowControl {
				self.runFlowControlHeaderAndData(flowControl: flowControl, testCommand: testCommand) { command in
					//onCompletion!(testCommand)
					print("Flow-control-cell_voltage completion")
					if let header = testCommand.challenge?.header {
						guard let pid = testCommand.challenge?.pid else { return }
						let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
						print("Cell voltage header",ATSHOdometer_Command )
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
							Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
								let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
								print("Cell voltage pid", odometerPIDCommand)
								Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
									testCommand.deviceReponse = data
									onCompletion!(testCommand)
								})
							})
						})
					}
				}
			} else {
				if let header = testCommand.challenge?.header {
					guard let pid = testCommand.challenge?.pid else { return }
					let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
					print("Cell voltage header",ATSHOdometer_Command )
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
						Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
							let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
							print("Cell voltage pid", odometerPIDCommand)
							
							Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
								testCommand.deviceReponse = data
								////print("\(Constants().currentDateTime()):Cell Voltage Data: \(data)", to: &logger)
								onCompletion!(testCommand)
							})
						})
					})
				}
			}
			
			break
		case .BATTERY_AGE:
			break
		case .DIAGNOSTIC_SESSION:
			break
		case .MISC_COMMANDS:
			break
		case .none:
			break
		case .Other:
			break
		}
	}
	
	private func runFlowControlHeaderAndData(flowControl: FlowControl, testCommand: TestCommandExecution , onCompletion: ((_ command : TestCommandExecution?) -> ())?) {
		var isFlowControlChanged: Bool = false
		
//		if previousFlowControlHeader != flowControl.flowControlHeader {
			isFlowControlChanged = true
			previousFlowControlHeader = flowControl.flowControlHeader
			print("flow control commands")
			let flowcontrolHeader = Constants.ATFCSH + flowControl.flowControlHeader! + Constants.NEW_LINE_CHARACTER
			print("flow Control header", flowcontrolHeader)
			Network.shared.bluetoothService?.writeBytesData(data: flowcontrolHeader, completionHandler: { data in
//				if self.previousFlowControlData != flowControl.flowControlData {
					print("flow control data")
					isFlowControlChanged = true
					self.previousFlowControlData = flowControl.flowControlData
					let flowControlData = Constants.ATFCSD + flowControl.flowControlData! + Constants.NEW_LINE_CHARACTER
					print("flow control data command", flowControlData)
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
						Network.shared.bluetoothService?.writeBytesData(data: flowControlData, completionHandler: { data in
							if isFlowControlChanged {
								let flowControlChangedCommand = Constants.ATFCSM1 + Constants.NEW_LINE_CHARACTER
								print("Flow control change", flowControlChangedCommand)
								Network.shared.bluetoothService?.writeBytesData(data: flowControlChangedCommand, completionHandler: { data in
									onCompletion!(testCommand)
								})
							} else {
								onCompletion!(testCommand)
							}
						})
					})
//				}
			})
//		} else {
//			onCompletion!(testCommand)
//		}
//		else {
//
//
//				self.previousFlowControlData = flowControl.flowControlData
//				let flowControlData = Constants.ATFCSD + flowControl.flowControlData! + Constants.NEW_LINE_CHARACTER
//				Network.shared.bluetoothService?.writeBytesData(data: flowControlData, completionHandler: { data in
//					testCommand.deviceReponse = data
//					if isFlowControlChanged {
//						let flowControlChangedCommand = Constants.ATFCSM1 + Constants.NEW_LINE_CHARACTER
//						Network.shared.bluetoothService?.writeBytesData(data: flowControlChangedCommand, completionHandler: { data in
//							 onCompletion!(testCommand)
//						})
//					} else {
//						onCompletion!(testCommand)
//					}
//				})
//
//		}
	
	}
	private func isNewFlowControlCommand(flowControlChanged: Bool, testCommand: TestCommandExecution) {
		
	}
	
	private func runCommandThatNeedToRunInLoop() {
		let totalNumberOfCommands: Int = sampledCommandsList.count
		// to decide final completion
		if (isTimeInProgress == true) {
			//if isLoopingTimeInProgress == true {
				if (commandToRunInLoopIndex < totalNumberOfCommands) {
					let command = sampledCommandsList[commandToRunInLoopIndex]
					//self.countLoopCommand += 1
					////print("INDEX BEFORE RUN",commandToRunInLoopIndex)
					//DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
						self.runTheCommand(indexValue: self.commandToRunInLoopIndex, testCommand: command , onCompletion: { [self]command in
							self.totalNumberOfPidCommandsRan += 1
							self.parseResponse(testCommand: command, index: commandToRunInLoopIndex)
							if (self.commandToRunInLoopIndex == totalNumberOfCommands - 1) {
								self.numberOfLogicsParsed += 1
								////////print("NUMBER OF LOGICS RUN", self.numberOfLogicsParsed)
								self.commandToRunInLoopIndex  = 0
							} else {
								//if self.isLoopingTimeInProgress == true {
									self.commandToRunInLoopIndex += 1
								//}
								////////print("NUMBER PIDS IN LOOP RUN", self.commandToRunInLoopIndex)
							}
							////////print("GOOD ONE")
							//self.runLoopCommandIndex = self.commandToRunInLoopIndex
							self.runCommandThatNeedToRunInLoop()
						})
					//})
				}
//			}  else {
//				////print("ELSE  of isLoopingTimeInProgress:::", isLoopingTimeInProgress)
//				//self.commandToRunInLoopIndex = self.runLoopCommandIndex
//				////print("command index::in else conditon", self.commandToRunInLoopIndex)
//				return
//			}
			
		} else {
			// loopCount intial value -1 , delay 25sec , prepare CSV fiels
			//////print("TIME BOOL::: ELSE)", loopCount)
			if loopCount == -1 {
				//////print("TIME BOOL:::-runCommandThatNeedToRunInLoopEin ELSE\(Date().description)", isTimeInProgress)
				////print("*********BLE reponse is finished**********")
				self.preSignedDelegate?.navigateToAnimationVC()
				DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
					self.uploadAndSubmitDelegate?.navigateToHealthScoreVC()
				}
			}
			loopCount += 1
		}
	}
	
	private func parseResponse(testCommand: TestCommandExecution?, index: Int) {
		guard let reponseData = testCommand?.deviceReponse, reponseData.count > 0 else { return  }
		if reponseData.contains(Constants.QUESTION_MARK) || reponseData.contains(Constants.NODATA) || reponseData.contains(Constants.NO_DATA) || reponseData.contains(Constants.ERROR) {
			return
		}
		
		switch testCommand?.type {
		case .ODOMETER:
			if let _ = testCommand?.challenge?.flowControl {
				print("::::::::::Multi frame::::::")
				let odometerMulVal = self.handlingMultiframeString(testCommand: testCommand)
			print("Odometer value",odometerMulVal)
			}else {
				print(":::::::Single Frame::::::::")
				if testCommand?.deviceReponse != nil {
					let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
					if haxValueList.count > 0 {
						let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
						self.odometer = value
					}
				}
			}
			break
		case .STATEOFCHARGE:
			if let _ = testCommand?.challenge?.flowControl {
			
			}else {
				if testCommand?.deviceReponse != nil {
					let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
					if haxValueList.count > 0 {
						let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
						self.stateOfCharge = value
					}
				}
			}
			break
		case .ENERGY_TO_EMPTY:
			if let _ = testCommand?.challenge?.flowControl {
				
			}else {
				if testCommand?.deviceReponse != nil {
					let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
					if haxValueList.count > 0 {
						let _ = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
					}
				}
			}
			break
		case .BMS_CAPACITY:
			if let _ = testCommand?.challenge?.flowControl {

			}else {
				if testCommand?.deviceReponse != nil {
					let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
					if haxValueList.count > 0 {
						let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
						self.bms = value
					}
				}
			}
			break
		case .PACK_TEMPERATURE:
			if let _ = testCommand?.challenge?.flowControl {
				let packTemp = self.processDataAndGetFinalHexValues(testCommand: testCommand)
				
			}else {
				if testCommand?.deviceReponse != nil {
					let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
					if haxValueList.count > 0 {
						let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
						packTemperatureData.append(value)
					}
				}
			}
			break
		case .PACK_VOLTAGE:
			if let _ = testCommand?.challenge?.flowControl {
				let packVoltage = self.processDataAndGetFinalHexValues(testCommand: testCommand)
			}else {
				if testCommand?.deviceReponse != nil {
					let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
					if haxValueList.count > 0 {
						let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
						packVoltageData.append(value)
					}
				}
			}
			break
		case .PACK_CURRENT:
			if let _ = testCommand?.challenge?.flowControl {
				let packCurrent = self.processDataAndGetFinalHexValues(testCommand: testCommand)
			} else {
				if testCommand?.deviceReponse != nil {
					guard let packCurrent = testCommand?.deviceReponse, packCurrent.count > 0   else { return  }
					let finalStringBytes = typeCastingByteToString(testCommand: testCommand)
					let startByte = testCommand?.response?.startByte ?? 0
					let endByte = testCommand?.response?.endByte ?? 0
					let numberOfBytesDifference = endByte - startByte
					let haxValue = findFinalHexValue(haxVal: finalStringBytes, startByete: testCommand?.response?.startByte ?? 0, endByte: testCommand?.response?.endByte ?? 0)
					let decimalValue = fromHaxToDecimal(haxValue: haxValue)
					var comparisonValue = ""
					if (numberOfBytesDifference == 0) {
						comparisonValue = Constants.SEVEN_F
					} else {
						comparisonValue =
						Constants.SEVEN_F.padding(toLength: ((numberOfBytesDifference + 1) * 2), withPad: "F", startingAt: 0)
					}
					let multiplier = testCommand?.response?.multiplier ?? 1.0
					var packCurrentValue = 0.0
					
					if (decimalValue < fromHaxToDecimal(haxValue: comparisonValue)) {
						packCurrentValue = Double(decimalValue) * multiplier * -1
					} else {
						var valueFromWhichToSubtract = ""
						if (numberOfBytesDifference == 0) {
							valueFromWhichToSubtract = Constants.FF
						} else {
							valueFromWhichToSubtract = Constants.FF.padding(toLength: ((numberOfBytesDifference + 1) * 2), withPad: "F", startingAt: 1)
						}
						packCurrentValue = Double((fromHaxToDecimal(haxValue: valueFromWhichToSubtract) - decimalValue)) * multiplier
						print("packCurrentValue::::", packCurrentValue)
					}
					
					let constantValue = testCommand?.response?.constant ?? 0
					let finalValue = packCurrentValue + Double(constantValue)
					print("finalValue-pack current", finalValue)
					packCurrentData.append(finalValue)
				}
			}
			break
		case .CELL_VOLTAGE:

			if let _ = testCommand?.challenge?.flowControl {
				print("::::::::::Multi frame::::::")
		let _ = self.handlingMultiframeString(testCommand: testCommand)
				
			} else {
				print("::::::::Single Frame::::::::::")
				if testCommand?.deviceReponse != nil {
					let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
					if haxValueList.count > 0 {
						let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
						print("Final value of cell voltage data", value)
						cellVoltageData.append(value)
					}
				}
			}
			break
		case .BATTERY_AGE:
			if let _ = testCommand?.challenge?.flowControl {
			
			}else {
				if testCommand?.deviceReponse != nil {
					let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
					if haxValueList.count > 0 {
						let _ = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
					}
				}
			}
			break
		case .DIAGNOSTIC_SESSION:
			if let _ = testCommand?.challenge?.flowControl {

			} else {
				if testCommand?.deviceReponse != nil {
					let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
					if haxValueList.count > 0 {
						let _ = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
					}
				}
			}
			break
		case .MISC_COMMANDS:
			if let _ = testCommand?.challenge?.flowControl {
				
			}else {
				if testCommand?.deviceReponse != nil {
					let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
					if haxValueList.count > 0 {
						let _ = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
					}
				}
			}
			break
		case .none:
			break
		case .Other:
			break
		}
	}
	
	
	func processDataAndGetFinalHexValues(testCommand: TestCommandExecution?) {
		if let deviceByteArray = testCommand?.deviceReponse, deviceByteArray.count > 0 {
			let startByte = testCommand?.response?.startByte ?? 0
			print("Start Byte", startByte)
			let endByte = testCommand?.response?.endByte ?? 0
			print("end byte", endByte)
			let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
			if (haxValueList.count - 1) < endByte {
				return
			}
			let haxValue = FlowfindFinalHexValue(haxVal: haxValueList, startByete: startByte, endByte: endByte)
			print("Final Byte Array:", haxValue)
			let chunkArray = haxValue.chunked(into: testCommand?.response?.bytesPerCell ?? 0)
			print("Divided in chunk", chunkArray)
		}
	}
	
	//MARK: - MultiFrame handling
	
	private func handlingMultiframeString(testCommand: TestCommandExecution?) -> [Double] {
	
		if let deviceByteArray = testCommand?.deviceReponse, deviceByteArray.count > 0 {
			let startByte = testCommand?.response?.startByte ?? 0
			print("Start Byte", startByte)
			let endByte = testCommand?.response?.endByte ?? 0
			print("end byte", endByte)
			let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
			let haxValue = FlowfindFinalHexValue(haxVal: haxValueList, startByete: startByte, endByte: endByte)
			print("Final Byte Array:", haxValue)
			let chunkArray = haxValue.chunked(into: testCommand?.response?.bytesPerCell ?? 0)
			print("Divided in chunk", chunkArray)
			
			let totalCells = testCommand?.response?.numberOfCells
			var finalValues = [Double]()
			if chunkArray.count == totalCells {
				for item in chunkArray {
					print("Each cheunk array:", item.joined())
					let finalByte = item.joined()
							let decimalValue = fromHaxToDecimal(haxValue: finalByte)
							print("decimal Value", decimalValue)
							let multiplierValue = Double(decimalValue) * (Double(testCommand?.response?.multiplier ?? 1.0))
							print("after multiplier : ", multiplierValue)
							let constantValue = testCommand?.response?.constant ?? 0
							let finalValue = multiplierValue + Double(constantValue)
							print("Calculated Value:", finalValue)
					finalValues.append(finalValue)
					cellVoltageData.append(finalValue)
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(finalValue)"
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
				}
			}
			return finalValues
		} else {
			return [0.0]
		}
	}
	
	
	//MARK: - Convert each byte as string (typecasting)
	private func typeCastingByteToString(testCommand: TestCommandExecution?) -> [String] {
		
		guard let finalData = testCommand?.deviceReponse  else { return [""] }
		let trimmed = finalData.trimmingCharacters(in: .whitespacesAndNewlines)
		//////print("trimmed", trimmed)
		let arrBytes = trimmed.replacingOccurrences(of: " ", with: "")
		return arrBytes.components(withMaxLength: 2)
	}
	
	
		
//		private func multiframeTypeCastingByteToString(testCommand: [UInt8]) -> String {
//			var joinString = ""
//			for item in testCommand {
//				joinString += "\(item)"
//			}
//
//			return joinString
//		}

	
	private func calculateValueFromStartEndByte(command: TestCommandExecution?, hexValuesList: [String]) -> Double {
		
		let haxValue = findFinalHexValue(haxVal: hexValuesList, startByete: command?.response?.startByte ?? 0, endByte: command?.response?.endByte ?? 0)
		//print("\(Constants().currentDateTime()):Calculated Hex Value for \(command?.type): \(haxValue))", to: &logger)
		let decimalValue = fromHaxToDecimal(haxValue: haxValue)
		//print("\(Constants().currentDateTime()):Calculated Decimal Value for \(command?.type): \(decimalValue))", to: &logger)
		let multiplierValue = Double(decimalValue) * (Double(command?.response?.multiplier ?? 1.0))
		//print("\(Constants().currentDateTime()):Multiplier Value for \(command?.type): \(multiplierValue))", to: &logger)
		let constantValue = command?.response?.constant ?? 0
		let finalValue = multiplierValue + Double(constantValue)
		//print("\(Constants().currentDateTime()):Final Value for \(command?.type): \(finalValue))", to: &logger)
		return finalValue
		
	}
	
	func findFinalHexValue(haxVal: [String], startByete: Int, endByte: Int) -> String {
		
		if haxVal.count - 1 < endByte {
			return ""
		}
		let rageArray = haxVal[startByete...endByte]
		let bytesInstring = rageArray.joined()
		return bytesInstring
	}
	
	func FlowfindFinalHexValue(haxVal: [String], startByete: Int, endByte: Int) -> [String] {
		
		let rageArray = haxVal[startByete...endByte]
		var arrayString = [String]()
		for item in rageArray {
			arrayString.append(item)
		}
		return arrayString
	}
	
	
	func fromHaxToDecimal(haxValue: String) -> Int {
		let decimalValue = Int(haxValue, radix: 16) ?? 0
		return decimalValue
	}
}

extension String {
	func components(withMaxLength length: Int) -> [String] {
		return stride(from: 0, to: self.count, by: length).map {
			let start = self.index(self.startIndex, offsetBy: $0)
			let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
			return String(self[start..<end])
		}
	}
}

extension Array {
	func chunked(into size: Int) -> [[Element]] {
		return stride(from: 0, to: count, by: size).map {
			Array(self[$0 ..< Swift.min($0 + size, count)])
		}
	}
}

extension Date {
	static var currentTimeStamp: Int64{
		return Int64(Date().timeIntervalSince1970 * 1000)
	}
}


