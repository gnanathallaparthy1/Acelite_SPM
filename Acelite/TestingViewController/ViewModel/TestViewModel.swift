//
//  TestViewModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 2/3/23.
//

import Foundation


protocol GetPreSignedUrlDelegate: AnyObject {
	func getTransactionIdInfo(viewModel: TestingViewModel)
	func handleErrorTransactionID()
}

class TestingViewModel {
	
	private var elm327ProtocolPreset: String?
	/*
	 var item = "initial value" {
	 didSet { //called when item changes
	 print("changed")
	 }
	 willSet {
	 print("about to change")
	 }
	 }
	 */
	public var isTimeInProgress: Bool = true {
		didSet { //called when item changes
			print("changed")
			
			self.stopTimer()
		}
		willSet {
			
			print("about to change")
		}
	}
	private var normalCommandsList = [TestCommandExecution]()
	private var normalCommandsIndex = 0
	
	private var sampledCommandsList = [TestCommandExecution]()
	private var commandToRunInLoopIndex: Int = 0
	private var numberOfCellsProvided = 0
	
	private var cellVoltageList : Any?
	
	private var totalNumberOfPidCommandsRan = 0
	private var numberOfLogicsParsed = 0
	
	private var instructionTypeIndex: Int = 0
	private var testCommands: TestCommands?
	private var vehicleInfo: Vehicle?
	//var testCommand: TestCommand?
	var delegate:BleWriteReadProtocal?
	let commadQueue = DispatchQueue(label: "serial")
	private var packVoltageData = [Double]()
	private var packCurrentData = [Double]()
	private var packTemperature = [Double]()
	private var cellVoltageData = [Double]()
	private var stateOfCharge: Double?
	private var odometer: Double?
	private var transactionId: String?
	weak var preSignedDelegate: GetPreSignedUrlDelegate? = nil
	
	//var bleService = BluetoothServices()
	
	let dispatchGroup = DispatchGroup()
	var loopCount: Int = -1
	var preSignedData: GetS3PreSingedURL?
	var csvDispatchGroup = DispatchGroup()
	var countLoopCommand: Int = 0
	// Txt file variable
	
	var textCommands = ""
	
	
	init(vehicleInfo: Vehicle) {
		self.vehicleInfo = vehicleInfo
		handleInstructions()
		//self.bleService.delegate = self
		//self.bleService.setDelegateChange(delegate: self)
	}
	
	
	private func stopTimer() {
		if self.isTimeInProgress == false {
			self.runCommandThatNeedToRunInLoop()
			
		}
	}
	
