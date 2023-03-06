//
//  WorkOrderViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 1/12/23.
//

import UIKit

class WorkOrderViewController: UIViewController {
	//pass this ia view model later
	public var vehicleInfo: Vehicle?
	
	@IBOutlet weak var cancelButton: UIButton! {
		didSet {
			cancelButton.layer.cornerRadius = 8
		}
	}
	@IBOutlet weak var nextButton: UIButton! {
		didSet {
			nextButton.layer.cornerRadius = 8
		}
	}
	@IBOutlet weak var backButton: UIButton! {
		didSet {
			backButton.layer.cornerRadius = 8
		}
	}
	@IBOutlet weak var countLabel: UILabel! {
		didSet {
			countLabel.text = "4/5"
			countLabel.layer.cornerRadius = countLabel.frame.size.width / 2
			countLabel.clipsToBounds = true
			
		}
	}
	@IBOutlet weak var barCodeTextFiled: UITextField!
	override func viewDidLoad() {
		super.viewDidLoad()
		barCodeTextFiled.delegate = self
		let vimDetails = Network.shared.vehicleInformation
		print(vimDetails?.vehicle?.title ?? "")
		
		
		// Do any additional setup after loading the view.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationItem.setHidesBackButton(true, animated:true)
		
		let menuBarButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.menuButtonAction(_ :)))
		menuBarButton.tintColor = UIColor.appPrimaryColor()
		self.navigationItem.leftBarButtonItem  = menuBarButton
	}
	
	@IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
		sender.target = revealViewController()
		sender.action = #selector(revealViewController()?.revealSideMenu)
	}
	
	@IBAction func barcodeButtonAction(_ sender: UIButton) {
	}
	
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func nextButtonAction(_ sender: UIButton) {
		let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
		let testingVC = storyBoard.instantiateViewController(withIdentifier: "TestingViewController") as! TestingViewController
		
		if let vehicleInfo = self.vehicleInfo {
			let vm = TestingViewModel(vehicleInfo: vehicleInfo)
			testingVC.viewModel = vm
		}
			
		self.navigationController?.pushViewController(testingVC, animated: true)
		
	}
}

extension WorkOrderViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
