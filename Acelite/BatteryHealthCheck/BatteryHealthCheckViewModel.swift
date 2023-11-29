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
	//private var normalCommandsList = [TestCommandExecution]()
	private var normalCommandsIndex = 0
	//public var sampledCommandsList = [TestCommandExecution]()
	public var commandToRunInLoopIndex: Int = 0
	private var totalNumberOfPidCommandsRan = 0 // verify
	private var numberOfLogicsParsed = 0  // verify
	//private var isDiagnosticSession: Bool = false
	//public var diagnosticCommand: TestCommandDiagnosticExecution?
	public var vehicleInfo: Vehicle?
	public var numberOfCells: Int?
	public var packVoltageData = [Double]()
	public var packVoltageArray = [[String: Any]]()
	public var packCurrentData = [Double]()
	public var packCurrentArray = [[String: Any]]()
	public var packTemperatureData = [Double]()
	public var cellVoltageData = [Double]()
	public var cellVoltageArray = [[String: Any]]()
	var startTime = ""
	public var multiCellVoltageData = [[Double]]()
	public var multiCellVoltageArray = [[String: Any]]()
	public var stateOfCharge: Double?
	public var bms: Double?
	public var currentEnergy: Double?
	public var workOrder: String?
	public var odometer: Double?
	private var transactionId: String?
	weak var preSignedDelegate: GetPreSignedUrlDelegate? = nil
	weak var uploadAndSubmitDelegate: UploadAndSubmitDataDelegate? = nil
	var loopCount: Int = -1
	var isJSON: Bool = false
 //   var preSignedData: GetS3PreSingedURL?
  //  var countLoopCommand: Int = 0
	private var previousFlowControlData: String? = nil
	let loopConcurrentQueue = DispatchQueue(label: "com.acelite.concurrent", attributes: .concurrent)
	
	let loopDispatch = DispatchQueue.global(qos: .userInitiated)
	init(vehicleInfo: Vehicle, workOrder: String?) {
		self.vehicleInfo = vehicleInfo
		self.workOrder = workOrder
	}
	
	
	private func stopTimer() {
		if self.isTimeInProgress == false {
			self.runCommandThatNeedToRunInLoop()
			
		}
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
//		guard let elm327ProtoclStateChange = testCommands?.stateOfCharge?.odometerProtocol?.elm327ProtocolPreset else {
//			return
//		}
		guard let elm327Sampled = testCommands?.sampledCommands?.sampledCommandsProtocol?.elm327ProtocolPreset else { return
		}
		if elm327ProtocolOdometer.count > 0 {
			self.elm327ProtocolPreset = elm327ProtocolOdometer
			return
		}
//		else if elm327ProtoclStateChange.count > 0 {
//			self.elm327ProtocolPreset = elm327ProtoclStateChange
//			return
//		}
		else
		if elm327Sampled.count > 0 {
			self.elm327ProtocolPreset = elm327Sampled
			return
		} else {
			self.elm327ProtocolPreset = Constants.DEFAULT_PROTOCOL
		}
		initialCommand()
	}
	
	// Executing Commands
	 func initialCommand() {
	
			let ATZ_Command = Constants.ATZ + Constants.NEW_LINE_CHARACTER
			print(Date(), "Inital Commands", to: &Log.log)
		Network.shared.bluetoothService?.writeBytesData(instructionType: .NONE, commandType: .Other, data: ATZ_Command, completionHandler: { data in
//			Network.shared.bluetoothService?.writeBytesData(data: ATZ_Command, completionHandler: { data in
				//print(Date(), "about to perform ATZ command write", to: &Log.log)
				self.runATE0Command()
			})
		
	}
	
	private func runATE0Command() {
		let ATE0_Command = Constants.ATE0 + Constants.NEW_LINE_CHARACTER
//		Network.shared.bluetoothService?.writeBytesData(data: ATE0_Command, completionHandler: { data in
			//print(Date(), "about to perform ATE0 command write", to: &Log.log)
		Network.shared.bluetoothService?.writeBytesData(instructionType: .NONE, commandType: .Other, data: ATE0_Command, completionHandler: { data in
			self.runATS0Command()
		})
	}
	
	private func runATS0Command() {
		
			let ATS0_Command =  Constants.ATS0 + Constants.NEW_LINE_CHARACTER
//			Network.shared.bluetoothService?.writeBytesData(data: ATS0_Command, completionHandler: { data in
		Network.shared.bluetoothService?.writeBytesData(instructionType: .NONE, commandType: .Other, data: ATS0_Command, completionHandler: { data in
				//print(Date(), "about to perform ATS0 command write", to: &Log.log)
				self.runProtocolCommand()
			})
		
	}
	
	private func runProtocolCommand() {
		guard let testCommand = vehicleInfo?.getBatteryTestInstructions, testCommand.count > 0 else {
			return
		}
		let testCommands = testCommand[0].testCommands
		self.numberOfCells = testCommands?.sampledCommands?.cellVoltage.count

			let elmValue = self.elm327ProtocolPreset?.replacingOccurrences(of: "_", with: "")
			let ATSP_Command = Constants.ATSP + "\(elmValue ?? Constants.DEFAULT_PROTOCOL)" + Constants.NEW_LINE_CHARACTER
//			Network.shared.bluetoothService?.writeBytesData(data: ATSP_Command, completionHandler: { data in
		Network.shared.bluetoothService?.writeBytesData(instructionType: .NONE, commandType: .Other, data: ATSP_Command, completionHandler: { data in

				print(Date(), "about to perform protocol command write", to: &Log.log)
			if Network.shared.isDiagnosticSession == true {
					self.runDiagnosticCommand()
				} else {
					self.runNormalCommands()
				}
				
			})
		
	}
	
	private func runDiagnosticCommand() {
		if let header = Network.shared.diagnosticCommand?.challenge?.header {
			guard let pid = Network.shared.diagnosticCommand?.challenge?.pid else { return }
		
				let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
//				Network.shared.bluetoothService?.writeBytesData(data: ATSHOdometer_Command, completionHandler: { data in
			Network.shared.bluetoothService?.writeBytesData(instructionType: .NONE, commandType: .DIAGNOSTIC_SESSION, data: ATSHOdometer_Command, completionHandler: { data in
						//print(Date(), "about to perform Diagnostic command write", to: &Log.log)
						let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
//						Network.shared.bluetoothService?.writeBytesData(data: odometerPIDCommand, completionHandler: { data1 in
				Network.shared.bluetoothService?.writeBytesData(instructionType: .NONE, commandType: .DIAGNOSTIC_SESSION, data: odometerPIDCommand, completionHandler: { data1 in
					Network.shared.isDiagnosticSession  = false
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
		let totalNumberOfCommands = Network.shared.normalCommandsList.count
		if (isTimeInProgress) {
			if (normalCommandsIndex < totalNumberOfCommands) {
				let command = Network.shared.normalCommandsList[normalCommandsIndex]
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
	
	private func executeNormalHeaderAndPidCommands(testCommand: TestCommandExecution, onCompletion: ((_ command : TestCommandExecution?) -> ())?) {
		if let header = testCommand.challenge?.header {
			guard let pid = testCommand.challenge?.pid else { return }
			
			let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
			Network.shared.bluetoothService?.writeBytesData(instructionType: .HEADER, commandType: testCommand.type, data: ATSHOdometer_Command, completionHandler: { data in
						let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
				self.startTime = self.getStartTime()
				Network.shared.bluetoothService?.writeBytesData(instructionType: .PID, commandType: .ODOMETER, data: odometerPIDCommand, completionHandler: { data1 in
							testCommand.deviceData = data1
					print(Date(), "Command:  \(testCommand.type) - Response: \(data1)", to: &Log.log)
							onCompletion!(testCommand)
						})
					
				})
			
		}
	}
	
	private func runTheCommand(indexValue: Int, testCommand: TestCommandExecution, onCompletion: ((_ command : TestCommandExecution?) -> ())?) {
		
		if let flowControl = testCommand.challenge?.flowControl {
			self.excecuteFlowControlHeaderAndData(flowControl: flowControl, testCommand: testCommand) { handler in
				self.executeNormalHeaderAndPidCommands(testCommand: testCommand, onCompletion: onCompletion)
			}
		} else {
			self.executeNormalHeaderAndPidCommands(testCommand: testCommand, onCompletion: onCompletion)
		}
		
	}
	
	private func excecuteFlowControlHeaderAndData(flowControl: FlowControl, testCommand: TestCommandExecution , onCompletion: ((_ command : TestCommandExecution?) -> ())?) {
		var isFlowControlChanged: Bool = false
		
			let flowcontrolHeader = Constants.ATFCSH + flowControl.flowControlHeader! + Constants.NEW_LINE_CHARACTER
		
		Network.shared.bluetoothService?.writeBytesData(instructionType: .FLOW_CONTROL_HEADER, commandType: testCommand.type,  data: flowcontrolHeader, completionHandler: { data in
					if self.previousFlowControlData ==  flowControl.flowControlData {
						isFlowControlChanged = false
					} else {
						isFlowControlChanged = true
						self.previousFlowControlData = flowControl.flowControlData
					}
					let flowControlData = Constants.ATFCSD + flowControl.flowControlData! + Constants.NEW_LINE_CHARACTER
			self.startTime = self.getStartTime()
			Network.shared.bluetoothService?.writeBytesData(instructionType: .FLOW_CONTROL_DATA, commandType: testCommand.type,   data: flowControlData, completionHandler: { data in
						if isFlowControlChanged {
							let flowControlChangedCommand = Constants.ATFCSM1 + Constants.NEW_LINE_CHARACTER
			Network.shared.bluetoothService?.writeBytesData(instructionType: .FLOW_CONTROL_NORMAL_COMMAND, commandType: testCommand.type,   data: flowControlChangedCommand, completionHandler: { data in

								testCommand.deviceData = data
								onCompletion!(testCommand)
							})
						} else {
							onCompletion!(testCommand)
						}
					})
			})
	}
	
	private func runCommandThatNeedToRunInLoop() {
		let totalNumberOfCommands: Int = Network.shared.sampledCommandsList.count
		if (isTimeInProgress == true) {
			if (commandToRunInLoopIndex < totalNumberOfCommands) {
				let command = Network.shared.sampledCommandsList[commandToRunInLoopIndex]
				self.runTheCommand(indexValue: self.commandToRunInLoopIndex, testCommand: command , onCompletion: { [self]command in
					self.totalNumberOfPidCommandsRan += 1
					print(Date(), "PID command run value \(totalNumberOfPidCommandsRan)", to: &Log.log)
				//	DispatchQueue.global(qos: .background).async {
						self.parseResponse(testCommand: command, index: self.commandToRunInLoopIndex)
					//}
					
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
				//DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
					self.preSignedDelegate?.navigateToAnimationVC()
					//DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
						self.uploadAndSubmitDelegate?.navigateToHealthScoreVC()
					//}
				//}
				
			}
			loopCount += 1
		}
	}
	
	private func parseResponse(testCommand: TestCommandExecution?, index: Int) {
		//let concurrentQueue = DispatchQueue(label: "swiftlee.concurrent.queue", attributes: .concurrent)
		self.loopDispatch.async {

			guard let responseData = testCommand?.deviceData else { return  }
			let parseData: String = String.init(data: responseData, encoding: .utf8) ?? ""

			//		guard let reponseData = testCommand?.deviceData, reponseData.count > 0 else { return  }
		
			if parseData.contains(Constants.QUESTION_MARK) || parseData.contains(Constants.NODATA) || parseData.contains(Constants.NO_DATA) || parseData.contains(Constants.ERROR) {
			return
		}
			var responseDataInString: String = "" // local variable
			if  parseData.contains(":") {
				let removeSpaces = parseData.trimmingCharacters(in: .whitespacesAndNewlines)
				let splitString = removeSpaces.components(separatedBy: "\r")
				for item in splitString {
					let newitem = item.trimmingCharacters(in: .whitespacesAndNewlines)
					let sliptWithColen = newitem.components(separatedBy: ":")
					//print("split with colon", sliptWithColen)
					if sliptWithColen.count == 2 {
						responseDataInString.append(sliptWithColen[1]) // appending data
						//testCommand?.deviceReponse.append(sliptWithColen[1])
					} else {
//						if testCommand?.challenge?.flowControl == nil {
//							responseDataInString.append(newitem)
//						}
							
	
					}
				}
			
			} else {
				if testCommand?.challenge?.flowControl == nil {
					responseDataInString.append(parseData)
				}
				// below code commented
				//let removeSpaces = parseData.trimmingCharacters(in: .whitespacesAndNewlines)
				//testCommand?.deviceReponse.append(removeSpaces)
				
			}
			testCommand?.deviceReponse = responseDataInString // add to test command device response
			//print("device Response in String", responseDataInString)
			//print("testCommand Device Response::::", testCommand?.deviceReponse ?? "")
		
			if let deviceByteArray = testCommand?.deviceReponse, deviceByteArray.count > 0 {
				let startByte = testCommand?.response?.startByte ?? 0
				print(Date(), "Start Byte\(startByte)", to: &Log.log)
				let endByte = testCommand?.response?.endByte ?? 0
				print(Date(), "End Byte\(endByte)", to: &Log.log)
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				print(Date(), "Haxa list\(haxValueList)", to: &Log.log)
				if (haxValueList.count - 1) < endByte {
					return
				}
				//print(Date(), "Hex Value\(haxValueList)", to: &Log.log)
				//print("HEX Value  :  Command",haxValueList, testCommand?.type )
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
						if self.isJSON == true {
							let packDict = ["start": self.startTime, "voltage": value, "stop": self.getStartTime()] as [String : Any]
							self.packVoltageArray.append(packDict)
						} else {
							self.packVoltageData.append(value)
						}
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
						
						if self.isJSON == true {
						let packCurrentDict = ["start": self.startTime, "current": finalValue, "stop": self.getStartTime()] as [String : Any]
						self.packCurrentArray.append(packCurrentDict)
						} else {
							self.packCurrentData.append(finalValue)
						}
						print(Date(), "Final Pack Current Value \(finalValue)", to: &Log.log)
					}
					break
				case .CELL_VOLTAGE:
					if let _ = testCommand?.challenge?.flowControl {
						let cellVoltArray = self.handlingMultiframeString(testCommand: testCommand)
						//print("cell volt array", cellVoltArray)
						
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
			print(Date(), "Haxa List \(haxValueList)", to: &Log.log)
			let haxValue = FlowfindFinalHexValue(haxVal: haxValueList, startByete: startByte, endByte: endByte)
			//print(Date(), "Final Byte Array\(endByte)", to: &Log.log)
			let chunkArray = haxValue.chunked(into: testCommand?.response?.bytesPerCell ?? 0)
			//print(Date(), "Divided in chunks of Array\(chunkArray)", to: &Log.log)
			let totalCells = testCommand?.response?.numberOfCells
			var finalValuesArray = [Double]()
			var arrayCell = [[String: Any]]()
			if chunkArray.count == totalCells {
				var index = 0
				for item in chunkArray {
					
					//print("Cell Number::::::", index)
					var dictCell = [String: Any]()
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
					
					if self.isJSON == true {
						index += 1
						dictCell["cellNumber"] = index
						dictCell["voltage"] = finalValue
						arrayCell.append(dictCell)
					}
					
					let message = (testCommand?.type.description ?? "") + "calculated value is \(finalValue)"
					NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "\(message)"], userInfo: nil)
				}
			}
			if self.isJSON == true {
				var dict = [String: Any]()
				dict["start"] = self.startTime
				dict["cellVoltageScan"] = arrayCell
				dict["stop"] = self.getStartTime()
				self.multiCellVoltageArray.append(dict)
			} else {
				multiCellVoltageData.append(finalValuesArray)
			}
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
	
	private  func getStartTime() -> String {
		let dateString = Date().iso8601withFractionalSeconds
		//print("DATE:::::::", dateString)
		  return dateString
	  }
	//iso8601
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

extension ISO8601DateFormatter {
	convenience init(_ formatOptions: Options) {
		self.init()
		self.formatOptions = formatOptions
	}
}

extension Formatter {
	static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}
extension Date {
	var iso8601withFractionalSeconds: String { return Formatter.iso8601withFractionalSeconds.string(from: self) }
}
extension String {
	var iso8601withFractionalSeconds: Date? { return Formatter.iso8601withFractionalSeconds.date(from: self) }
}
