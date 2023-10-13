//
//  UploadAnimationViewModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/6/23.
//


import Foundation
import CoreData

class UploadAnimationViewModel {
	
	
	var managedObject: NSManagedObject?
	
	init(managedObject: NSManagedObject) {
		self.managedObject = managedObject
	}
//	public var delegate: UploadAndSubmitDataDelegate?
//	public var numberOfCells: Int?
//	init(delegate: UploadAndSubmitDataDelegate?, numberOfCells: Int) {
//		self.delegate = delegate
//		self.numberOfCells = numberOfCells
//	}
}
