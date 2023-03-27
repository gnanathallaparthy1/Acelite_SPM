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
		
		
		var dict: [[String: String]] = userDefaults.object(forKey: "myKey") as? [[String : String]] ?? [[String : String]]()
		dict.append(dictionary)
		userDefaults.set(dict, forKey: "myKey")
		self.navigationController?.popToRootViewController(animated: true)
//		let text = string
//		let folder = "Saved"
//		let timeStamp = Date.currentTimeStamp
//		let fileNamed = "Logs"
//		guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
//		guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else { return }
//		try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
//		let file = writePath.appendingPathComponent(fileNamed + ".txt")
//		try? text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
//
//		self.navigationController?.popToRootViewController(animated: true)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.hidesBackButton = true
		let vehicle = viewModel?.vehicleInfo
		guard let vinInfo = vehicle?.vin else { return  }
		guard let vinMake = vehicle?.make else { return  }
		guard let vinYear = vehicle?.year else {return}
		guard let vinModels = vehicle?.modelName else {return}
		guard let title = vehicle?.title else { return  }
		guard let bodyStyle = vehicle?.bodyStyle else {return}
		guard let workOrder = vehicle?.trimName else {return}
		//timestamp
		 dictionary = [
			"Title": title,
			"Make": vinMake,
			"Year": String(vinYear),
			"Vin number": vinInfo,
			"Work order": "N/A",
			"Date-Time": "\(getCurrentDateAndTime())",
			"Score": "1",
			"Grade": "N/A",
			"Transaction ID": "",
			"Model": vinModels,
			"Body Style": bodyStyle,
			"Health": "N/A"
		]
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
