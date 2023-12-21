//
//  UploadAnimationViewModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/6/23.
//


import Foundation
import UIKit
import FirebaseDatabase
import Firebase
import CoreData
import Apollo

protocol ShortProfileCommandsRunDelegate: AnyObject {
	func shortProfileCommandsCompleted(battteryHealth: BatteryScore?, minRange: Double?, maxRange: Double?, rangeAtBirth: Double?)
	func showShortProfileSubmitError(transactionID: String?, vinMake: String, message: String, vinModels: String, submitType: String, vinNumber: String, year: Int, errorCode: String)
	func shortProfileCommandExecutionError()
}

class UploadAnimationViewModel {
	var managedObject: NSManagedObject?
	var vehicleInfo:  Vehicle?
	public var stateOfCharge: Double?
	public var bms: Double?
	public var currentEnergy: Double?
	public var workOrder: String?
	public var odometer: Double?
	private var transactionId: String?
	var isJSON: Bool = false
	private var elm327ProtocolPreset: String?
	private var normalCommandsIndex = 0
	public var commandToRunInLoopIndex: Int = 0
	private var totalNumberOfPidCommandsRan = 0
	private var numberOfLogicsParsed = 0
	public var numberOfCells: Int?
	let loopDispatch = DispatchQueue.global(qos: .userInitiated)
	private var previousFlowControlData: String? = nil
	public var isShortProfile: Bool?
	weak var delegate: ShortProfileCommandsRunDelegate? = nil
	var previousHeader: String = ""
	
	init(vehicleInfo: Vehicle?, workOrder: String?, isShortProfile: Bool, managedObject: NSManagedObject) {
		self.vehicleInfo = vehicleInfo
		self.workOrder = workOrder
		self.isShortProfile = isShortProfile
		self.managedObject = managedObject
	}
	
	
	// Executing Commands
	func initialCommand() {
		
		let ATZ_Command = Constants.ATZ + Constants.NEW_LINE_CHARACTER
		print(Date(), "Inital Commands", to: &Log.log)
		Network.shared.bluetoothService?.writeBytesData(instructionType: .NONE, commandType: .Other, data: ATZ_Command, completionHandler: { data in
			print("Inital command ATZ")
			self.runATE0Command()
		})
		
	}
	
	private func runATE0Command() {
		let ATE0_Command = Constants.ATE0 + Constants.NEW_LINE_CHARACTER
		Network.shared.bluetoothService?.writeBytesData(instructionType: .NONE, commandType: .Other, data: ATE0_Command, completionHandler: { data in
			print("Inital command ATE0")
			self.runATS0Command()
		})
	}
	
	private func runATS0Command() {
		
		let ATS0_Command =  Constants.ATS0 + Constants.NEW_LINE_CHARACTER
		Network.shared.bluetoothService?.writeBytesData(instructionType: .NONE, commandType: .Other, data: ATS0_Command, completionHandler: { data in
			print("Inital command ATS0")
			self.runProtocolCommand()
		})
		
	}
	
