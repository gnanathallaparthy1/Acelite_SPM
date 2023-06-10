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
	
	@IBOutlet weak var barCodeTextField: UITextField!
	@objc public weak var delegate: ScannerViewDelegate?
	override func viewDidLoad() {
		super.viewDidLoad()
		FirebaseLogging.instance.logScreen(screenName: ClassNames.workOrder)
		barCodeTextField.delegate = self
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
		let storyBaord = UIStoryboard.init(name: "Main", bundle: nil)
		let vc = storyBaord.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
		vc.delegate = self
		self.barCodeTextField.resignFirstResponder()
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func nextButtonAction(_ sender: UIButton) {
		//if let workOrder = self.barCodeTextField?.text?.description
		let paramDictionary = [
			Parameters.workOrder: self.barCodeTextField?.text?.description ?? "N/A"
		  ]
		FirebaseLogging.instance.logEvent(eventName: WorkOrderScreenEvents.workOrderInput, parameters: paramDictionary)
		let storyBoard = UIStoryboard.init(name: "BatteryHealthCheck", bundle: nil)
		let testingVC = storyBoard.instantiateViewController(withIdentifier: "BatteryHealthCheckViewController") as! BatteryHealthCheckViewController
		
		if let vehicleInfo = self.vehicleInfo {
			let vm = BatteryHealthCheckViewModel(vehicleInfo: vehicleInfo, workOrder: self.barCodeTextField?.text?.description)
			testingVC.viewModel = vm
		}
			
		self.navigationController?.pushViewController(testingVC, animated: true)
		
	}
}

extension WorkOrderViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		guard let vinNumber = textField.text, vinNumber.count > 0 else {
			self.showAlertMessage(message: "Please enter valid Work order number.")
			return true
		}
		textField.resignFirstResponder()
		return true
	}
	
	private func showAlertMessage(message: String) {
		let dialogMessage = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
		// Create OK button with action handler
		let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in

		})
		//self.nextButton.isUserInteractionEnabled = false
		//self.nextButton.isEnabled = false
		//Add OK button to a dialog message
		dialogMessage.addAction(ok)
		// Present Alert to
		self.present(dialogMessage, animated: true, completion: nil)
	}
}

extension WorkOrderViewController: ScannerViewDelegate {
	func didFindScannedText(text: String) {
		//regex validation for vin
		if  text.count <= 17,  isValidVinNumber(text) == true {
			self.barCodeTextField?.text = text
			self.nextButton.isUserInteractionEnabled = true
			self.nextButton.isEnabled = true
		} else {
			let dialogMessage = UIAlertController(title: "WHOOPS!", message: "Please enter a Valid Vin Number ", preferredStyle: .alert)
			// Create OK button with action handler
			let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
				DispatchQueue.main.async {
					self.navigationController?.popViewController(animated: true)
				}
			})
			self.nextButton.isUserInteractionEnabled = false
			self.nextButton.isEnabled = false
			//Add OK button to a dialog message
			dialogMessage.addAction(ok)
			// Present Alert to
			self.present(dialogMessage, animated: true, completion: nil)
		}
	   
	}
	
	func isValidVinNumber(_ vinNumber: String) -> Bool {
		let vinRegEx = "(?=.*\\d|=.*[A-Z])(?=.*[A-Z])[A-Z0-9]{17}"
//RegExp("^[A-HJ-NPR-Z\\d]{8}[\\dX][A-HJ-NPR-Z\\d]{2}\\d{6}$")
		let vinPred = NSPredicate(format:"SELF MATCHES %@", vinRegEx)
		return vinPred.evaluate(with: vinNumber)
	}
}
