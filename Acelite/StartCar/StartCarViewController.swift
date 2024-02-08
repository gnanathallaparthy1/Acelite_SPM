//
//  StartCarViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 11/14/23.
//

import UIKit
import CoreData

class StartCarViewController: UIViewController {

	@IBOutlet weak var startButton: UIButton! {
		didSet {
			startButton.layer.cornerRadius = 8
		}
	}
	@IBOutlet weak var informationLabel: UILabel!
	var startCarViewModel: StartCarViewModel?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		informationLabel.text = startCarViewModel?.labelText
	
    }
	override func viewWillAppear(_ animated: Bool) {
		//self.navigationItem.backBarButtonItem?.tintColor = UIColor.appPrimaryColor()
		//self.navigationController?.navigationBar.barTintColor = UIColor.appPrimaryColor()
		//self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationController?.navigationBar.tintColor = UIColor.appPrimaryColor()
		//self.navigationController?.navigationBar.isTranslucent = false
	}
	@IBAction func startButtonAction(_ sender: UIButton) {
	
		guard let instructions = self.startCarViewModel?.vehicalInfo?.getBatteryTestInstructions, instructions.count > 0 else { return  }
		let instructionId = instructions.first
		let paramDictionary = [
			Parameters.workOrder: "\(String(describing: startCarViewModel?.workOrder))",
			Parameters.batteryTestInstructionsId: "\(instructionId?.testCommands?.id ?? "")",
			Parameters.year: "\(self.startCarViewModel?.vehicalInfo?.year ?? 0)", Parameters.make : self.startCarViewModel?.vehicalInfo?.make ?? "", Parameters.model:  self.startCarViewModel?.vehicalInfo?.modelName ?? "", Parameters.trim: self.startCarViewModel?.vehicalInfo?.trimName ?? "", Parameters.locationCode: self.startCarViewModel?.locationCode ?? "" ] as [String : String]
		FirebaseLogging.instance.logEvent(eventName:BMSCapacityTest.quickTestStart, parameters: paramDictionary)
		
		DispatchQueue.main.async {
			self.startButton.isUserInteractionEnabled = false
			let vm = UploadAnimationViewModel(vehicleInfo: self.startCarViewModel?.vehicalInfo, workOrder: self.startCarViewModel?.workOrder, isShortProfile: true, managedObject: NSManagedObject(), locationCode: self.startCarViewModel?.locationCode ?? "")
			let uploadVC = UploadAnimationViewController(viewModel: vm)
			self.navigationController?.pushViewController(uploadVC, animated: true)
		}
		
	}
	
}