	private func runProtocolCommand() {
		//		guard let testCommand = vehicleInfo?.getBatteryTestInstructions, testCommand.count > 0 else {
		//			return
		//		}
		//		let testCommands = testCommand[0].testCommands
		
		
		let elmValue = self.elm327ProtocolPreset?.replacingOccurrences(of: "_", with: "")
		let ATSP_Command = Constants.ATSP + "\(elmValue ?? Constants.DEFAULT_PROTOCOL)" + Constants.NEW_LINE_CHARACTER
		Network.shared.bluetoothService?.writeBytesData(instructionType: .NONE, commandType: .Other, data: ATSP_Command, completionHandler: { data in
			print("about to perform protocol command write")
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
			Network.shared.bluetoothService?.writeBytesData(instructionType: .NONE, commandType: .DIAGNOSTIC_SESSION, data: ATSHOdometer_Command, completionHandler: { data in
				let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
				Network.shared.bluetoothService?.writeBytesData(instructionType: .NONE, commandType: .DIAGNOSTIC_SESSION, data: odometerPIDCommand, completionHandler: { data1 in
					Network.shared.isDiagnosticSession  = false
					print("RUN Normal commands")
					self.runNormalCommands()
					return
					
				})
				
			})
			
		}
	}
	// MARK: - Normal Commands
	private func runNormalCommands() {
		print(Date(), "about to perform Normal commands", to: &Log.log)
		let totalNumberOfCommands = Network.shared.normalCommandsList.count
		
		if (normalCommandsIndex < totalNumberOfCommands) {
			let command = Network.shared.normalCommandsList[normalCommandsIndex]
			self.runTheCommand(indexValue: normalCommandsIndex, testCommand: command) { command in
				self.parseResponse(testCommand: command, index: self.normalCommandsIndex)
				if (self.normalCommandsIndex == totalNumberOfCommands - 1){
					
					print("Normal commands completed")
				} else {
					self.normalCommandsIndex += 1
					self.runNormalCommands()
				}
			}
		}
		
	}
	
	private func executeNormalHeaderAndPidCommands(testCommand: TestCommandExecution, onCompletion: ((_ command : TestCommandExecution?) -> ())?) {
		if let header = testCommand.challenge?.header {
			guard let pid = testCommand.challenge?.pid else { return }
			if previousHeader == header {
				let pidCommand = pid + Constants.NEW_LINE_CHARACTER
				
				Network.shared.bluetoothService?.writeBytesData(instructionType: .PID, commandType: .ODOMETER, data: pidCommand, completionHandler: { data1 in
							testCommand.deviceData = data1
					print(Date(), "Command:  \(testCommand.type) - Response: \(data1)", to: &Log.log)
							onCompletion!(testCommand)
						})
			} else {
				let ATSHOdometer_Command =  Constants.ATSH + header + Constants.NEW_LINE_CHARACTER
				Network.shared.bluetoothService?.writeBytesData(instructionType: .HEADER, commandType: testCommand.type, data: ATSHOdometer_Command, completionHandler: { data in
					let odometerPIDCommand = pid + Constants.NEW_LINE_CHARACTER
					self.previousHeader = header
					if let canCommand = testCommand.challenge?.canMask, let canFilterCommand = testCommand.challenge?.canFilter {
						let canMask =  Constants.ATCM + canCommand + Constants.NEW_LINE_CHARACTER
						Network.shared.bluetoothService?.writeBytesData(instructionType: .NONE, commandType: testCommand.type, data: canMask, completionHandler: { data in
							let canFilter = Constants.ATCF + canFilterCommand + Constants.NEW_LINE_CHARACTER
							
							Network.shared.bluetoothService?.writeBytesData(instructionType: .NONE, commandType: .ODOMETER, data: canFilter, completionHandler: { data1 in
								testCommand.deviceData = data1
								print(Date(), "Command:  \(testCommand.type) - Response: \(data1)", to: &Log.log)
								Network.shared.bluetoothService?.writeBytesData(instructionType: .PID, commandType: .ODOMETER, data: odometerPIDCommand, completionHandler: { data1 in
									testCommand.deviceData = data1
									print(Date(), "Command:  \(testCommand.type) - Response: \(data1)", to: &Log.log)
									onCompletion!(testCommand)
								})
							})
							
						})
					}
									
				})
			}
			
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
		print("RUN flow commands")
		let flowcontrolHeader = Constants.ATFCSH + flowControl.flowControlHeader! + Constants.NEW_LINE_CHARACTER
		
		Network.shared.bluetoothService?.writeBytesData(instructionType: .FLOW_CONTROL_HEADER, commandType: testCommand.type,  data: flowcontrolHeader, completionHandler: { data in
			if self.previousFlowControlData ==  flowControl.flowControlData {
				isFlowControlChanged = false
			} else {
				isFlowControlChanged = true
				self.previousFlowControlData = flowControl.flowControlData
			}
			let flowControlData = Constants.ATFCSD + flowControl.flowControlData! + Constants.NEW_LINE_CHARACTER
			Network.shared.bluetoothService?.writeBytesData(instructionType: .FLOW_CONTROL_DATA, commandType: testCommand.type,   data: flowControlData, completionHandler: { data in
				if isFlowControlChanged {
					let flowControlChangedCommand = Constants.ATFCSM1 + Constants.NEW_LINE_CHARACTER
					Network.shared.bluetoothService?.writeBytesData(instructionType: .FLOW_CONTROL_NORMAL_COMMAND, commandType: testCommand.type,   data: flowControlChangedCommand, completionHandler: { data in
						print("RUN flow commands \(data)")
						testCommand.deviceData = data
						onCompletion!(testCommand)
					})
				} else {
					onCompletion!(testCommand)
				}
			})
		})
	}
	
	private func parseResponse(testCommand: TestCommandExecution?, index: Int) {
		
//		self.loopDispatch.async {
			print("Commands response")
			guard let responseData = testCommand?.deviceData else {
				return
				
			}
			let parseData: String = String.init(data: responseData, encoding: .utf8) ?? ""
			if parseData.contains(Constants.QUESTION_MARK) || parseData.contains(Constants.NODATA) || parseData.contains(Constants.NO_DATA) || parseData.contains(Constants.ERROR) {
				//VC
				self.delegate?.shortProfileCommandExecutionError()
				return
			}
			var responseDataInString: String = "" // local variable
			if  parseData.contains(":") {
				let removeSpaces = parseData.trimmingCharacters(in: .whitespacesAndNewlines)
				let splitString = removeSpaces.components(separatedBy: "\r")
				for item in splitString {
					let newitem = item.trimmingCharacters(in: .whitespacesAndNewlines)
					let sliptWithColen = newitem.components(separatedBy: ":")
					if sliptWithColen.count == 2 {
						responseDataInString.append(sliptWithColen[1])
						print("responseDataInString \(responseDataInString)")
					} else {
					}
				}
				
			} else {
				if testCommand?.challenge?.flowControl == nil {
					responseDataInString.append(parseData)
				}
				
			}
			testCommand?.deviceReponse = responseDataInString
			if let deviceByteArray = testCommand?.deviceReponse, deviceByteArray.count > 0 {
				let startByte = testCommand?.response?.startByte ?? 0
				print(Date(), "Start Byte\(startByte)", to: &Log.log)
				print("Start Byte\(startByte)")
				let endByte = testCommand?.response?.endByte ?? 0
				print(Date(), "End Byte\(endByte)", to: &Log.log)
				print("End Byte\(endByte)")
				let haxValueList = self.typeCastingByteToString(testCommand: testCommand)
				print(Date(), "Haxa list\(haxValueList)", to: &Log.log)
				print("Haxa list\(haxValueList)")
				if (haxValueList.count - 1) < endByte {
					return
				}
				
				switch testCommand?.type {
				case .ODOMETER:
					if haxValueList.count > 0 {
						let value = self.calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
						self.odometer = value
						print(Date(), "Final Odmeter \(value)", to: &Log.log)
						print("Final Odmeter \(value)")
					}
					
					break
				case .STATEOFCHARGE:
					if haxValueList.count > 0 {
						let value = self.calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
						self.stateOfCharge = value
						self.sumbitApiCalling()
						print(Date(), "Final State of Charge \(value)", to: &Log.log)
						print("Final State of Charge \(value)")
					}
					break
				case .ENERGY_TO_EMPTY:
					if haxValueList.count > 0 {
						let value = self.calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
						self.currentEnergy = value
						self.sumbitApiCalling()
						print(Date(), "Final Energy to empty \(value)", to: &Log.log)
						print("Final Energy to empty \(value)")
					}
					break
				case .BMS_CAPACITY:
					if haxValueList.count > 0 {
						let value = self.calculateValueFromStartEndByte(command: testCommand, hexValuesList: haxValueList)
						self.bms = value
						self.sumbitApiCalling()
						print(Date(), "Final BMS value \(value)", to: &Log.log)
						print("Final BMS value \(value)")
					}
					break
				case .PACK_TEMPERATURE:
					
					break
				case .PACK_VOLTAGE:
					
					break
				case .PACK_CURRENT:
					
					break
				case .CELL_VOLTAGE:
					
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
//			}
		}
	}
	
	private func sumbitApiCalling() {
			if let bms = self.bms, bms != 0 {
				self.submitBatteryDataForShortProfile()

			} else {
				if (self.currentEnergy != nil) && (self.stateOfCharge != nil) {
					self.submitBatteryDataForShortProfile()
				}
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
	
	func fromHaxToDecimal(haxValue: String) -> Int {
		guard let decimalValue = Int(haxValue, radix: 16) else {
			return Int(0)
			
		}
		return Int(decimalValue)
	}
	
	public func submitBatteryDataForShortProfile() {
		print("submitBatteryDataForShortProfile")
		print(Date(), "submitBatteryDataFileWithSOCGraphRequest", to: &Log.log)
		guard let veh = vehicleInfo else {return}
		guard let vinInfo = vehicleInfo?.vin else { return  }
		guard let vinMake = vehicleInfo?.make else { return  }
		guard let vinYear = vehicleInfo?.year else {return}
		guard let vinModels = vehicleInfo?.modelName else {return}
		guard let trim = vehicleInfo?.trimName else {return}
		let years: Int = Int(vinYear)
		let vehicalBatteryDataFile = SubmitBatteryDataFilesVehicleInput.init(vin: vinInfo, make: vinMake, model: vinModels, year: years, trim: trim)
		let batteryInstr = vehicleInfo?.getBatteryTestInstructions
		//Vehicle Profile
		print("vehical profile")
		guard let vehicleProfile = batteryInstr?[0].testCommands?.vehicleProfile else {
			print(Date(), "SOC:Submit API failed due to Vehicle Profile", to: &Log.log)
			self.delegate?.showShortProfileSubmitError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:Submit API failed due to Vehicle Profile", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinInfo, year: years, errorCode: "")
			return
		}
		print(Date(), "SOC:Vehicle Profile\(vehicleProfile)", to: &Log.log)
		
		//Nominal Volatage
		guard let nominalVoltage: Double = vehicleProfile.nominalVoltage else {
			print(Date(), "SOC:Submit API failed due to Nominal Volatge", to: &Log.log)
			self.delegate?.showShortProfileSubmitError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:Submit API failed due to Nominal Volatge", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinInfo, year: years, errorCode: "")
			return
		}
		print(Date(), "SOC:Nominal Voltage\(nominalVoltage)", to: &Log.log)
		//EnergyAtBirth
		guard let energyAtBirth: Double = vehicleProfile.energyAtBirth else {
			print(Date(), "SOC:Submit API failed due to state Of energyAtBirth", to: &Log.log)
			self.delegate?.showShortProfileSubmitError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:Submit API failed due to state Of energyAtBirth", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinInfo, year: years, errorCode: "")
			return
		}
		print(Date(), "SOC:energyAtBirth\(energyAtBirth)", to: &Log.log)
		//CapacityAtBirth
		guard let capacityAtBirth: Double = vehicleProfile.capacityAtBirth else {
			print(Date(), "SOC:Submit API failed due to state Of capacityAtBirth", to: &Log.log)
			self.delegate?.showShortProfileSubmitError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:Submit API failed due to state Of capacityAtBirth", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinInfo, year: years, errorCode: "")
			return
		}
		print(Date(), "SOC:capacityAtBirth\(capacityAtBirth)", to: &Log.log)
		
		guard let rangeAtBirth: Double = vehicleProfile.rangeAtBirth else {
			print(Date(), "SOC:Submit API failed due to state Of rangeAtBirth", to: &Log.log)
			self.delegate?.showShortProfileSubmitError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:Submit API failed due to state Of rangeAtBirth", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinInfo, year: years, errorCode: "")
			return
		}
		print(Date(), "SOC:capacityAtBirth\(rangeAtBirth)", to: &Log.log)
		//Battery
		guard let batteryType: String = vehicleProfile.batteryType else {
			print(Date(), "SOC:Submit API failed due to BatteryType", to: &Log.log)
			self.delegate?.showShortProfileSubmitError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:Submit API failed due to state Of capacityAtBirth", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinInfo, year: years, errorCode: "")
			return
		}
		print(Date(), "SOC:BatteryType\(batteryType)", to: &Log.log)
		
		let vehicalProfile = CalculateBatteryHealthVehicleProfileInput.init(nominalVoltage: Double(nominalVoltage), energyAtBirth: Double(energyAtBirth), batteryType: .lithium, capacityAtBirth: capacityAtBirth, rangeAtBirth: rangeAtBirth)

		print(Date(), "vehicalProfile : \(vehicalProfile)", to: &Log.log)
		var calculatedBetteryHealth : CalculateBatteryHealthInput?
		if let soc = self.stateOfCharge, soc != 0 {
			//With soc
			let stateOfCharge = self.stateOfCharge
			let dashDataInput = DashDataInput.init(odometer: Int(odometer ?? 0), stateOfCharge: stateOfCharge)
			let obd2Test = OBD2TestInput.init(odometer: Int(self.odometer ?? 0) , currentEnergy: currentEnergy, stateOfCharge: stateOfCharge)
			print("OBD2TEST", obd2Test)
			calculatedBetteryHealth = CalculateBatteryHealthInput.init(vehicleProfile: vehicalProfile, obd2Test: obd2Test, dashData: dashDataInput, locationCode: LocationCode.aaa, workOrderNumber: self.workOrder ?? "", totalNumberOfCharges: 1, lifetimeCharge: 2.0 , lifetimeDischarge: 2.0)
		} else {
			// With BMS
			let expectedCapacityAtBirth: Double = (vehicalProfile.capacityAtBirth ?? Double(0.0))!
			let calculateddCapacityAtBirth = self.bms ?? 0.0
			var bmsCapacity: Double = 0.0
			if calculateddCapacityAtBirth > expectedCapacityAtBirth {
				bmsCapacity = expectedCapacityAtBirth
			} else {
				bmsCapacity = calculateddCapacityAtBirth
			}
			let bmsObdTest = OBD2TestInput.init(odometer: Int(self.odometer ?? 0), bmsCapacity: bmsCapacity)
			calculatedBetteryHealth = CalculateBatteryHealthInput.init(vehicleProfile: vehicalProfile, obd2Test: bmsObdTest, locationCode: LocationCode.aaa, workOrderNumber: self.workOrder ?? "", totalNumberOfCharges: 1, lifetimeCharge: 2.0 , lifetimeDischarge: 2.0)
			
		}
		print(Date(), "calculatedBetteryHealth: \(String(describing: calculatedBetteryHealth))", to: &Log.log)
//		let jsonMutation = SubmitBatteryJsonFilesWithStateOfChargeMutation(Vehicle: vehicalBatteryDataFile, calculateBatteryHealthInput: calculatedBetteryHealth ?? CalculateBatteryHealthInput())
//		Network.shared.apollo.perform(mutation: jsonMutation) { result in
		let submitScoreQuery = CalculateBatteryHealthQuery(calculateBatteryHealthInput: calculatedBetteryHealth ?? CalculateBatteryHealthInput(), vin: vinInfo)
		
		Network.shared.apollo.fetch(query: submitScoreQuery) { result in
			switch result {
			case .success(let graphQLResults):
				guard let _ = try? result.get().data else { return }
				if graphQLResults.data != nil {
					print("JSON query success case")
					if graphQLResults.errors?.count ?? 0 > 0 {
						print(Date(), "SOC:submit API Error 1:\(String(describing: graphQLResults.errors))", to: &Log.log)
						self.delegate?.showShortProfileSubmitError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:submit API Error66 :\(String(describing: graphQLResults.errors))", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinInfo, year: years, errorCode: "")
						return
					}
					
					let submitData =  graphQLResults.data?.resultMap["vehicle"]
					if submitData == nil {
						print("CALCULATE BATTERY HEALTH")
						print(Date(), "SOC:submit API result Map Error :\(String(describing: graphQLResults.errors))", to: &Log.log)
						self.delegate?.showShortProfileSubmitError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "\(String(describing: graphQLResults.errors))", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinInfo, year: years, errorCode: "")
						let paramDictionary = [
							"submit_type": "STATE_OF_CHARGE",
							"errorCode":"\(String(describing: graphQLResults.errors))",
							"work_order": "\(String(describing: self.workOrder))"]
						FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.submitBatteryFilesError, parameters: paramDictionary)
						return
					} else {
						let jsonObject = submitData.jsonValue
						do {
							let  preSignedData = try JSONSerialization.data(withJSONObject: jsonObject)
							print(Date(), "SOC:submit Battery Data succesfully :\(String(describing: jsonObject))", to: &Log.log)
							do {
								let decoder = JSONDecoder()
								let submitBatteryData = try decoder.decode(Vehicle.self, from: preSignedData)
								print(Date(), "SOC:submit API Decode Sucessful :\(String(describing: submitBatteryData))", to: &Log.log)
								if submitBatteryData.calculateBatteryHealth?.success == false {
									print("JSON IS DATA OBJECT")
									print(Date(), "SOC:battery Score is Null :\(String(describing: graphQLResults.errors))", to: &Log.log)
									self.delegate?.showShortProfileSubmitError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "Battery Score is Null", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinInfo, year: years, errorCode: submitBatteryData.calculateBatteryHealth?.code ?? "")
									return
								} else {
									//check
									let bt = submitBatteryData.calculateBatteryHealth?.calculatedBatteryHealth
									let minEstRange = bt?.estimatedRange?.estimatedRangeMin
									let maxEstRange = bt?.estimatedRange?.estimatedRangeMax

									self.delegate?.shortProfileCommandsCompleted(battteryHealth: bt?.batteryScore , minRange: minEstRange, maxRange: maxEstRange, rangeAtBirth: rangeAtBirth)
								}
								
							} catch DecodingError.dataCorrupted(let context) {
								//print(Date(), "SOC:submit API Error :\(context)", to: &Log.log)
								self.delegate?.showShortProfileSubmitError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:submit API Error2 :\(context)", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinInfo, year: years, errorCode: "")
								return
							}
						} catch {
							self.delegate?.showShortProfileSubmitError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:submit API Error3 :\(error)", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinInfo, year: years, errorCode: "")
							//print(Date(), "SOC:submit API Error :\(error)", to: &Log.log)
						}
						
					}
				} else {
				print("ele condition::::::::::")
				}
				break
			case .failure(let error):
				//if let transactionId = self.preSignedData?.transactionID {
				self.delegate?.showShortProfileSubmitError(transactionID: nil , vinMake: vinMake, message: error.localizedDescription, vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinInfo, year: years, errorCode:  "")
				//}
				print(Date(), "SOC:submit API Error :\(error)", to: &Log.log)
				break
			}
		}
	
	}
}