	private func handleInstructions() {
		guard let testCommand = vehicleInfo?.getBatteryTestInstructions, testCommand.count > 0 else {
			return
		}
		for command in testCommand {
			
			let odometer = command.testCommands?.odometer
			
			let commandCalss = TestCommandExecution(type: .ODOMETER , resProtocal: (odometer?.odometerProtocol)!, challenge: (odometer?.challenge)!, response: odometer!.response, validation: odometer!.validation)
			
			normalCommandsList.append(commandCalss)
			
			
			let stateOfCharge = command.testCommands?.stateOfHealthCommands?.stateOfCharge
			
			let stateOfChargeCommands = TestCommandExecution(type: .STATEOFCHARGE , resProtocal: (stateOfCharge?.odometerProtocol)!, challenge: (stateOfCharge?.challenge)!, response: stateOfCharge!.response, validation: stateOfCharge!.validation)
			
			normalCommandsList.append(stateOfChargeCommands)
			
			//print("Normal Command List", normalCommandsList)
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
					//print("PID:::::", item.challenge.pid)
					let response = OdometerResponse(startByte: item.response.startByte, endByte: item.response.endByte, multiplier: Double(item.response.multiplier), constant: Double(item.response.constant))
					let packTempTestCommand = TestCommandExecution(type: .PACK_TEMPERATURE, resProtocal: sp.sampledCommandsProtocol, challenge: item.challenge, response: response, validation: item.validation)
					packTempTestCommand.reqeustByteInString = item.challenge.pid
					sampledCommandsList.append(packTempTestCommand)
				}
				
				//MARK: - CellVoltage
				let cellVoltage = sp.cellVoltage
				for item in cellVoltage {
					//print("PID:::::", item.challenge.pid)
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
		self.generateTxtCommandLogs(data: "Inital Commands")
		self.generateTxtCommandLogs(data: "Inital Commands:\(ATZ_Command)")
		Network.shared.bluetoothService?.writeBytesData(data: ATZ_Command, completionHandler: { data in
			//print("atz")
			self.runATE0Command()
		})
	}
	
	private func runATE0Command() {
		let ATE0_Command = Constants.ATE0 + Constants.NEW_LINE_CHARACTER
		generateTxtCommandLogs(data: ATE0_Command)
		self.generateTxtCommandLogs(data: "Inital Commands:\(ATE0_Command)")
		Network.shared.bluetoothService?.writeBytesData(data: ATE0_Command, completionHandler: { data in
			self.generateTxtCommandLogs(data: data)
			self.runATS0Command()
		})
	}
	
	private func runATS0Command() {
		let ATS0_Command =  Constants.ATS0 + Constants.NEW_LINE_CHARACTER
		generateTxtCommandLogs(data: ATS0_Command)
		Network.shared.bluetoothService?.writeBytesData(data: ATS0_Command, completionHandler: { data in
			self.generateTxtCommandLogs(data: data)
			self.runProtocolCommand()
		})
	}
	
	private func runProtocolCommand() {
		let elmValue = elm327ProtocolPreset?.replacingOccurrences(of: "_", with: "")
		let ATSP_Command = Constants.ATSP + "\(elmValue ?? Constants.DEFAULT_PROTOCOL)" + Constants.NEW_LINE_CHARACTER
		self.generateTxtCommandLogs(data: ATSP_Command)
		Network.shared.bluetoothService?.writeBytesData(data: ATSP_Command, completionHandler: { data in
			self.generateTxtCommandLogs(data: data)
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
		case .STATEOFCHARGE:
			//TODO Handle Flow Comtrol Data
			if let header = testCommand.challenge?.header {
				guard let pid = testCommand.challenge?.pid else { return }
				let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
				self.generateTxtCommandLogs(data: "State of charge Header: \(ATSHOdometer_Command)")
				Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
					self.generateTxtCommandLogs(data: data)
					let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
					print("Run Command: In-StateOfCharge")
					self.generateTxtCommandLogs(data: "State of charge PID: \(odometerPIDCommand)")
					Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
						print("Run Command: Out-StateOfCharge")
						self.generateTxtCommandLogs(data: data)
						testCommand.deviceReponse = data
						onCompletion!(testCommand)
					})
				})
				
			}
			
