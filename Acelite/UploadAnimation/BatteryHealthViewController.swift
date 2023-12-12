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
	@IBOutlet weak var DoneBtn: UIButton! {
		didSet {
			DoneBtn.layer.cornerRadius = 8
		}
	}
	@IBOutlet weak var scoreLabel: UILabel!
	public var viewModel: BatteryHealthViewModel?
	
	@IBAction func DoneButtonPressed(_ sender: Any) {
		//==============================
		var dict: [[String: String]] = userDefaults.object(forKey: "myKey") as? [[String : String]] ?? [[String : String]]()
		dict.append(dictionary)
		userDefaults.set(dict, forKey: "myKey")
		if let pheriPheral = Network.shared.myPeripheral {
			Network.shared.bluetoothService?.disconnectDevice(peripheral: pheriPheral)
		}
		self.navigationController?.popToRootViewController(animated: true)
	}
	
	@IBOutlet weak var rangeNewValueTextlabel: UILabel!
	@IBOutlet weak var estRangeTextLabel: UILabel!
	@IBOutlet weak var estRangeLabel: UILabel!	
	@IBOutlet weak var rangeNewValueLabel: UILabel!
	
	@IBOutlet weak var estViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var newValueLabelHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var rangeNewValueLabelHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var estValueHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var estTextHeightConstraint: NSLayoutConstraint!
	override func viewDidLoad() {
        super.viewDidLoad()
		FirebaseLogging.instance.logScreen(screenName: ClassNames.confirmation)
		
		
		self.navigationItem.hidesBackButton = true
		let healthScore = viewModel?.healthScore ?? 0
		let testInstruc = viewModel?.testInstructionsId
		self.scoreLabel.text = "\(healthScore)"
		self.healthLabel.text = viewModel?.health ?? ""
		
		let rangeAtBirth = viewModel?.rangeAtBirth
		self.rangeNewValueLabel.text = "\(String(describing: rangeAtBirth))"
		let minRange = viewModel?.minEstimatedRange ?? 0.0
		let maxRange = viewModel?.maxEstimatedRange ?? 0.0
		self.estRangeLabel.text = "\(String(describing: minRange)) - \(String(describing: maxRange))"
		let paramDictionary = [
		   "score": "\(healthScore)",
		   "batter_test_instructions_id": "\(String(describing: testInstruc))"]
		FirebaseLogging.instance.logEvent(eventName:ConfirmationScreenEvents.confirmation, parameters: paramDictionary)
		let vehicle = viewModel?.vehicleInfo
		self.modelNameLabel.text = vehicle?.title
		self.vinLabel.text = vehicle?.vin
		let vinInfo = vehicle?.vin ?? "N/A"
		 let vinMake = vehicle?.make ?? "N/A"
		 let vinYear = vehicle?.year ?? 0
		 let vinModels = vehicle?.modelName ?? "N/A"
		 let title = vehicle?.title ?? "N/A"
		 let bodyStyle = vehicle?.bodyStyle ?? "N/A"
		 let workOrder = vehicle?.trimName ?? "N/A"
		 let trasctionID = viewModel?.transactionId ?? "N/A"
		
		 let gradeTitle = viewModel?.grade?.title ?? "N/A"
		let range = viewModel?.rangeAtBirth ?? 0.0
		let health = viewModel?.health ?? "N/A"
		
		 dictionary = [
			"Title": title,
			"Make": vinMake,
			"Year": String(vinYear),
			"Vin number": vinInfo,
			"Work order": workOrder,
			"Date-Time": "\(getCurrentDateAndTime())",
			"Score": "\(healthScore)",
			"Grade": "\(gradeTitle)",
			"Transaction ID": "\(trasctionID)",
			"Model": vinModels,
			"Body Style": bodyStyle,
			"Health": "\(health)",
			"Range When New": "\(range)",
			"Est. Range on Full Charge": "\(minRange) - \(maxRange)",
			"json": "file"
		]
		
		showMinAndMaxRanage()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		if let score = viewModel?.healthScore {
			self.gaugeView.scoreValue = score
		}
		
		self.gaugeView.layoutSubviews()
	}
   
	private func getCurrentDateAndTime() -> String {
		let dateFormatter : DateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
		let date = Date()
		let dateString = dateFormatter.string(from: date)
		return dateString
	}
	
	private func showMinAndMaxRanage() {
		if let rangeAtBirth = viewModel?.rangeAtBirth,  let minRange = viewModel?.minEstimatedRange, let maxRange = viewModel?.maxEstimatedRange {
			self.rangeNewValueLabel.text = "\(rangeAtBirth)"
			self.estRangeLabel.text = "\(minRange) - \(maxRange)"
			if rangeAtBirth > 0 && minRange > 0 || maxRange > 0 {
				estViewHeightConstraint.constant = 160
				newValueLabelHeightConstraint.constant = 35
				rangeNewValueLabelHeightConstraint.constant = 30
				estValueHeightConstraint.constant = 35
				estTextHeightConstraint.constant = 30
			} else {
				estViewHeightConstraint.constant = 90
				estValueHeightConstraint.constant = 0
				estTextHeightConstraint.constant = 0
			}
			
		} else {
			estViewHeightConstraint.constant = 90
			newValueLabelHeightConstraint.constant = 0
			rangeNewValueLabelHeightConstraint.constant = 0
			return
		}
		
	}

}
