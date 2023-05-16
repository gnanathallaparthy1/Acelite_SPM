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
			   self.delegate?.handleErrorVehicleInfoUpdate(message: "No result")
			   print("Error loading data \(error)")
			   //self.callback?(false)
		   }
	   }
   }
}