		case .ODOMETER:
			if let header = testCommand.challenge?.header {
				guard let pid = testCommand.challenge?.pid else { return }
				let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
				self.generateTxtCommandLogs(data: "Odometer Header: \(ATSHOdometer_Command)")
				Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
					let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
					print("Run Command: In-ODOMETER")
					self.generateTxtCommandLogs(data: data)
					self.generateTxtCommandLogs(data: "Odometer PID: \(odometerPIDCommand)")
					Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
						self.generateTxtCommandLogs(data: data)
						testCommand.deviceReponse = data
						print("Run Command: Out-ODOMETER")
						
						onCompletion!(testCommand)
					})
				})
				
			}
		case .ENERGY_TO_EMPTY:
			break
		case .BMS_CAPACITY:
			break
		case .PACK_TEMPERATURE:
			if let header = testCommand.challenge?.header {
				guard let pid = testCommand.challenge?.pid else { return }
				let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
				self.generateTxtCommandLogs(data: "Pack Temerature Header: \(ATSHOdometer_Command)")
				Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
					
					
					self.generateTxtCommandLogs(data: data)
					
					let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
					print("Run Command: In-PackTemperature")
					self.generateTxtCommandLogs(data: "Pack Temparature PID: \(odometerPIDCommand)")
					Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
						print("Run Command: Out-PackTemperature")
						self.generateTxtCommandLogs(data: data)
						testCommand.deviceReponse = data
					
						onCompletion!(testCommand)
					})
				})
				
				
			}
			
			break
		case .PACK_VOLTAGE:
			if let header = testCommand.challenge?.header {
				guard let pid = testCommand.challenge?.pid else { return }
				let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
				self.generateTxtCommandLogs(data: "Pack Voltage Header: \(ATSHOdometer_Command)")
				Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
					
					self.generateTxtCommandLogs(data: data)
					
					let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
					print("Run Command: In-PackVoltage")
					
					self.generateTxtCommandLogs(data: "Pack Voltage PID: \(odometerPIDCommand)")
					
					Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
						print("Run Command: Out-PackVoltage")
						self.generateTxtCommandLogs(data: data)
						testCommand.deviceReponse = data
						
						onCompletion!(testCommand)
					
					})
				})
				
			}
			
			break
		case .PACK_CURRENT:
			if let header = testCommand.challenge?.header {
				guard let pid = testCommand.challenge?.pid else { return }
				let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
				self.generateTxtCommandLogs(data: "Pack Current Header: \(ATSHOdometer_Command)")
				Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
					
					self.generateTxtCommandLogs(data: data)
					let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
					print("Run Command: In-PackCurrent")
					self.generateTxtCommandLogs(data: "Pack current PID: \(odometerPIDCommand)")
					Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
					
						self.generateTxtCommandLogs(data: data)
						testCommand.deviceReponse = data
						print("Run Command: Out-PackCurrent")
					
						onCompletion!(testCommand)
					})
				})
				
			}
			
			break
		case .CELL_VOLTAGE:
			if let header = testCommand.challenge?.header {
				guard let pid = testCommand.challenge?.pid else { return }
				let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
				
				self.generateTxtCommandLogs(data: "Cell Voltage Header: \(ATSHOdometer_Command)")
				Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
					
					self.generateTxtCommandLogs(data: data)
					let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
					self.generateTxtCommandLogs(data: "Cell Voltage PID: \(odometerPIDCommand)")
					print("Run Command: In-CellVoltage")
					Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data in
						testCommand.deviceReponse = data
						print("Run Command: Out-CellVoltage")
						self.generateTxtCommandLogs(data: data)
						onCompletion!(testCommand)
						
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
		//84
		//onCompletion!(testCommand)
	}
	
	private func runCommandThatNeedToRunInLoop() {
		let totalNumberOfCommands: Int = sampledCommandsList.count
		if (isTimeInProgress == true) {
			//			print("is time in progress:", isTimeInProgress)
			if (commandToRunInLoopIndex < totalNumberOfCommands) {
				let command = sampledCommandsList[commandToRunInLoopIndex]
				//for item in sampledCommandsList {
				//					print("TIME BOOL:::-runCommandThatNeedToRunInLoop in IF", isTimeInProgress)
				//					print("loop index in if", self.commandToRunInLoopIndex)
				//				    print("LOOP ITEM",command.type as Any)
				//					print("Command request",  command.reqeustByteInString)
				self.countLoopCommand += 1
				self.runTheCommand(indexValue: commandToRunInLoopIndex, testCommand: command , onCompletion: { [self]command in
					//dispatchGroup.enter()
					self.totalNumberOfPidCommandsRan += 1
					//sleep(4)
					self.parseResponse(testCommand: command, index: commandToRunInLoopIndex)
					if (self.commandToRunInLoopIndex == totalNumberOfCommands - 1) {
						self.numberOfLogicsParsed += 1
						//print("NUMBER OF LOGICS RUN", self.numberOfLogicsParsed)
						self.commandToRunInLoopIndex  = 0
					} else {
						self.commandToRunInLoopIndex += 1
						//print("NUMBER PIDS IN LOOP RUN", self.commandToRunInLoopIndex)
					}
					//print("GOOD ONE")
					self.runCommandThatNeedToRunInLoop()
				})
				
			}
		} else {
			// loopCount intial value -1 , delay 25sec , prepare CSV fiels
			if loopCount == -1 {
				print("TIME BOOL:::-runCommandThatNeedToRunInLoopEin ELSE\(Date().description)", isTimeInProgress)
				
			}
			loopCount += 1
			
			if loopCount == (countLoopCommand - 2) {
				print("*********BLE reponse is finished**********")
				self.generateTxtCommandLogs(data: "*********BLE reponse is finished**********")
				// CSV file generation
				//self.saveLogsIntoTxtFile()
				self.getTransectionId()
				self.preparingLogicForCSVFileGeration()
				self.submitBatteryDataFileWithSOCGraphRequest()
			}
			print("Loop Count:::", loopCount)
			print("TOTAL Count:::countLoopCommand:::>", self.countLoopCommand)
		}
	}
	
	private func parseResponse(testCommand: TestCommandExecution?, index: Int) {
		
		
		guard let reponseData = testCommand?.deviceReponse, !reponseData.contains("OK") else { return  }
		
		//	print("IN PARSE METHOD", testCommand?.type as Any)
		switch testCommand?.type {
		case .ODOMETER:
			
			if testCommand?.deviceReponse != nil {
				
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				if haxValueList.count > 0 {
					let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)//calculateValueFromStartEndByte(command, hexValuesList)
					self.odometer = value
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(self.odometer)"
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					//print("message", message)
					
				}
			}
			//stopLoopExecution(group: group)
			break
		case .STATEOFCHARGE:
			
			if testCommand?.deviceReponse != nil {
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				if haxValueList.count > 0 {
					let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
					self.stateOfCharge = value
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(value)"
					//print(message)
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					
				}
			}
			//stopLoopExecution(group: group)
			break
		case .ENERGY_TO_EMPTY:
			
			if testCommand?.deviceReponse != nil {
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				if haxValueList.count > 0 {
					let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)//calculateValueFromStartEndByte(command, hexValuesList)
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(value)"
					print(message)
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					
				}
			}
			//stopLoopExecution(group: group)
			break
		case .BMS_CAPACITY:
			
			if testCommand?.deviceReponse != nil {
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				if haxValueList.count > 0 {
					let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)//calculateValueFromStartEndByte(command, hexValuesList)
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(value)"
					print(message)
					
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					
				}
			}
			//stopLoopExecution(group: group)
			break
		case .PACK_TEMPERATURE:
			//dispatchGroup.leave()
			if testCommand?.deviceReponse != nil {
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				if haxValueList.count > 0 {
					let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)//calculateValueFromStartEndByte(command, hexValuesList)
					packTemperature.append(value)
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(value)"
					//print(message)
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					
				}
			}
			//stopLoopExecution(group: group)
			break
		case .PACK_VOLTAGE:
			//dispatchGroup.leave()
			if testCommand?.deviceReponse != nil {
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				if haxValueList.count > 0 {
					let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)//calculateValueFromStartEndByte(command, hexValuesList)
					packVoltageData.append(value)
					//print("packVoltage:::::", packVoltageData)
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(value)"
					//print(message)
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					
				}
			}
			//stopLoopExecution(group: group)
			break
		case .PACK_CURRENT:
			//dispatchGroup.leave()
			if testCommand?.deviceReponse != nil {
				//let byteArray: [UInt8] = Array(testCommand?.deviceReponse ?? Data())
				if (testCommand?.deviceReponse?.count ?? 0) > 0 {
					let finalStringBytes = typeCastingByteToString(testCommand: testCommand)
					
					let haxValue = findFinalHexValue(haxVal: finalStringBytes, startByete: testCommand?.response?.startByte ?? 0, endByte: testCommand?.response?.endByte ?? 0)
					let decimalValue = fromHaxToDecimal(haxValue: haxValue)
					
					let sevenfffDecimalValue = self.fromHaxToDecimal(haxValue: Constants.SEVEN_FFF)
					let allFDecimalValue = self.fromHaxToDecimal(haxValue: Constants.ALL_F)
					let multiplier = testCommand?.response?.multiplier ?? 1
					
					if decimalValue < sevenfffDecimalValue {
						let packCurrentValue = (decimalValue * Int(multiplier)) * -1
						let constantValue = testCommand?.response?.constant ?? 0.0
						let finalValue = Double(packCurrentValue) + Double(constantValue)
						packCurrentData.append(finalValue)
						//print("pack Current data::", packCurrentData)
						let message = (testCommand?.type?.description ?? "") + "calculated value is \(finalValue)"
						//print(message)
						NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					} else {
						let packCurrentValue = ((allFDecimalValue - decimalValue) * Int(multiplier))
						let constantValue = testCommand?.response?.constant ?? 0.0
						let finalValue = Double(packCurrentValue) + Double(constantValue)
						packCurrentData.append(finalValue)
						//print("pack Current data::", packCurrentData)
						let message = (testCommand?.type?.description ?? "") + "calculated value is \(finalValue)"
						//print(message)
						NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					}
					
					print("pack current array data::", packCurrentData)
				}
			}
			//stopLoopExecution(group: group)
			break
		case .CELL_VOLTAGE:
			//dispatchGroup.leave()
			if testCommand?.deviceReponse != nil {
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				if haxValueList.count > 0 {
					let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)//calculateValueFromStartEndByte(command, hexValuesList)
					cellVoltageData.append(value)
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(value)"
					//print(message)
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					//print("cellVoltagedata:::", cellVoltageData)
					
				}
			}
			
			//stopLoopExecution(group: group)
			break
		case .BATTERY_AGE:
			
			if testCommand?.deviceReponse != nil {
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				if haxValueList.count > 0 {
					let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)//calculateValueFromStartEndByte(command, hexValuesList)
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(value)"
					//print(message)
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					
				}
			}
			//stopLoopExecution(group: group)
			break
		case .DIAGNOSTIC_SESSION:
			
			if testCommand?.deviceReponse != nil {
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				if haxValueList.count > 0 {
					let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)//calculateValueFromStartEndByte(command, hexValuesList)
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(value)"
					//print(message)
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					
				}
			}
			//stopLoopExecution(group: group)
			break
		case .MISC_COMMANDS:
			
			if testCommand?.deviceReponse != nil {
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				if haxValueList.count > 0 {
					let value = calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)//calculateValueFromStartEndByte(command, hexValuesList)
					let message = (testCommand?.type?.description ?? "") + "calculated value is \(value)"
					//print(message)
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
					
				}
			}
			//stopLoopExecution(group: group)
			break
		case .none:
			break
		case .Other:
			break
		}
		
		
	}
	
	
	func getTransectionId()  {
		
		//TO-DO guard
		
		Network.shared.apollo.fetch(query: GetS3PreSingedUrlQuery(vin: vehicleInfo?.vin ?? "")) { result in
			// 3
			switch result {
				
			case .success(let graphQLResult):
				guard let _ = try? result.get().data else { return }
				if graphQLResult.data != nil {
					self.preSignedDelegate?.getTransactionIdInfo(viewModel: self)
					
					let getS3PreSingedData = graphQLResult.data?.resultMap["getS3PreSingedURL"]?.jsonValue//getS3PreSingedUrl
					var preSignedData : Data?
					do {
						preSignedData = try JSONSerialization.data(withJSONObject: getS3PreSingedData as Any)
					} catch {
						//print("Unexpected error: \(error).")
					}
					
					do {
						let decoder = JSONDecoder()
						let preSignedResponse = try decoder.decode(GetS3PreSingedURL.self, from: preSignedData!)
						self.transactionId = preSignedResponse.transactionID
						//print("transaction id::", preSignedResponse.transactionID)
						self.preSignedData = preSignedResponse
						self.generateTxtCommandLogs(data: "Transection id: \(preSignedResponse.transactionID)")
						//self.vehicleInformation = messages
												//self.delegate?.updateVehicleInfo(viewModel: self)
						//
					} catch DecodingError.dataCorrupted(let context) {
						print(context)
					} catch DecodingError.keyNotFound(let key, let context) {
						print("Key '\(key)' not found:", context.debugDescription)
						print("codingPath:", context.codingPath)
					} catch DecodingError.valueNotFound(let value, let context) {
						print("Value '\(value)' not found:", context.debugDescription)
						print("codingPath:", context.codingPath)
					} catch DecodingError.typeMismatch(let type, let context) {
						print("Type '\(type)' mismatch:", context.debugDescription)
						print("codingPath:", context.codingPath)
					} catch {
						print("error: ", error)
					}
				}
				
			case .failure(let error):
				// 5
				self.preSignedDelegate?.handleErrorTransactionID()
				print("Error loading data \(error)")
			}
		}
	}
	
	//MARK: - Convert each byte as string (typecasting)
	private func typeCastingByteToString(testCommand: TestCommandExecution?) -> [String] {
		
		guard let finalData = testCommand?.deviceReponse  else { return [""] }
		let trimmed = finalData.trimmingCharacters(in: .whitespacesAndNewlines)
		//print("trimmed", trimmed)
		
		switch testCommand?.type {
		case .PACK_VOLTAGE:
			let arrayOfStringBytes = trimmed.components(withMaxLength: 2)
			//			print("final Array of string Bytes", arrayOfStringBytes)
			//			print("TYPE::", testCommand?.type as Any)
			self.generateTxtCommandLogs(data: "\(arrayOfStringBytes)")
			return arrayOfStringBytes
		case .none:
			let arrayOfStringBytes = trimmed.components(withMaxLength: 2)
			//			print("final Array of string Bytes", arrayOfStringBytes)
			//			print("TYPE::", testCommand?.type as Any)
			self.generateTxtCommandLogs(data: "\(arrayOfStringBytes)")
			return arrayOfStringBytes
		case .some(.ODOMETER):
			let arrayOfStringBytes = trimmed.components(withMaxLength: 2)
			//			print("final Array of string Bytes", arrayOfStringBytes)
			//			print("TYPE::", testCommand?.type as Any)
			self.generateTxtCommandLogs(data: "\(arrayOfStringBytes)")
			return arrayOfStringBytes
		case .some(.STATEOFCHARGE):
			let arrayOfStringBytes = trimmed.components(withMaxLength: 2)
			//			print("final Array of string Bytes", arrayOfStringBytes)
			//			print("TYPE::", testCommand?.type as Any)
			self.generateTxtCommandLogs(data: "\(arrayOfStringBytes)")
			return arrayOfStringBytes
		case .some(.ENERGY_TO_EMPTY):
			let arrayOfStringBytes = trimmed.components(withMaxLength: 2)
			//			print("final Array of string Bytes", arrayOfStringBytes)
			//			print("TYPE::", testCommand?.type as Any)
			self.generateTxtCommandLogs(data: "\(arrayOfStringBytes)")
			return arrayOfStringBytes
		case .some(.BMS_CAPACITY):
			let arrayOfStringBytes = trimmed.components(withMaxLength: 2)
			//			print("final Array of string Bytes", arrayOfStringBytes)
			//			print("TYPE::", testCommand?.type as Any)
			self.generateTxtCommandLogs(data: "\(arrayOfStringBytes)")
			return arrayOfStringBytes
		case .some(.PACK_TEMPERATURE):
			let arrayOfStringBytes = trimmed.components(withMaxLength: 2)
			//			print("final Array of string Bytes", arrayOfStringBytes)
			//			print("TYPE::", testCommand?.type as Any)
			self.generateTxtCommandLogs(data: "\(arrayOfStringBytes)")
			return arrayOfStringBytes
		case .some(.PACK_CURRENT):
			let arrayOfStringBytes = trimmed.components(withMaxLength: 2)
			//			print("final Array of string Bytes", arrayOfStringBytes)
			//			print("TYPE::", testCommand?.type as Any)
			self.generateTxtCommandLogs(data: "\(arrayOfStringBytes)")
			return arrayOfStringBytes
		case .some(.CELL_VOLTAGE):
			let arrayOfStringBytes = trimmed.components(withMaxLength: 2)
			//			print("final Array of string Bytes", arrayOfStringBytes)
			//			print("TYPE::", testCommand?.type as Any)
			self.generateTxtCommandLogs(data: "\(arrayOfStringBytes)")
			return arrayOfStringBytes
		case .some(.BATTERY_AGE):
			let arrayOfStringBytes = trimmed.components(withMaxLength: 2)
			//			print("final Array of string Bytes", arrayOfStringBytes)
			//			print("TYPE::", testCommand?.type as Any)
			self.generateTxtCommandLogs(data: "\(arrayOfStringBytes)")
			return arrayOfStringBytes
		case .some(.DIAGNOSTIC_SESSION):
			let arrayOfStringBytes = trimmed.components(withMaxLength: 2)
			//			print("final Array of string Bytes", arrayOfStringBytes)
			//			print("TYPE::", testCommand?.type as Any)
			self.generateTxtCommandLogs(data: "\(arrayOfStringBytes)")
			return arrayOfStringBytes
		case .some(.MISC_COMMANDS):
			let arrayOfStringBytes = trimmed.components(withMaxLength: 2)
			//			print("final Array of string Bytes", arrayOfStringBytes)
			//			print("TYPE::", testCommand?.type as Any)
			self.generateTxtCommandLogs(data: "\(arrayOfStringBytes)")
			return arrayOfStringBytes
		case .some(.Other):
			let arrayOfStringBytes = trimmed.components(withMaxLength: 2)
			//			print("final Array of string Bytes", arrayOfStringBytes)
			//			print("TYPE::", testCommand?.type as Any)
			self.generateTxtCommandLogs(data: "\(arrayOfStringBytes)")
			return arrayOfStringBytes
		}
		
	}
	
	private func submitBatteryDataFileWithSOCGraphRequest() {
		//SubmitBatteryDataFileWithSOC
		let vehicalBatteryDataFile = SubmitBatteryDataFilesVehicleInput.init(vin: vehicleInfo?.vin ?? "", make: vehicleInfo?.make ?? "", model: vehicleInfo?.modelName ?? "", year: vehicleInfo?.year ?? 0)
		let batteryInstr = vehicleInfo?.getBatteryTestInstructions
		
		guard let vehicleProfile = batteryInstr?[0].testCommands?.vehicleProfile else {return}
		guard let stateOfHealth = batteryInstr?[0].testCommands?.stateOfHealthCommands else {return}
		let submitBatteryDataVehicleProfileInput = SubmitBatteryDataVehicleProfileInput(nominalVoltage: vehicleProfile.nominalVoltage ?? 1.0, energyAtBirth:vehicleProfile.energyAtBirth ?? 1.0, batteryType: BatteryType.lithium, capacityAtBirth: vehicleProfile.capacityAtBirth ?? 1.0)
		
		let stateOfChargePropsInput = StateOfChargePropsInput(stateOfCharge: self.stateOfCharge ?? 0.0, currentEnergy: stateOfHealth.energyToEmpty)
		//"Cell_Volt_\(self.vehicleInfo?.vin ?? "")"
		//"Pack_Voltage_\(self.vehicleInfo?.vin ?? "")"
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
						print("Unexpected error: \(error).")
					}
					print(getS3PreSingedData.jsonValue)
					do {
						let decoder = JSONDecoder()
						//let preSignedResponse = try decoder.decode(SubmitBatteryDataFileWithSOC.self, from: preSignedData!)
						//self.transactionId = preSignedResponse.transactionID
						//print("transaction id::", preSignedResponse.transactionID)
						//	self.preSignedData = preSignedResponse
						//self.vehicleInformation = messages
						
						//self.delegate?.updateVehicleInfo(viewModel: self)
						// CSV file generation
						
						//self.preparingLogicForCSVFileGeration()
						
						//
					} catch DecodingError.dataCorrupted(let context) {
						print(context)
					} catch DecodingError.keyNotFound(let key, let context) {
						print("Key '\(key)' not found:", context.debugDescription)
						print("codingPath:", context.codingPath)
					} catch DecodingError.valueNotFound(let value, let context) {
						print("Value '\(value)' not found:", context.debugDescription)
						print("codingPath:", context.codingPath)
					} catch DecodingError.typeMismatch(let type, let context) {
						print("Type '\(type)' mismatch:", context.debugDescription)
						print("codingPath:", context.codingPath)
					} catch {
						print("error: ", error)
					}*/
				}
				
			case .failure(let error):
				// 5
				self.preSignedDelegate?.handleErrorTransactionID()
				print("Error loading data \(error)")
			}
			//print("submitBatteryDataFileWithSOCGraphRequest::::>",result)
		}
		
	}
	
	private func calculateValueFromStartEndByte(command: TestCommandExecution?, hexValuesList: [String]) -> Double {
		
		let haxValue = findFinalHexValue(haxVal: hexValuesList, startByete: command?.response?.startByte ?? 0, endByte: command?.response?.endByte ?? 0)
		let decimalValue = fromHaxToDecimal(haxValue: haxValue)
		let multiplierValue = Double(decimalValue) * (Double(command?.response?.multiplier ?? 1.0))
		let constantValue = command?.response?.constant ?? 0.0
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
	
	
	
	func fromHaxToDecimal(haxValue: String) -> Int {
		let decimalValue = Int(haxValue, radix: 16) ?? 0
		return decimalValue
	}
	
	func preparingLogicForCSVFileGeration() {
		// TODO clear the min validation
		let listCount: [Int] = [self.packCurrentData.count, self.packVoltageData.count]
		let minVlaue = listCount.max() ?? 0
		print("min value from count array", minVlaue)
		
		
		//TO-DO handle zero size
		
		//let finalPackCurrent = packCurrentData[0...minVlaue - 2]
		self.createPackCurrentCSVFile(data: packCurrentData)
		
		//let finalPackVoltage = packVoltageData[0...minVlaue - 2]
		createPackVoltageCSV(data: packVoltageData)

		let cellVoltageCount = sampledCommandsList.count
		var result = cellVoltageData.chunked(into: cellVoltageCount)
		print("result", result)
		print("before process result count", result.count)
		guard let resultLastValue = result.last else { return  }
		
		if resultLastValue.count < cellVoltageCount {
			result.removeLast()
		} else {
			print("after process result count", result.count)
		}
		print("after process result count", result.count)
		self.createCellVoltageCSV(data: result)
		
	}
	
	//MARK: Create pack current CSV
	func createPackCurrentCSVFile(data: [Double] ) {
		
		let floatDataArray = Array(data)
		let pack_Current = CSVFile(csvArray: [floatDataArray], fileName: "Pack_Current_\(self.vehicleInfo?.vin ?? "")")
		
		csvDispatchGroup.enter()
		let pack_CurrentFilePath = pack_Current.generateCSVFile()
		csvFileUploadingIntoS3Bucket(fileName: pack_CurrentFilePath)
		self.generateTxtCommandLogs(data: pack_CurrentFilePath)
	
	}
	
	// MARK: Create pack voltage CSV
	func createPackVoltageCSV(data: [Double]) {
		let floatDataArray = Array(data)
		let pack_Voltage = CSVFile(csvArray: [floatDataArray], fileName: "Pack_Voltage_\(self.vehicleInfo?.vin ?? "")")
		
		csvDispatchGroup.enter()
		let pack_VoltageFilePath = pack_Voltage.generateCSVFile()
		csvFileUploadingIntoS3Bucket(fileName: pack_VoltageFilePath)
		self.generateTxtCommandLogs(data: pack_VoltageFilePath)
		
	}
	
	// MARK: Create Cell Voltage CSV
	func createCellVoltageCSV(data: [[Double]]) {
		
		let cell_voltage = CSVFile(csvArray: data, fileName: "Cell_Volt_\(self.vehicleInfo?.vin ?? "")")
		
		csvDispatchGroup.enter()
		let cellVoltageFilePath = cell_voltage.generateCSVFile()
		csvFileUploadingIntoS3Bucket(fileName: cellVoltageFilePath)
		self.generateTxtCommandLogs(data: cellVoltageFilePath)
	}
	
	func csvFileUploadingIntoS3Bucket(fileName: String) {
		
		guard let presinedData = self.preSignedData else { return }
		
		var multipart = MultipartRequest()
		for field in [
			"key": presinedData.fields.key,
			"AWSAccessKeyId": presinedData.fields.awsAccessKeyID,
			"x-amz-security-token": presinedData.fields.xamzSecurityToken,
			"policy": presinedData.fields.policy,
			"signature": presinedData.fields.signature
		] {
			multipart.add(key: field.key, value: field.value)
		}
		
		multipart.add(
			key: "file",
			fileName: "\(fileName)",
			fileMimeType: "text/csv",
			fileData: "csvData".data(using: .utf8)!
		)
		
		/// Create a regular HTTP URL request & use multipart components
		let url = URL(string: "\(presinedData.url)")!
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue(multipart.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
		request.httpBody = multipart.httpBody
		
		/// Fire the request using URL sesson or anything else...
		let session =  URLSession.shared
		let dataTask = session.dataTask(with: request) { data, response, error in
			self.csvDispatchGroup.leave()
			guard let _ = data else {
				print("json data response Error")
				return
			}
			print("file uploaded succesfully...")
		}
		dataTask.resume()
		
		self.csvDispatchGroup.notify(queue: .main) {
			print("all CSV files uploaded successfully...!")
			
		}
		
	}
	
	func generateTxtCommandLogs(data: String) {
		print("command data: ", data)
		textCommands += "\(data)"
		textCommands += "\n"
		print("text command:::::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>", textCommands)
	}
	
	func saveLogsIntoTxtFile() -> String {
		print("Logs::::", self.textCommands)
		if self.textCommands.count > 2 {
		let text = self.textCommands
		let folder = "Acelite"
		let timeStamp = Date.currentTimeStamp
		let fileNamed = "\(timeStamp)"
		guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return  ""}
		guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else { return ""}
		try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
		let file = writePath.appendingPathComponent(fileNamed + ".txt")
			print("file path:::", file)
		try? text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
			// alert
			//
			// generated file stored in your phone file folder with app name.
			print("file path:::", file)
		return file.absoluteString
		
//		var filesSharing = [Any]()
//		filesSharing.append(file)
//		let activityViewController = UIActivityViewController(activityItem: filesSharing, applicationActivities: nil)
		
		} else {
			// alert logs not generated
			print("logs not generated")
			return ""
		}
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

