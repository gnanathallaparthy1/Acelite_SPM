//
//  BatteryHealthViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/7/23.
//

import UIKit

class BatteryHealthViewController: UIViewController {
	@IBOutlet weak var gaugeView: ABGaugeView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var gradeLabel: UILabel!
	@IBOutlet weak var vinLabel: UILabel!
	@IBOutlet weak var modelNameLabel: UILabel!
	
	@IBOutlet weak var DoneBtn: UIButton!
	
	@IBAction func DoneButtonPressed(_ sender: Any) {
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
       
    }
   

}
