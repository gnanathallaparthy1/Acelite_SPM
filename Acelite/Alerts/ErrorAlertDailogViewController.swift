//
//  ErrorAlertDailogViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 4/25/23.
//

import UIKit

class ErrorAlertDailogViewController: UIViewController {

	@IBOutlet weak var doneButton: UIButton!
	@IBOutlet weak var alertSubtitle: UILabel!
	@IBOutlet weak var alertTitle: UILabel!
	@IBOutlet weak var popUpView: UIView!
	override func viewDidLoad() {
        super.viewDidLoad()
		viewUpdate()
    }
	
	private func viewUpdate() {
		doneButton.layer.cornerRadius = 4
		doneButton.layer.borderColor = UIColor.black.cgColor
		doneButton.layer.borderWidth = 2
			
	}
	
    
	@IBAction func doneButtonAction(_ sender: UIButton) {
		
	}
}
