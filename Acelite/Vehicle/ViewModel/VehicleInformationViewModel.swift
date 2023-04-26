//
//  VehicleViewModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 2/2/23.
//

import Foundation
import Apollo
import UIKit

protocol UpdateVehicleInformationDelegate: AnyObject {
	func updateVehicleInfo(viewModel: VehicleInformationViewModel)
	func handleErrorVehicleUpdate()
}

class VehicleInformationViewModel {
	var vehicleInformation:  Vehicle?
	var vinNumber: String?
	weak var delegate: UpdateVehicleInformationDelegate? = nil
	//var delegate: UpdateVehicleInformationDelegate?
	//var getBatteryinstructions: [GetBatteryTestInstruction]?
	//var callback: ((Bool)->())?
	//var dataManger: DataManager?
	init(vinNumber: String?, vehicleInformation: Vehicle) {
		self.vinNumber = vinNumber
		self.vehicleInformation = vehicleInformation
	}
	 func fetchVehicalInformation(vim: String)  {
		Network.shared.apollo.fetch(query: GetBatteryTestInstructionsQuery(vin: vim)) { result in
			// 3
			switch result {
			case .success(let graphQLResult):
				guard let data = try? result.get().data else { return }
				print(data)
				
				if graphQLResult.data != nil {
					let vehicle = graphQLResult.data?.resultMap["vehicle"]?.jsonValue
					var vehicleData : Data?
					do {
						vehicleData = try JSONSerialization.data(withJSONObject: vehicle as Any)
					} catch {
							print("Unexpected error: \(error).")
					}
										
					do {
						let decoder = JSONDecoder()
						let messages = try decoder.decode(Vehicle.self, from: vehicleData!)
						self.vehicleInformation = messages
						
						self.delegate?.updateVehicleInfo(viewModel: self)
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
				self.delegate?.handleErrorVehicleUpdate()
				print("Error loading data \(error)")
				//self.callback?(false)
			}
		}
	}
	
}
