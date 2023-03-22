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
	/*
	 var item = "initial value" {
	 didSet { //called when item changes
	 ////print("changed")
	 }
	 willSet {
	 ////print("about to change")
	 }
	 }
	 */
	public var isTimeInProgress: Bool = false {
		didSet { //called when item changes
			////print("changed")
			
			self.stopTimer()
		}
		willSet {
			
			////print("about to change")
		}
	}
	
	public var isLoopingTimeInProgress: Bool = false {
		didSet { //called when item changes
			////print("changed")
			
			self.stopTimer()
		}
		willSet {
			
			////print("about to change")
		}
	}
	private var normalCommandsList = [TestCommandExecution]()
	private var normalCommandsIndex = 0
	
	public var sampledCommandsList = [TestCommandExecution]()
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
	private var stateOfCharge: Double?
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
	
	init(vehicleInfo: Vehicle) {
		self.vehicleInfo = vehicleInfo
		
		//self.bleService.delegate = self
		//self.bleService.setDelegateChange(delegate: self)
	}
	
	
	private func stopTimer() {
		if self.isTimeInProgress == true {
			self.runCommandThatNeedToRunInLoop()
			
		}
	}
	
	public func handleInstructions() {
		guard let testCommand = vehicleInfo?.getBatteryTestInstructions, testCommand.count > 0 else {
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
			
			
			
			//////print("Normal Command List", normalCommandsList)
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
					//////print("PID:::::", item.challenge.pid)
					let response = OdometerResponse(startByte: item.response.startByte, endByte: item.response.endByte, multiplier: Double(item.response.multiplier), constant: Double(item.response.constant))
					let packTempTestCommand = TestCommandExecution(type: .PACK_TEMPERATURE, resProtocal: sp.sampledCommandsProtocol, challenge: item.challenge, response: response, validation: item.validation)
					packTempTestCommand.reqeustByteInString = item.challenge.pid
					sampledCommandsList.append(packTempTestCommand)
				}
				
				//MARK: - CellVoltage
				let cellVoltage = sp.cellVoltage
				for item in cellVoltage {
					//////print("PID:::::", item.challenge.pid)
					let response = OdometerResponse(startByte: item.response.startByte, endByte: item.response.endByte, multiplier: Double(item.response.multiplier), constant: Double(item.response.constant))
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
		//print("Inital Commands", Date(), to: &logger)
		//print("about to perform ATZ command write", Date(), to: &logger)
		Network.shared.bluetoothService?.writeBytesData(data: ATZ_Command, completionHandler: { data in
			//////print("atz")
			self.runATE0Command()
		})
	}
	
	private func runATE0Command() {
		let ATE0_Command = Constants.ATE0 + Constants.NEW_LINE_CHARACTER
		//print("about to perform ATE0 command write", Date(), to: &logger)
		Network.shared.bluetoothService?.writeBytesData(data: ATE0_Command, completionHandler: { data in
			self.generateTxtCommandLogs(data: data)
			self.runATS0Command()
		})
	}
	
	private func runATS0Command() {
		let ATS0_Command =  Constants.ATS0 + Constants.NEW_LINE_CHARACTER
		//print("about to perform ATSO command write", Date(), to: &logger)
		Network.shared.bluetoothService?.writeBytesData(data: ATS0_Command, completionHandler: { data in
			
			self.runProtocolCommand()
		})
	}
	
	private func runProtocolCommand() {
		let elmValue = elm327ProtocolPreset?.replacingOccurrences(of: "_", with: "")
		let ATSP_Command = Constants.ATSP + "\(elmValue ?? Constants.DEFAULT_PROTOCOL)" + Constants.NEW_LINE_CHARACTER
		//print("about to perform ATSP command write", Date(), to: &logger)
		Network.shared.bluetoothService?.writeBytesData(data: ATSP_Command, completionHandler: { data in
		
			self.runNormalCommands()
		})
	}
	
	// MARK: - Normal Commands
	//odo, state charge
	private func runNormalCommands() {
		
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
			if let header = testCommand.challenge?.header {
				guard let pid = testCommand.challenge?.pid else { return }
				let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
				self.generateTxtCommandLogs(data: "Odometer Header: \(ATSHOdometer_Command)")
				Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
					let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
					////print("Run Command: In-ODOMETER")
					self.generateTxtCommandLogs(data: data)
					self.generateTxtCommandLogs(data: "Odometer PID: \(odometerPIDCommand)")
					Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
						self.generateTxtCommandLogs(data: data)
						testCommand.deviceReponse = data
						////print("Run Command: Out-ODOMETER")
						
						onCompletion!(testCommand)
					})
				})
				
			}
			
		case .STATEOFCHARGE:
			//TODO Handle Flow Comtrol Data
			if let header = testCommand.challenge?.header {
				guard let pid = testCommand.challenge?.pid else { return }
				let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
//				////print("ATSH State Of Charge", ATSHOdometer_Command)
				self.generateTxtCommandLogs(data: "State of charge Header: \(ATSHOdometer_Command)")
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
					//sleep(1)
					Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
						//self.generateTxtCommandLogs(data: data)
	//					////print("StateOfCharge: SOC-Header", data)
						let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
						//////print("Run Command: In-StateOfCharge")
						self.generateTxtCommandLogs(data: "State of charge PID: \(odometerPIDCommand)")
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
						//sleep(2)
						Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
							//////print("Run Command: Out-StateOfCharge")
							//self.generateTxtCommandLogs(data: data)
							testCommand.deviceReponse = data
							onCompletion!(testCommand)
						})
						})
					})
				})
				
			}
			
			
		case .ENERGY_TO_EMPTY:
			
			break
		case .BMS_CAPACITY:
			if let header = testCommand.challenge?.header {
				guard let pid = testCommand.challenge?.pid else { return }
				let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
               print("BMS Header:", ATSHOdometer_Command)
				self.generateTxtCommandLogs(data: "BMS Header: \(ATSHOdometer_Command)")
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
					//sleep(1)
					Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
						//self.generateTxtCommandLogs(data: data)
	//					////print("StateOfCharge: SOC-Header", data)
						let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
						//////print("Run Command: In-StateOfCharge")
						self.generateTxtCommandLogs(data: "BMS PID: \(odometerPIDCommand)")
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
						//sleep(2)
						Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
							//////print("Run Command: Out-StateOfCharge")
							//self.generateTxtCommandLogs(data: data)
							testCommand.deviceReponse = data
							onCompletion!(testCommand)
						})
						})
					})
				})
				
			}
			break
		case .PACK_TEMPERATURE:
			if let header = testCommand.challenge?.header {
				guard let pid = testCommand.challenge?.pid else { return }
				let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
				//self.generateTxtCommandLogs(data: "Pack Temerature Header: \(ATSHOdometer_Command)")
				//usleep(200000)
				//DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
					Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
						
						
						self.generateTxtCommandLogs(data: data)
						
						let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
						//////print("Run Command: In-PackTemperature")
						//usleep(200000)
						self.generateTxtCommandLogs(data: "Pack Temparature PID: \(odometerPIDCommand)")
						Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
							////print("Run Command: Out-PackTemperature")
							self.generateTxtCommandLogs(data: data)
							testCommand.deviceReponse = data
							
							onCompletion!(testCommand)
						})
					})
				//})
				
				
			}
			
			break
		case .PACK_VOLTAGE:
			if let header = testCommand.challenge?.header {
				guard let pid = testCommand.challenge?.pid else { return }
				let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
				//self.generateTxtCommandLogs(data: "Pack Voltage Header: \(ATSHOdometer_Command)")
				//usleep(200000)
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
						Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
							
							self.generateTxtCommandLogs(data: data)
							
							let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
							////print("Run Command: In-PackVoltage")
							
							self.generateTxtCommandLogs(data: "Pack Voltage PID: \(odometerPIDCommand)")
							//usleep(200000)
							Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
								////print("Run Command: Out-PackVoltage")
								self.generateTxtCommandLogs(data: data)
								testCommand.deviceReponse = data
								
								onCompletion!(testCommand)
								
							})
						})
					})
				
			}
			
			break
		case .PACK_CURRENT:
			if let header = testCommand.challenge?.header {
				guard let pid = testCommand.challenge?.pid else { return }
				let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
				//self.generateTxtCommandLogs(data: "Pack Current Header: \(ATSHOdometer_Command)")
				//usleep(200000)
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
							Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
								//usleep(200000)
								//self.generateTxtCommandLogs(data: data)
								let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
								////print("Run Command: In-PackCurrent")
								//self.generateTxtCommandLogs(data: "Pack current PID: \(odometerPIDCommand)")
								Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
									
						self.generateTxtCommandLogs(data: data)
									testCommand.deviceReponse = data
									//////print("Run Command: Out-PackCurrent")
									
									onCompletion!(testCommand)
								})
							})
						})
				
			}
			
			break
		case .CELL_VOLTAGE:
			if let header = testCommand.challenge?.header {
				guard let pid = testCommand.challenge?.pid else { return }
				let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
				//usleep(200000)
				//self.generateTxtCommandLogs(data: "Cell Voltage Header: \(ATSHOdometer_Command)")
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
								Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
									//usleep(200000)
									//self.generateTxtCommandLogs(data: data)
									let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
									//self.generateTxtCommandLogs(data: "Cell Voltage PID: \(odometerPIDCommand)")
									////print("Run Command: In-CellVoltage")
									Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
										testCommand.deviceReponse = data
										////print("Run Command: Out-CellVoltage")
										//self.generateTxtCommandLogs(data: data)
										onCompletion!(testCommand)
										
									})
								})
							})
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
	
	private func runCommandThatNeedToRunInLoop() {
		let totalNumberOfCommands: Int = sampledCommandsList.count
		// to decide final completion
		if (isTimeInProgress == true) {
			if isLoopingTimeInProgress == true {
				if (commandToRunInLoopIndex < totalNumberOfCommands) {
					let command = sampledCommandsList[commandToRunInLoopIndex]
					//self.countLoopCommand += 1
					//print("INDEX BEFORE RUN",commandToRunInLoopIndex)
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
						self.runTheCommand(indexValue: self.commandToRunInLoopIndex, testCommand: command , onCompletion: { [self]command in
							self.totalNumberOfPidCommandsRan += 1
							self.parseResponse(testCommand: command, index: commandToRunInLoopIndex)
							if (self.commandToRunInLoopIndex == totalNumberOfCommands - 1) {
								self.numberOfLogicsParsed += 1
								//////print("NUMBER OF LOGICS RUN", self.numberOfLogicsParsed)
								self.commandToRunInLoopIndex  = 0
							} else {
								if self.isLoopingTimeInProgress == true {
									self.commandToRunInLoopIndex += 1
								}
								//////print("NUMBER PIDS IN LOOP RUN", self.commandToRunInLoopIndex)
							}
							//////print("GOOD ONE")
							//self.runLoopCommandIndex = self.commandToRunInLoopIndex
							self.runCommandThatNeedToRunInLoop()
						})
					})
				}
			}  else {
				//print("ELSE  of isLoopingTimeInProgress:::", isLoopingTimeInProgress)
				//self.commandToRunInLoopIndex = self.runLoopCommandIndex
				//print("command index::in else conditon", self.commandToRunInLoopIndex)
				return
			}

		} else {
			// loopCount intial value -1 , delay 25sec , prepare CSV fiels
			////print("TIME BOOL::: ELSE)", loopCount)
			if loopCount == -1 {
				////print("TIME BOOL:::-runCommandThatNeedToRunInLoopEin ELSE\(Date().description)", isTimeInProgress)
				//print("*********BLE reponse is finished**********")
				self.preSignedDelegate?.navigateToAnimationVC()
				DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
					self.uploadAndSubmitDelegate?.navigateToHealthScoreVC()
				}
			}
			loopCount += 1
		}
	}
	
	private func parseResponse(testCommand: TestCommandExecution?, index: Int) {
		//let group = DispatchGroup()
		
		guard let reponseData = testCommand?.deviceReponse, reponseData.count > 0 else { return  }
		
//		if !reponseData.contains("OK") {
//			return
//		}
		
		//	////print("IN PARSE METHOD", testCommand?.type as Any)
		switch testCommand?.type {
		case .ODOMETER:
			//group.enter()
			if testCommand?.deviceReponse != nil {
				
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				if haxValueList.count > 0 {
					let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)//calculateValueFromStartEndByte(command, hexValuesList)
					self.odometer = value
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(self.odometer)"
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					//group.leave()
					
				}
			}
			//stopLoopExecution(group: group)
			break
		case .STATEOFCHARGE:
			//group.enter()
			if testCommand?.deviceReponse != nil {
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				if haxValueList.count > 0 {
					let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
					self.stateOfCharge = value
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(value)"
					//////print(message)
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					//group.leave()
				}
			}
			//stopLoopExecution(group: group)
			break
		case .ENERGY_TO_EMPTY:
			//group.enter()
			if testCommand?.deviceReponse != nil {
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				if haxValueList.count > 0 {
					let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)//calculateValueFromStartEndByte(command, hexValuesList)
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(value)"
					////print(message)
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					//group.leave()
				}
			}
			//stopLoopExecution(group: group)
			break
		case .BMS_CAPACITY:
			//group.enter()
			if testCommand?.deviceReponse != nil {
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				if haxValueList.count > 0 {
					let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)//calculateValueFromStartEndByte(command, hexValuesList)
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(value)"
					////print(message)
					
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					//group.leave()
				}
			}
			//stopLoopExecution(group: group)
			break
		case .PACK_TEMPERATURE:
			//group.enter()
			if testCommand?.deviceReponse != nil {
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				//print("PACK_TEMPERATURE ByteArray:::", haxValueList)
				if haxValueList.count > 0 {
					let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)//calculateValueFromStartEndByte(command, hexValuesList)
					packTemperatureData.append(value)
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(value)"
					////print("Pack Temerature::::::::", message)
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					//group.leave()
				}
			}
			//stopLoopExecution(group: group)
			break
		case .PACK_VOLTAGE:
			//group.enter()
			if testCommand?.deviceReponse != nil {
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				//print("PACK_VOLTAGE ByteArray:::", haxValueList)
				if haxValueList.count > 0 {
					let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)//calculateValueFromStartEndByte(command, hexValuesList)
					packVoltageData.append(value)
					//////print("packVoltage:::::", packVoltageData)
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(value)"
					//////print(message)
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					//group.leave()
				}
			}
			//stopLoopExecution(group: group)
			break
		case .PACK_CURRENT:
			//group.enter()
			print(":::PACK-CURRENT::::")
			print("Response String pack current", reponseData)
			
			if testCommand?.deviceReponse != nil {
				guard let packCurrent = testCommand?.deviceReponse, packCurrent.count > 0   else { return  }
				
				//let byteArray: [UInt8] = Array(testCommand?.deviceReponse ?? Data())
				//if (testCommand?.deviceReponse?.count ?? 0) > 0 {
				let finalStringBytes = typeCastingByteToString(testCommand: testCommand)
				print("string in bytes", finalStringBytes)
				let startByte = testCommand?.response?.startByte ?? 0
				let endByte = testCommand?.response?.endByte ?? 0
				
				let numberOfBytesDifference = endByte - startByte
				print("numberOfBytesDifference",numberOfBytesDifference)
				let haxValue = findFinalHexValue(haxVal: finalStringBytes, startByete: testCommand?.response?.startByte ?? 0, endByte: testCommand?.response?.endByte ?? 0)
				let decimalValue = fromHaxToDecimal(haxValue: haxValue)
				print("Decimal Value", decimalValue)
				var comparisonValue = ""
				
				if (numberOfBytesDifference == 0) {
					comparisonValue = Constants.SEVEN_F
				} else {
					//let paddedStr = str.padding(toLength: 20, withPad: " ", startingAt: 0)
					comparisonValue =
					Constants.SEVEN_F.padding(toLength: ((numberOfBytesDifference + 1) * 2), withPad: "F", startingAt: 0)
					
					//.padEnd((numberOfBytesDifference + 1) * 2, 'F')
				}
				print("7F comparison Value::::::::", comparisonValue)
				
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
						
						//padEnd((numberOfBytesDifference + 1) * 2, 'F')
					}
					print("valueFromWhichToSubtract::", valueFromWhichToSubtract)
					packCurrentValue = Double((fromHaxToDecimal(haxValue: valueFromWhichToSubtract) - decimalValue)) * multiplier
					print("packCurrentValue::::", packCurrentValue)
				}
				
				let constantValue = testCommand?.response?.constant ?? 0.0
				let finalValue = packCurrentValue + constantValue
				//print("finalValue-pack current", finalValue)
				packCurrentData.append(finalValue)
				////print("pack Current data::", packCurrentData)
				let message = (testCommand?.type?.description ?? "") + "calculated value is \(finalValue)"
				////print(message)
				NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
				
				
			}
			//stopLoopExecution(group: group)
			break
		case .CELL_VOLTAGE:
			//group.enter()
			if testCommand?.deviceReponse != nil {
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				//print("CELL_VOLTAGE ByteArray:::", haxValueList)
				if haxValueList.count > 0 {
					let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)//calculateValueFromStartEndByte(command, hexValuesList)
					cellVoltageData.append(value)
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(value)"
					//////print(message)
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					//////print("cellVoltagedata:::", cellVoltageData)
					//group.leave()
				}
			}
			
			//stopLoopExecution(group: group)
			break
		case .BATTERY_AGE:
			//group.enter()
			if testCommand?.deviceReponse != nil {
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				if haxValueList.count > 0 {
					let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)//calculateValueFromStartEndByte(command, hexValuesList)
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(value)"
					//////print(message)
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					//group.leave()
				}
			}
			//stopLoopExecution(group: group)
			break
		case .DIAGNOSTIC_SESSION:
			//group.enter()
			if testCommand?.deviceReponse != nil {
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				if haxValueList.count > 0 {
					let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)//calculateValueFromStartEndByte(command, hexValuesList)
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(value)"
					//////print(message)
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					////group.leave()
				}
			}
			//stopLoopExecution(group: group)
			break
		case .MISC_COMMANDS:
			//group.enter()
			if testCommand?.deviceReponse != nil {
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				if haxValueList.count > 0 {
					let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)//calculateValueFromStartEndByte(command, hexValuesList)
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(value)"
					//////print(message)
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					//group.leave()
				}
			}
			//stopLoopExecution(group: group)
			break
		case .none:
			break
		case .Other:
			break
		}
