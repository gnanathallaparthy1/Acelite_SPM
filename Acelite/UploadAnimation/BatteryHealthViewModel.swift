//
//  BatteryHealthViewModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/26/23.
//

import Foundation

class BatteryHealthViewModel {
	
	init(vehicleInfo: Vehicle) {
		self.vehicleInfo = vehicleInfo
	}
	
	public var vehicleInfo: Vehicle?
}
