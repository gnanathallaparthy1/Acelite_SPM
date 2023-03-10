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
	
	var radius: CGFloat!
	var progress: CGFloat!

	var answeredCorrect = 0
	var totalQuestions = 0

	override func viewDidLoad() {
        super.viewDidLoad()
		answeredCorrect = 50
		   totalQuestions = 100

		   //Configure Progress Bar
		radius = (imageView.frame.height)/2
		   progress = CGFloat(answeredCorrect) / CGFloat (totalQuestions)

		

       
    }
   

}
