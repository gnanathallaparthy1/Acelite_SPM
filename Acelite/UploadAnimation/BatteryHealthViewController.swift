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
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.hidesBackButton = true
       
    }
   

}
