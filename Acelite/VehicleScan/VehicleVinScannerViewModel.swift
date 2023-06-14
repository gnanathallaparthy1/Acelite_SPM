//
//  VehicleVinScannerViewModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 4/25/23.
//

import Foundation
import Apollo
import UIKit

protocol PassVehicleInformationDelegate: AnyObject {
	func updateVehicleInfo(viewModel: VehicleVinScannerViewModel)
	func handleErrorVehicleInfoUpdate(message: String)
}

class VehicleVinScannerViewModel {
	var vehicleInformation:  Vehicle?
	var vinNumber: String?
	weak var delegate: PassVehicleInformationDelegate? = nil
	
	func fetchVehicalInformation(vim: String)  {
	   Network.shared.apollo.fetch(query: GetBatteryTestInstructionsQuery(vin: vim)) { result in
		   // 3
		   switch result {
		   case .success(let graphQLResult):
			   guard let data = try? result.get().data else {
				   self.delegate?.handleErrorVehicleInfoUpdate(message: "No result")
				   return
			   }
			   print(data)
			   
			   if graphQLResult.data != nil {
				   
				   if graphQLResult.errors?.count ?? 0 > 0 {
					  // print("Error::", graphQLResult.errors!)
					   let errorMessage: String = "\(graphQLResult.errors)"
					   print(Date(), "SOC:submit API Error :\(String(describing: graphQLResult.errors))", to: &Log.log)
					   self.delegate?.handleErrorVehicleInfoUpdate(message: errorMessage)
					   return
				   }
				   if graphQLResult.data?.vehicle == nil {
					   self.delegate?.handleErrorVehicleInfoUpdate(message: "No result")
					   return
				   }
				   
				   let vehicle = graphQLResult.data?.resultMap["vehicle"]?.jsonValue
				   var vehicleData : Data?
				   do {
					   vehicleData = try JSONSerialization.data(withJSONObject: vehicle as Any)
				   } catch {
						   //print("Unexpected error: \(error).")
					   self.delegate?.handleErrorVehicleInfoUpdate(message: "No result")
				   }
									   
				   do {
					   let decoder = JSONDecoder()
					   let messages = try decoder.decode(Vehicle.self, from: vehicleData!)
					   self.vehicleInformation = messages
					   self.handleInstructions()
					   self.delegate?.updateVehicleInfo(viewModel: self)
				   } catch DecodingError.dataCorrupted(let context) {
					  // print(context)
					   self.delegate?.handleErrorVehicleInfoUpdate(message: "No result")
				   } catch DecodingError.keyNotFound(let key, let context) {
					  // print("Key '\(key)' not found:", context.debugDescription)
					  // print("codingPath:", context.codingPath)
					   self.delegate?.handleErrorVehicleInfoUpdate(message: "No result")
				   } catch DecodingError.valueNotFound(let value, let context) {
					 //  print("Value '\(value)' not found:", context.debugDescription)
					  // print("codingPath:", context.codingPath)
					   self.delegate?.handleErrorVehicleInfoUpdate(message: "No result")
				   } catch DecodingError.typeMismatch(let type, let context) {
//					   print("Type '\(type)' mismatch:", context.debugDescription)
//					   print("codingPath:", context.codingPath)
					   self.delegate?.handleErrorVehicleInfoUpdate(message: "No result")
				   } catch {
					  // print("error: ", error)
					   self.delegate?.handleErrorVehicleInfoUpdate(message: "No result")
				   }
			   }
				   
		   case .failure(let error):
			   self.delegate?.handleErrorVehicleInfoUpdate(message: "Network Error")
			   print("Error loading data \(error)")
			   //self.callback?(false)
		   }
	   }
   }
	private func handleInstructions() {
		guard let testCommand = self.vehicleInformation?.getBatteryTestInstructions, testCommand.count > 0 else {
			return
		}
		
		for command in testCommand {
			let odometer = command.testCommands?.odometer
			Network.shared.batteryTestInstructionId = command.testCommands?.id

			let odo = TestCommandExecution(type: .ODOMETER , resProtocal: (odometer?.odometerProtocol)!, challenge: (odometer?.challenge)!, response: odometer!.response, validation: odometer!.validation)
			Network.shared.normalCommandsList.append(odo)
			let stateOfCharge = command.testCommands?.stateOfHealthCommands?.stateOfCharge
			let bms = command.testCommands?.stateOfHealthCommands?.bmsCapacity
			let energyToEmpty = command.testCommands?.stateOfHealthCommands?.energyToEmpty
			if let elmProtocol  = stateOfCharge?.odometerProtocol, let chal = stateOfCharge?.challenge, let res = stateOfCharge?.response, let val = stateOfCharge?.validation {
				let soc = TestCommandExecution(type: .STATEOFCHARGE , resProtocal: elmProtocol, challenge: chal, response: res, validation: val)
				Network.shared.normalCommandsList.append(soc)
			}
			
			if let elmProtocol  = bms?.odometerProtocol, let chal = bms?.challenge, let res = bms?.response, let val = bms?.validation {
				
				let bmsComands = TestCommandExecution(type: .BMS_CAPACITY , resProtocal: elmProtocol, challenge: chal, response: res, validation: val)
				Network.shared.normalCommandsList.append(bmsComands)
			}
			
			if let elmProtocol  = energyToEmpty?.odometerProtocol, let chal = energyToEmpty?.challenge, let res = energyToEmpty?.response, let val = energyToEmpty?.validation {
				
				let energyToEmptyCommand = TestCommandExecution(type: .ENERGY_TO_EMPTY , resProtocal: elmProtocol, challenge: chal, response: res, validation: val)
				Network.shared.normalCommandsList.append(energyToEmptyCommand)
			}

			
			let diagnosticSession = command.testCommands?.diagnosticSession
			if let diaChal = diagnosticSession?.challenge, let pro = diagnosticSession?.diagnosticSessionProtocol {
				Network.shared.isDiagnosticSession = true
				let diagno = TestCommandDiagnosticExecution(type: .DIAGNOSTIC_SESSION, resProtocal: pro, challenge: diaChal)
				Network.shared.diagnosticCommand = diagno
				
			}

			////////print("Normal Command List", normalCommandsList)
			if let sp = command.testCommands?.sampledCommands {
				//sampledCommandsList = sp
				//WHY?????
				//MARK: - PackVoltage
				let packVoltage = sp.packVoltage
				let packVoltageTestCommand = TestCommandExecution(type: .PACK_VOLTAGE, resProtocal: sp.sampledCommandsProtocol, challenge: (packVoltage.challenge)!, response: packVoltage.response, validation: packVoltage.validation)
				packVoltageTestCommand.reqeustByteInString = packVoltage.challenge?.pid ?? ""
				Network.shared.sampledCommandsList.append(packVoltageTestCommand)
				
				//MARK: - PackCurrent
				let packCurrent = sp.packCurrent
				let packCurrentTestCommand = TestCommandExecution(type: .PACK_CURRENT, resProtocal: sp.sampledCommandsProtocol, challenge: (packCurrent.challenge)!, response: packCurrent.response, validation: packCurrent.validation)
				packCurrentTestCommand.reqeustByteInString = packCurrent.challenge?.pid ?? ""
				Network.shared.sampledCommandsList.append(packCurrentTestCommand)
				
				//MARK: - PackTemparature
				let packTemparature = sp.packTemperature
				for item in packTemparature {
					let response = OdometerResponse(startByte: item.response.startByte, endByte: item.response.endByte, numberOfCells: 0, bytesPerCell: 0, startCellCount: 0, endCellCount: 0, bytesPaddedBetweenCells: 0, multiplier: Double(item.response.multiplier), constant: item.response.constant)
					
					//let response = OdometerResponse(startByte: item.response.startByte, endByte: item.response.endByte, multiplier: Double(item.response.multiplier), constant: Double(item.response.constant))
					
					let packTempTestCommand = TestCommandExecution(type: .PACK_TEMPERATURE, resProtocal: sp.sampledCommandsProtocol, challenge: item.challenge, response: response, validation: item.validation)
					packTempTestCommand.reqeustByteInString = item.challenge.pid
					Network.shared.sampledCommandsList.append(packTempTestCommand)
				}
				
				//MARK: - CellVoltage
				let cellVoltage = sp.cellVoltage
				for item in cellVoltage {
					let response = OdometerResponse(startByte: item.response.startByte, endByte: item.response.endByte, numberOfCells: item.response.numberOfCells, bytesPerCell: item.response.bytesPerCell, startCellCount: item.response.startCellCount, endCellCount: item.response.endCellCount, bytesPaddedBetweenCells: item.response.bytesPaddedBetweenCells, multiplier: Double(item.response.multiplier), constant: item.response.constant)
					//let response = OdometerResponse(startByte: item.response.startByte, endByte: item.response.endByte, multiplier: Double(item.response.multiplier), constant: Double(item.response.constant))
					let cellVoltageTestCommand = TestCommandExecution(type: .CELL_VOLTAGE, resProtocal: sp.sampledCommandsProtocol, challenge: item.challenge, response: response, validation: item.validation)
					//self.numberOfCells = response.numberOfCells
					cellVoltageTestCommand.reqeustByteInString = item.challenge.pid
					Network.shared.sampledCommandsList.append(cellVoltageTestCommand)
				}
				
			}
		}
	}
}
