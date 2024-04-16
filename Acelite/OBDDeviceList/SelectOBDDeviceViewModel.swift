//
//  SelectOBDDeviceViewModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/18/24.
//

import Foundation

class SelectOBDDeviceViewModel {
	
	var obdDeviceArray: [String] = ["Starcharm", "OBDLink", "vLinker"]
	var interfaceType: DeviceInterfaceType = .BLUETOOTH_CLASSIC
	
	init(interfaceType: DeviceInterfaceType) {
		self.interfaceType = interfaceType
	}

}
