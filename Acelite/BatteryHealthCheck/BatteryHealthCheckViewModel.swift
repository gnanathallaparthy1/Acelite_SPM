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
	private var normalCommandsList = [TestCommandExecution]()
	private var normalCommandsIndex = 0
	public var sampledCommandsList = [TestCommandExecution]()
	public var commandToRunInLoopIndex: Int = 0
	private var numberOfCellsProvided = 0 // verify
	private var cellVoltageList : Any?
	private var totalNumberOfPidCommandsRan = 0 // verify
	private var numberOfLogicsParsed = 0  // verify
	private var isDiagnosticSession: Bool = false
	public var diagnosticCommand: TestCommandDiagnosticExecution?
	public var vehicleInfo: Vehicle?
	public var numberOfCells: Int?
	public var packVoltageData = [Double]()
	public var packCurrentData = [Double]()
	public var packTemperatureData = [Double]()
	public var cellVoltageData = [Double]()
	public var multiCellVoltageData = [[Double]]()
	public var stateOfCharge: Double?
	public var bms: Double?
	public var currentEnergy: Double?
	public var batteryTestInstructionId: String?
	private var odometer: Double?
	private var transactionId: String?
	weak var preSignedDelegate: GetPreSignedUrlDelegate? = nil
	weak var uploadAndSubmitDelegate: UploadAndSubmitDataDelegate? = nil
	var loopCount: Int = -1
 //   var preSignedData: GetS3PreSingedURL?
  //  var countLoopCommand: Int = 0
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
			self.batteryTestInstructionId = command.testCommands?.id
			let odometer = command.testCommands?.odometer
			
			let commandCalss = TestCommandExecution(type: .ODOMETER , resProtocal: (odometer?.odometerProtocol)!, challenge: (odometer?.challenge)!, response: odometer!.response, validation: odometer!.validation)
			normalCommandsList.append(commandCalss)
			let stateOfCharge = command.testCommands?.stateOfHealthCommands?.stateOfCharge
			let bms = command.testCommands?.stateOfHealthCommands?.bmsCapacity
			let energyToEmpty = command.testCommands?.stateOfHealthCommands?.energyToEmpty
			if let elmProtocol  = stateOfCharge?.odometerProtocol, let chal = stateOfCharge?.challenge, let res = stateOfCharge?.response, let val = stateOfCharge?.validation {
				let stateOfChargeCommands = TestCommandExecution(type: .STATEOFCHARGE , resProtocal: elmProtocol, challenge: chal, response: res, validation: val)
				normalCommandsList.append(stateOfChargeCommands)
			}
			
			if let elmProtocol  = bms?.odometerProtocol, let chal = bms?.challenge, let res = bms?.response, let val = bms?.validation {
				
				let bmsComands = TestCommandExecution(type: .BMS_CAPACITY , resProtocal: elmProtocol, challenge: chal, response: res, validation: val)
				normalCommandsList.append(bmsComands)
			}
			
			if let elmProtocol  = energyToEmpty?.odometerProtocol, let chal = energyToEmpty?.challenge, let res = energyToEmpty?.response, let val = energyToEmpty?.validation {
				
				let energyToEmptyCommand = TestCommandExecution(type: .ENERGY_TO_EMPTY , resProtocal: elmProtocol, challenge: chal, response: res, validation: val)
				normalCommandsList.append(energyToEmptyCommand)
			}

			
			let diagnosticSession = command.testCommands?.diagnosticSession
			if let diaChal = diagnosticSession?.challenge, let pro = diagnosticSession?.diagnosticSessionProtocol {
				isDiagnosticSession = true
				let diagno = TestCommandDiagnosticExecution(type: .DIAGNOSTIC_SESSION, resProtocal: pro, challenge: diaChal)
				self.diagnosticCommand = diagno
				
			}

			////////print("Normal Command List", normalCommandsList)
			if let sp = command.testCommands?.sampledCommands {
				//sampledCommandsList = sp
				//WHY?????
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
					self.numberOfCells = response.numberOfCells
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
		print(Date(), "Inital Commands", to: &Log.log)
		Network.shared.bluetoothService?.writeBytesData(data: ATZ_Command, completionHandler: { data in
			print(Date(), "about to perform ATZ command write", to: &Log.log)
			self.runATE0Command()
		})
	}
	
	private func runATE0Command() {
		let ATE0_Command = Constants.ATE0 + Constants.NEW_LINE_CHARACTER
		Network.shared.bluetoothService?.writeBytesData(data: ATE0_Command, completionHandler: { data in
			print(Date(), "about to perform ATE0 command write", to: &Log.log)
			self.runATS0Command()
		})
	}
	
	private func runATS0Command() {
		let ATS0_Command =  Constants.ATS0 + Constants.NEW_LINE_CHARACTER
		Network.shared.bluetoothService?.writeBytesData(data: ATS0_Command, completionHandler: { data in
			print(Date(), "about to perform ATS0 command write", to: &Log.log)
			self.runProtocolCommand()
		})
	}
	
	private func runProtocolCommand() {
		let elmValue = elm327ProtocolPreset?.replacingOccurrences(of: "_", with: "")
		let ATSP_Command = Constants.ATSP + "\(elmValue ?? Constants.DEFAULT_PROTOCOL)" + Constants.NEW_LINE_CHARACTER
		Network.shared.bluetoothService?.writeBytesData(data: ATSP_Command, completionHandler: { data in
			print(Date(), "about to perform protocol command write", to: &Log.log)
			if self.isDiagnosticSession == true {
				self.runDiagnosticCommand()
			} else {
				self.runNormalCommands()
			}
			
		})
	}
	
	private func runDiagnosticCommand() {
		if let header = diagnosticCommand?.challenge?.header {
			guard let pid = diagnosticCommand?.challenge?.pid else { return }
			let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
			Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
				print(Date(), "about to perform Diagnostic command write", to: &Log.log)
				let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
				Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data1 in
					self.isDiagnosticSession  = false
					self.runNormalCommands()
					return
					//onCompletion!(testCommand)
				})
			})
			
		}
	}
		

	
	// MARK: - Normal Commands
	private func runNormalCommands() {
		print(Date(), "about to perform Normal commands", to: &Log.log)
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
								print(Date(), "Odometer PID response\(data1)", to: &Log.log)
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
							print(Date(), "Odometer PID response\(data1)", to: &Log.log)
							onCompletion!(testCommand)
						})
					})
					
				}
			}
			
		case .STATEOFCHARGE:
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
									print(Date(), "State of Charge PID response\(data1)", to: &Log.log)
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
								print(Date(), "State of Charge PID response\(data1)", to: &Log.log)
								onCompletion!(testCommand)
							})
						})
					})
				}
			}
			
			//vv imp
		case .ENERGY_TO_EMPTY:
			if let flowControl = testCommand.challenge?.flowControl {
				self.runFlowControlHeaderAndData(flowControl: flowControl, testCommand: testCommand) { command in
					if let header = testCommand.challenge?.header {
						guard let pid = testCommand.challenge?.pid else { return }
						let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
							Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
								let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
									Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
										testCommand.deviceReponse = data
										print(Date(), "Energy to empty PID response\(data)", to: &Log.log)
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
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
						Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
							let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
								Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
									testCommand.deviceReponse = data
									print(Date(), "Energy to empty PID response\(data)", to: &Log.log)
									onCompletion!(testCommand)
								})
							})
						})
					})
				}
			}
			break
		case .BMS_CAPACITY:
			if let flowControl = testCommand.challenge?.flowControl {
				self.runFlowControlHeaderAndData(flowControl: flowControl, testCommand: testCommand) { command in
					if let header = testCommand.challenge?.header {
						guard let pid = testCommand.challenge?.pid else { return }
						let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
						//DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
							Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data1 in
								let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
									Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
										testCommand.deviceReponse = data
										print(Date(), "BMS PID response\(data)", to: &Log.log)
										onCompletion!(testCommand)
									})
								})
							})
						//})
					}
				}
			} else {
				if let header = testCommand.challenge?.header {
					guard let pid = testCommand.challenge?.pid else { return }
					let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
//					DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
						Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
							let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
								Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
									testCommand.deviceReponse = data
									print(Date(), "BMS PID response\(data)", to: &Log.log)
									onCompletion!(testCommand)
								})
							})
						})
