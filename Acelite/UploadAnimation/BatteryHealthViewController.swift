//
//  BatteryHealthViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/7/23.
//

import UIKit

// Access Shared Defaults Object
let userDefaults = UserDefaults.standard
var dictionary = [String : String]()

class BatteryHealthViewController: UIViewController {
	
	init(viewModel: BatteryHealthViewModel) {
		super.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
		//super.init()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	@IBOutlet weak var gaugeView: ABGaugeView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var vinLabel: UILabel!
	@IBOutlet weak var modelNameLabel: UILabel!
	
	@IBOutlet weak var healthLabel: UILabel!
	@IBOutlet weak var DoneBtn: UIButton!
	
	@IBOutlet weak var scoreLabel: UILabel!
	public var viewModel: BatteryHealthViewModel?
	
	@IBAction func DoneButtonPressed(_ sender: Any) {
		//==============================
		var dict: [[String: String]] = userDefaults.object(forKey: "myKey") as? [[String : String]] ?? [[String : String]]()
		dict.append(dictionary)
		userDefaults.set(dict, forKey: "myKey")
		self.navigationController?.popToRootViewController(animated: true)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		FirebaseLogging.instance.logScreen(screenName: ClassNames.confirmation)
		
		
		self.navigationItem.hidesBackButton = true
		let healthScore = viewModel?.healthScore ?? 0
		let testInstruc = viewModel?.testInstructionsId
		self.scoreLabel.text = "\(healthScore)"
		self.healthLabel.text = viewModel?.health ?? ""
		let paramDictionary = [
		   "score": "\(healthScore)",
		   "batter_test_instructions_id": "\(String(describing: testInstruc))"]
		FirebaseLogging.instance.logEvent(eventName:ConfirmationScreenEvents.confirmation, parameters: paramDictionary)
		let vehicle = viewModel?.vehicleInfo
		self.modelNameLabel.text = vehicle?.title
		self.vinLabel.text = vehicle?.vin
		guard let vinInfo = vehicle?.vin else { return  }
		guard let vinMake = vehicle?.make else { return  }
		guard let vinYear = vehicle?.year else {return}
		guard let vinModels = vehicle?.modelName else {return}
		guard let title = vehicle?.title else { return  }
		guard let bodyStyle = vehicle?.bodyStyle else {return}
		guard let workOrder = vehicle?.trimName else {return}
		guard let trasctionID = viewModel?.transactionId else {return}
		guard let healthScore = viewModel?.healthScore else {return}
		guard let gradeTitle = viewModel?.grade?.title else {return}
		//timestamp
		 dictionary = [
			"Title": title,
			"Make": vinMake,
			"Year": String(vinYear),
			"Vin number": vinInfo,
			"Work order": workOrder,
			"Date-Time": "\(getCurrentDateAndTime())",
			"Score": "\(healthScore)",
			"Grade": "\(gradeTitle)",
			"Transaction ID": trasctionID,
			"Model": vinModels,
			"Body Style": bodyStyle,
			"Health": "\(String(describing: viewModel?.health))"
			"json": "file"
		]
    }
	
	override func viewWillAppear(_ animated: Bool) {
		if let score = viewModel?.healthScore {
			self.gaugeView.scoreValue = score
		}
		
		self.gaugeView.layoutSubviews()
	}
   
	private func getCurrentDateAndTime() -> String {
		let dateFormatter : DateFormatter = DateFormatter()
		//  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		dateFormatter.dateFormat = "dd-mm-yyyy HH:mm:ss"
		let date = Date()
		let dateString = dateFormatter.string(from: date)
		return dateString
	}

}
