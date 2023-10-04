//
//  WorkOrderViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 1/12/23.
//

import UIKit

class WorkOrderViewController: BaseViewController {
	
	@IBOutlet weak var offlineViewHeight: NSLayoutConstraint!
	@IBOutlet weak var offlineView: UIView!
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
	var networkStatus = NotificationCenter.default
	let natificationName = NSNotification.Name(rawValue:"InternetObserver")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		FirebaseLogging.instance.logScreen(screenName: ClassNames.workOrder)
		barCodeTextField.delegate = self
		offlineViewHeight.constant = 0
		offlineView.isHidden = true
		addCustomView()
	}
	
	private func addCustomView() {
		let allViewsInXibArray = Bundle.main.loadNibNamed("CustomView", owner: self, options: nil)
		let view = allViewsInXibArray?.first as! CustomView
		view.frame = self.offlineView.bounds
		view.viewType = .WARINING
		view.arrowButton.isHidden = true
		view.layer.borderColor = UIColor.offlineViewBorderColor().cgColor
		view.layer.borderWidth = 4
		view.layer.cornerRadius = 8
		view.backgroundColor = .white
		view.setupView(message: Constants.OFFLINE_MESSAGE)
		self.offlineView.addSubview(view)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationItem.setHidesBackButton(true, animated:true)
		
		let menuBarButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.menuButtonAction(_ :)))
		menuBarButton.tintColor = UIColor.appPrimaryColor()
		self.navigationItem.leftBarButtonItem  = menuBarButton
		if  NetworkManager.sharedInstance.reachability.connection == .unavailable {
			self.showAndHideOffline(isShowOfflineView: true)
		}
		networkStatus.addObserver(self, selector: #selector(self.showOffileViews(_:)), name: natificationName, object: nil)
	}
	@objc func showOffileViews(_ notification: Notification) {
		
		let notificationobject = notification.object as? [String: Any] ?? [:]
		guard let isShowOfflineView: Bool = notificationobject["isConected"] as? Bool else {
			return
		}
		self.showAndHideOffline(isShowOfflineView: isShowOfflineView)
	}
	
	private func showAndHideOffline(isShowOfflineView: Bool) {
		if isShowOfflineView  {
			offlineViewHeight.constant = 60
			offlineView.layer.cornerRadius = 8
			offlineView.layer.borderColor = UIColor.offlineViewBorderColor().cgColor
			offlineView.layer.borderWidth = 4
			offlineView.isHidden = false
		} else {
			offlineViewHeight.constant = 0
			offlineView.isHidden = true
		}
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
		guard let workOrder = self.barCodeTextField?.text, workOrder.count > 0 else {
			self.showAlertMessage(message: "Please enter valid Work order number.")
			return
		}
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
		dialogMessage.addAction(ok)
		// Present Alert to
		self.present(dialogMessage, animated: true, completion: nil)
	}
}

extension WorkOrderViewController: ScannerViewDelegate {
	func didFindScannedText(text: String) {
			self.barCodeTextField?.text = text
			self.nextButton.isUserInteractionEnabled = true
			self.nextButton.isEnabled = true
	}
	
}
