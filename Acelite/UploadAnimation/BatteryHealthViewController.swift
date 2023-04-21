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
	@IBOutlet weak var gaugeView: ABGaugeView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var gradeLabel: UILabel!
	@IBOutlet weak var vinLabel: UILabel!
	@IBOutlet weak var modelNameLabel: UILabel!
	
	@IBOutlet weak var DoneBtn: UIButton!
	
	public var viewModel: BatteryHealthViewModel?
	
	@IBAction func DoneButtonPressed(_ sender: Any) {
		let text = "Developer"
		let folder = "SavedFiles"
		let timeStamp = Date.currentTimeStamp
		let fileNamed = "\(timeStamp)"
		guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
		guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else { return }
		try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
		let file = writePath.appendingPathComponent(fileNamed + ".txt")
		try? text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
		
		//==============================
		var dict: [[String: String]] = userDefaults.object(forKey: "myKey") as? [[String : String]] ?? [[String : String]]()
		dict.append(dictionary)
		userDefaults.set(dict, forKey: "myKey")
		self.navigationController?.popToRootViewController(animated: true)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.hidesBackButton = true
		self.gradeLabel.text = viewModel?.grade?.title
		let vehicle = viewModel?.vehicleInfo
		guard let vinInfo = vehicle?.vin else { return  }
		guard let vinMake = vehicle?.make else { return  }
		guard let vinYear = vehicle?.year else {return}
		guard let vinModels = vehicle?.modelName else {return}
		guard let title = vehicle?.title else { return  }
		guard let bodyStyle = vehicle?.bodyStyle else {return}
		guard let workOrder = vehicle?.trimName else {return}
		guard let trasctionID = viewModel?.transactionId else {return}
		NSLog("Third Log........")
		//timestamp
		 dictionary = [
			"Title": title,
			"Make": vinMake,
			"Year": String(vinYear),
			"Vin number": vinInfo,
			"Work order": workOrder,
			"Date-Time": "\(getCurrentDateAndTime())",
			"Score": "4",
			"Grade": "N/A",
			"Transaction ID": trasctionID,
			"Model": vinModels,
			"Body Style": bodyStyle,
			"Health": "Good"
		]
    }
	
	override func viewWillAppear(_ animated: Bool) {
		if let grades = viewModel?.grade {
			self.gaugeView.grade = grades
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