//		if self.isTimeInProgress == false {
//			group.notify(queue: DispatchQueue.global()) {
//				////print("Completed work:")
//				// Kick off the movies API calls
//				//PlaygroundPage.current.finishExecution()
//			}
//		}

	}
	
	
	//MARK: - Convert each byte as string (typecasting)
	private func typeCastingByteToString(testCommand: TestCommandExecution?) -> [String] {
		
		guard let finalData = testCommand?.deviceReponse  else { return [""] }
		let trimmed = finalData.trimmingCharacters(in: .whitespacesAndNewlines)
		//////print("trimmed", trimmed)
		let arrBytes = trimmed.replacingOccurrences(of: " ", with: "")
		return arrBytes.components(withMaxLength: 2)
	}
	
	private func submitBatteryDataFileWithSOCGraphRequest() {
		//SubmitBatteryDataFileWithSOC
		let vehicalBatteryDataFile = SubmitBatteryDataFilesVehicleInput.init(vin: vehicleInfo?.vin ?? "", make: vehicleInfo?.make ?? "", model: vehicleInfo?.modelName ?? "", year: vehicleInfo?.year ?? 0)
		let batteryInstr = vehicleInfo?.getBatteryTestInstructions
		
		guard let vehicleProfile = batteryInstr?[0].testCommands?.vehicleProfile else {return}
		guard let stateOfHealth = batteryInstr?[0].testCommands?.stateOfHealthCommands else {return}
		let submitBatteryDataVehicleProfileInput = SubmitBatteryDataVehicleProfileInput(nominalVoltage: vehicleProfile.nominalVoltage ?? 1.0, energyAtBirth:vehicleProfile.energyAtBirth ?? 1.0, batteryType: BatteryType.lithium, capacityAtBirth: vehicleProfile.capacityAtBirth ?? 1.0)
		
		let stateOfChargePropsInput = StateOfChargePropsInput(stateOfCharge: self.stateOfCharge ?? 0.0, currentEnergy: stateOfHealth.energyToEmpty)
		let submitBatteryDataFilesPropsInput = SubmitBatteryDataFilesPropsInput(locationCode: LocationCode.init(rawValue: "AAA"), odometer: Int(self.odometer ?? 0), totalNumberOfCharges: nil, lifetimeCharge: nil, lifetimeDischarge: nil, packVoltageFilename: "Pack_Voltage_\(self.vehicleInfo?.vin ?? "")", packCurrentFilename: "Pack_Current_\(self.vehicleInfo?.vin ?? "")", cellVoltagesFilename: "Cell_Volt_\(self.vehicleInfo?.vin ?? "")", transactionId: self.transactionId ?? "", vehicleProfile: submitBatteryDataVehicleProfileInput)
		
		Network.shared.apollo.perform(mutation: SubmitBatteryFilesWithStateOfChargeMutation(Vehicle: vehicalBatteryDataFile, submitBatteryDataFilesProps: submitBatteryDataFilesPropsInput, stateOfChargeProps: stateOfChargePropsInput)) { result in
			switch result {
				
			case .success(let graphQLResult):
				guard let _ = try? result.get().data else { return }
				if graphQLResult.data != nil {
					//  self.preSignedDelegate?.getTransactionIdInfo(viewModel: self)
					/*
					let getS3PreSingedData = graphQLResult.data?.resultMap["submitBatteryDataFilesWithStateOfCharge"]
					//getS3PreSingedUrl
					var preSignedData : Data?
					do {
						preSignedData = try JSONSerialization.data(withJSONObject: SubmitBatteryDataFileWithSOC.self)
					} catch {
						////print("Unexpected error: \(error).")
					}
					////print(getS3PreSingedData.jsonValue)
					do {
						let decoder = JSONDecoder()
						//let preSignedResponse = try decoder.decode(SubmitBatteryDataFileWithSOC.self, from: preSignedData!)
						//self.transactionId = preSignedResponse.transactionID
						//////print("transaction id::", preSignedResponse.transactionID)
						//	self.preSignedData = preSignedResponse
						//self.vehicleInformation = messages
						
						//self.delegate?.updateVehicleInfo(viewModel: self)
						// CSV file generation
						
						//self.preparingLogicForCSVFileGeration()
						
						//
					} catch DecodingError.dataCorrupted(let context) {
						////print(context)
					} catch DecodingError.keyNotFound(let key, let context) {
						////print("Key '\(key)' not found:", context.debugDescription)
						////print("codingPath:", context.codingPath)
					} catch DecodingError.valueNotFound(let value, let context) {
						////print("Value '\(value)' not found:", context.debugDescription)
						////print("codingPath:", context.codingPath)
					} catch DecodingError.typeMismatch(let type, let context) {
						////print("Type '\(type)' mismatch:", context.debugDescription)
						////print("codingPath:", context.codingPath)
					} catch {
						////print("error: ", error)
					}*/
					
				}
				
			case .failure(let error):
				// 5
				self.preSignedDelegate?.handleErrorTransactionID()
				////print("Error loading data \(error)")
			}
			//////print("submitBatteryDataFileWithSOCGraphRequest::::>",result)
		}
		
	}
	
	private func calculateValueFromStartEndByte(command: TestCommandExecution?, hexValuesList: [String]) -> Double {
		
		let haxValue = findFinalHexValue(haxVal: hexValuesList, startByete: command?.response?.startByte ?? 0, endByte: command?.response?.endByte ?? 0)
		//print("hex value in calculateValueFromStartEndByte", ("\(String(describing: command?.type))" + haxValue))
		let decimalValue = fromHaxToDecimal(haxValue: haxValue)
		//print("decimal value calculated", decimalValue)
		let multiplierValue = Double(decimalValue) * (Double(command?.response?.multiplier ?? 1.0))
		//print("after multiplier : ", multiplierValue)
		let constantValue = command?.response?.constant ?? 0.0
		let finalValue = multiplierValue + Double(constantValue)
		//print("Final value :", finalValue)
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
	
	
	
	func fromHaxToDecimal(haxValue: String) -> Int {
		let decimalValue = Int(haxValue, radix: 16) ?? 0
		return decimalValue
	}
	
	func generateTxtCommandLogs(data: String) {
		////print("command data: ", data)
		textCommands += "\(data)"
		textCommands += "\n"
		////print("text command:::::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>", textCommands)
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