//					})
				}
			}
			break
		case .PACK_TEMPERATURE:
			if let flowControl = testCommand.challenge?.flowControl {
				self.runFlowControlHeaderAndData(flowControl: flowControl, testCommand: testCommand) { command in
					if let header = testCommand.challenge?.header {
						guard let pid = testCommand.challenge?.pid else { return }
						let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
							Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
								let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
								Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
									testCommand.deviceReponse = data
									print(Date(), "Pack Temperature PID response\(data)", to: &Log.log)
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
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
							Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
								testCommand.deviceReponse = data
								print(Date(), "Pack Temperature PID response\(data)", to: &Log.log)
								onCompletion!(testCommand)
							})
						})
					})
				}
			}
			break
		case .PACK_VOLTAGE:
			if let flowControl = testCommand.challenge?.flowControl {
				self.runFlowControlHeaderAndData(flowControl: flowControl, testCommand: testCommand) { command in
					if let header = testCommand.challenge?.header {
						guard let pid = testCommand.challenge?.pid else { return }
						let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
						
							Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
								let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
								Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
									testCommand.deviceReponse = data
									print(Date(), "Pack Voltage PID response\(data)", to: &Log.log)
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
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
							Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
								testCommand.deviceReponse = data
								print(Date(), "Pack Voltage PID response\(data)", to: &Log.log)
								onCompletion!(testCommand)
							})
						})
					})
				}
			}
			break
		case .PACK_CURRENT:
			if let flowControl = testCommand.challenge?.flowControl {
				self.runFlowControlHeaderAndData(flowControl: flowControl, testCommand: testCommand) { command in
					if let header = testCommand.challenge?.header {
						guard let pid = testCommand.challenge?.pid else { return }
						let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
							Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
								let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
								Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
									testCommand.deviceReponse = data
									print(Date(), "Pack Current PID response\(data)", to: &Log.log)
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
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
							Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
								testCommand.deviceReponse = data
								print(Date(), "Pack Current PID response\(data)", to: &Log.log)
								onCompletion!(testCommand)
							})
						})
					})
				}
			}
			break
		case .CELL_VOLTAGE:
			if let flowControl = testCommand.challenge?.flowControl {
				self.runFlowControlHeaderAndData(flowControl: flowControl, testCommand: testCommand) { command in
					if let header = testCommand.challenge?.header {
						guard let pid = testCommand.challenge?.pid else { return }
						let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
						
							Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
								let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
								Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
									testCommand.deviceReponse = data
									print(Date(), "Cell Voltage PID response\(data)", to: &Log.log)
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
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
							Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
								testCommand.deviceReponse = data
								print(Date(), "Cell Voltage PID response\(data)", to: &Log.log)
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
		isFlowControlChanged = true
		let flowcontrolHeader = Constants.ATFCSH + flowControl.flowControlHeader! + Constants.NEW_LINE_CHARACTER
		Network.shared.bluetoothService?.writeBytesData(data: flowcontrolHeader, completionHandler: { data in
			isFlowControlChanged = true
			self.previousFlowControlData = flowControl.flowControlData
			let flowControlData = Constants.ATFCSD + flowControl.flowControlData! + Constants.NEW_LINE_CHARACTER
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
				Network.shared.bluetoothService?.writeBytesData(data: flowControlData, completionHandler: { data in
					if isFlowControlChanged {
						let flowControlChangedCommand = Constants.ATFCSM1 + Constants.NEW_LINE_CHARACTER
						Network.shared.bluetoothService?.writeBytesData(data: flowControlChangedCommand, completionHandler: { data in
							onCompletion!(testCommand)
						})
					} else {
						onCompletion!(testCommand)
					}
				})
			})
		})
	}
	
	private func runCommandThatNeedToRunInLoop() {
		let totalNumberOfCommands: Int = sampledCommandsList.count
		if (isTimeInProgress == true) {
			if (commandToRunInLoopIndex < totalNumberOfCommands) {
				let command = sampledCommandsList[commandToRunInLoopIndex]
				self.runTheCommand(indexValue: self.commandToRunInLoopIndex, testCommand: command , onCompletion: { [self]command in
					self.totalNumberOfPidCommandsRan += 1
					print(Date(), "PID command run value \(totalNumberOfPidCommandsRan)", to: &Log.log)
					self.parseResponse(testCommand: command, index: commandToRunInLoopIndex)
					if (self.commandToRunInLoopIndex == totalNumberOfCommands - 1) {
						self.numberOfLogicsParsed += 1
						self.commandToRunInLoopIndex  = 0
						print(Date(), "Number of logic parsed\(numberOfLogicsParsed)", to: &Log.log)
					} else {
						self.commandToRunInLoopIndex += 1
					}
					self.runCommandThatNeedToRunInLoop()
				})
			}
		} else {
			if loopCount == -1 {
				
			// ALert to turn off car
				self.preSignedDelegate?.navigateToAnimationVC()
				DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
					self.uploadAndSubmitDelegate?.navigateToHealthScoreVC()
				}
			}
			loopCount += 1
		}
	}
	
	private func parseResponse(testCommand: TestCommandExecution?, index: Int) {
		DispatchQueue.global(qos: .background).async {
			
		guard let reponseData = testCommand?.deviceReponse, reponseData.count > 0 else { return  }
		if reponseData.contains(Constants.QUESTION_MARK) || reponseData.contains(Constants.NODATA) || reponseData.contains(Constants.NO_DATA) || reponseData.contains(Constants.ERROR) {
			return
		}
		
		if let deviceByteArray = testCommand?.deviceReponse, deviceByteArray.count > 0 {
			let startByte = testCommand?.response?.startByte ?? 0
			print(Date(), "Start Byte\(startByte)", to: &Log.log)
			let endByte = testCommand?.response?.endByte ?? 0
			print(Date(), "End Byte\(endByte)", to: &Log.log)
			let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
			if (haxValueList.count - 1) < endByte {
				return
			}
			print(Date(), "Hex Value\(haxValueList)", to: &Log.log)
			print("HEX Value  :  Command",haxValueList, testCommand?.type )
			switch testCommand?.type {
			case .ODOMETER:
						if haxValueList.count > 0 {
							let value = self.calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
							self.odometer = value
							print(Date(), "Final Odmeter \(value)", to: &Log.log)
						}

				break
			case .STATEOFCHARGE:
						if haxValueList.count > 0 {
							let value = self.calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
							self.stateOfCharge = value
							print(Date(), "Final State of Charge \(value)", to: &Log.log)
						}
				break
			case .ENERGY_TO_EMPTY:
						if haxValueList.count > 0 {
							let value = self.calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
							self.currentEnergy = value
							print(Date(), "Final Energy to empty \(value)", to: &Log.log)
						}
				break
			case .BMS_CAPACITY:
						if haxValueList.count > 0 {
							let value = self.calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
							self.bms = value
							print(Date(), "Final BMS value \(value)", to: &Log.log)
						}
				break
			case .PACK_TEMPERATURE:
						if haxValueList.count > 0 {
							let value = self.calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
							self.packTemperatureData.append(value)
							print(Date(), "Final Pack Temperature Value \(value)", to: &Log.log)
						}
				break
			case .PACK_VOLTAGE:
						if haxValueList.count > 0 {
							let value = self.calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
							self.packVoltageData.append(value)
							print(Date(), "Final Pack Voltage Value \(value)", to: &Log.log)
						}
				break
			case .PACK_CURRENT:
					if testCommand?.deviceReponse != nil {
						guard let packCurrent = testCommand?.deviceReponse, packCurrent.count > 0   else { return  }
						let finalStringBytes = self.typeCastingByteToString(testCommand: testCommand)
						let startByte = testCommand?.response?.startByte ?? 0
						let endByte = testCommand?.response?.endByte ?? 0
						let numberOfBytesDifference = endByte - startByte
						let haxValue = self.findFinalHexValue(haxVal: finalStringBytes, startByete: testCommand?.response?.startByte ?? 0, endByte: testCommand?.response?.endByte ?? 0)
						let decimalValue = self.fromHaxToDecimal(haxValue: haxValue)
						var comparisonValue = ""
						if (numberOfBytesDifference == 0) {
							comparisonValue = Constants.SEVEN_F
						} else {
							comparisonValue =
							Constants.SEVEN_F.padding(toLength: ((numberOfBytesDifference + 1) * 2), withPad: "F", startingAt: 0)
						}
						let multiplier = testCommand?.response?.multiplier ?? 1.0
						var packCurrentValue = 0.0
						
						if (decimalValue < self.fromHaxToDecimal(haxValue: comparisonValue)) {
							packCurrentValue = Double(decimalValue) * multiplier * -1
						} else {
							var valueFromWhichToSubtract = ""
							if (numberOfBytesDifference == 0) {
								valueFromWhichToSubtract = Constants.FF
							} else {
								valueFromWhichToSubtract = Constants.FF.padding(toLength: ((numberOfBytesDifference + 1) * 2), withPad: "F", startingAt: 0)
							}
							packCurrentValue = Double((self.fromHaxToDecimal(haxValue: valueFromWhichToSubtract) - decimalValue)) * multiplier
						}
						
						let constantValue = testCommand?.response?.constant ?? 0
						let finalValue = packCurrentValue + Double(constantValue)
						print(Date(), "Final Pack Current Value \(finalValue)", to: &Log.log)
						self.packCurrentData.append(finalValue)
				}
				break
			case .CELL_VOLTAGE:
                if let _ = testCommand?.challenge?.flowControl {
                    let cellVoltArray = self.handlingMultiframeString(testCommand: testCommand)
					print("cell volt array", cellVoltArray)

                } else {
						if haxValueList.count > 0 {
							let value = self.calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
							print(Date(), "Final Cell Voltage Value \(value)", to: &Log.log)
							self.cellVoltageData.append(value)
						}
                    }
				break
			case .BATTERY_AGE:
						if haxValueList.count > 0 {
							let value = self.calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
							print(Date(), "Final Battery Age Value \(value)", to: &Log.log)
						}
				break
			case .DIAGNOSTIC_SESSION:
				break
			case .MISC_COMMANDS:
						if haxValueList.count > 0 {
							let _ = self.calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
						}
				break
			case .none:
				break
			case .Other:
				break
			}
		}
		}
	}
	
	

	//MARK: - MultiFrame handling
	
	private func handlingMultiframeString(testCommand: TestCommandExecution?) -> [Double] {
		
		if let deviceByteArray = testCommand?.deviceReponse, deviceByteArray.count > 0 {
			let startByte = testCommand?.response?.startByte ?? 0
			print(Date(), "Start Byte \(startByte)", to: &Log.log)
			let endByte = testCommand?.response?.endByte ?? 0
			print(Date(), "End Byte \(endByte)", to: &Log.log)
			let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
			let haxValue = FlowfindFinalHexValue(haxVal: haxValueList, startByete: startByte, endByte: endByte)
			//print(Date(), "Final Byte Array\(endByte)", to: &Log.log)
			let chunkArray = haxValue.chunked(into: testCommand?.response?.bytesPerCell ?? 0)
			//print(Date(), "Divided in chunks of Array\(chunkArray)", to: &Log.log)
			let totalCells = testCommand?.response?.numberOfCells
			var finalValuesArray = [Double]()
			if chunkArray.count == totalCells {
				for item in chunkArray {
					//print(Date(), "Each chunk array:\(chunkArray)", to: &Log.log)
					let finalByte = item.joined()
					let decimalValue = fromHaxToDecimal(haxValue: finalByte)
					print(Date(), "Decimal Value\(decimalValue)", to: &Log.log)
					let multiplierValue = Double(decimalValue) * (Double(testCommand?.response?.multiplier ?? 1.0))
					print(Date(), "After Multiplier\(multiplierValue)", to: &Log.log)
					let constantValue = testCommand?.response?.constant ?? 0
					let finalValue = multiplierValue + Double(constantValue)
					print(Date(), "Final Calculated value\(finalValue)", to: &Log.log)
					finalValuesArray.append(finalValue)
					
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(finalValue)"
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
				}
			}
			multiCellVoltageData.append(finalValuesArray)
			return finalValuesArray
		} else {
			return [0.0]
		}
	}
	
	
	//MARK: - Convert each byte as string (typecasting)
	private func typeCastingByteToString(testCommand: TestCommandExecution?) -> [String] {
		
		guard let finalData = testCommand?.deviceReponse  else { return [""] }
		let trimmed = finalData.trimmingCharacters(in: .whitespacesAndNewlines)
		let arrBytes = trimmed.replacingOccurrences(of: " ", with: "")
		return arrBytes.components(withMaxLength: 2)
	}
	

	private func calculateValueFromStartEndByte(command: TestCommandExecution?, hexValuesList: [String]) -> Double {
		
		let haxValue = findFinalHexValue(haxVal: hexValuesList, startByete: command?.response?.startByte ?? 0, endByte: command?.response?.endByte ?? 0)
		print(Date(), "String After Modification\(haxValue)", to: &Log.log)
		let decimalValue = fromHaxToDecimal(haxValue: haxValue)
		print(Date(), "Decimal Value\(decimalValue)", to: &Log.log)
		let multiplierValue = Double(decimalValue) * (Double(command?.response?.multiplier ?? 1.0))
		print(Date(), "Multiplier Value\(multiplierValue)", to: &Log.log)
		let constantValue = command?.response?.constant ?? 0
		let finalValue = multiplierValue + Double(constantValue)
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
		guard let decimalValue = Int(haxValue, radix: 16) else {
			return Int(0)
			
		}
		return Int(decimalValue)
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


