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
		let vm = UploadAnimationViewModel(vehicleInfo: startCarViewModel?.vehicalInfo, workOrder: startCarViewModel?.workOrder, isShortProfile: true, managedObject: NSManagedObject())
		let uploadVC = UploadAnimationViewController(viewModel: vm)
//		uploadVC.workOrder = self.startCarViewModel?.workOrder
//		uploadVC.vehicleInfo = self.startCarViewModel?.vehicalInfo
		self.navigationController?.pushViewController(uploadVC, animated: true)
	}
	
}
