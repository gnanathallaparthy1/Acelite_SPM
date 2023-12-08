//
//  StartCarViewModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 11/14/23.
//

import Foundation

class StartCarViewModel {
	
	var vehicalInfo: Vehicle?
	var workOrder: String?
	var labelText = "Please turn on the car before proceeding in the testing process"
	var transactionId: String?
	
	init(vehicalInfo: Vehicle? = nil, workOrder: String? = nil, transactionId: String? = nil) {
		self.vehicalInfo = vehicalInfo
		self.workOrder = workOrder
		self.transactionId = transactionId
	}
}
