//
//  VehicalInformationViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy   on 24/04/23.
//

import UIKit

class VehicalVINScannerViewController:  BaseViewController {
		
	@IBOutlet weak var offlineView: UIView!
	@IBOutlet weak var offlineViewHeight: NSLayoutConstraint!
	
	init(viewModel: VehicleVinScannerViewModel) {
		super.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
		//super.init()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	@IBOutlet weak var scanLabel: UILabel! {
		didSet {
			//scanLabel.isHidden = false
		}
	}
	
	@IBOutlet weak var barCodeView: UIView! {
		didSet {
			//barCodeView.isHidden = false
		}
	}
	
	@IBOutlet weak var clearButton: UIButton!{
		didSet {
			clearButton.layer.cornerRadius = 5
			clearButton.layer.borderWidth = 1
			clearButton.layer.borderColor = UIColor.appCalendarLightGrayColor().cgColor
		}
	}
	@IBOutlet weak var vehicleInfoLabel: UILabel! {
		didSet {
			vehicleInfoLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
		}
	}

	@IBOutlet weak var screenCountLabel: UILabel! {
		didSet {
			screenCountLabel.layer.cornerRadius = screenCountLabel.frame.size.width / 2
			screenCountLabel.clipsToBounds = true
			screenCountLabel.text = "2/5"
		}
	}
	@IBOutlet weak var cancelButton: UIButton! {
		didSet {
			cancelButton.layer.cornerRadius = 8
		}
	}
	@IBOutlet weak var backButton: UIButton! {
		didSet {
			backButton.layer.cornerRadius = 8
			
		}
	}
	@IBOutlet weak var nextButton: UIButton! {
		didSet {
			nextButton.layer.cornerRadius = 8
			
		}
	}
	
	@IBOutlet weak var barcodeTextField: UITextField!
	// CardViewInfo
	@IBOutlet weak var vimTitle: UILabel!
	@IBOutlet weak var vimName: UILabel!
	@IBOutlet weak var vimModel: UILabel!
	@IBOutlet weak var vimYear: UILabel!
	@IBOutlet weak var vimBodyStyle: UILabel!
	var delegate: PassVehicleInformationDelegate?
	public var viewModel: VehicleVinScannerViewModel?
	var networkStatus = NotificationCenter.default
	let natificationName = NSNotification.Name(rawValue:"InternetObserver")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		FirebaseLogging.instance.logScreen(screenName: ClassNames.enterVin)
		let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
		view.addGestureRecognizer(tapGesture)
		viewModel?.delegate = self
		self.barcodeTextField.delegate = self
		nextButton.isUserInteractionEnabled = true
		offlineViewHeight.constant = 0
		offlineView.isHidden = true
		addCustomView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationItem.setHidesBackButton(true, animated:true)
		let menuBarButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.menuButtonAction(_ :)))
		menuBarButton.tintColor = UIColor.appPrimaryColor()
		self.navigationItem.leftBarButtonItem  = menuBarButton
		self.view.activityStopAnimating()
		if  NetworkManager.sharedInstance.reachability.connection == .unavailable {
			self.showAndHideOffline(isShowOfflineView: true)
		}
		networkStatus.addObserver(self, selector: #selector(self.showOffileViews(_:)), name: natificationName, object: nil)
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
			FirebaseLogging.instance.logEvent(eventName:OfflineEvents.offlineBannerVisible, parameters: nil)
		} else {
			offlineViewHeight.constant = 0
			offlineView.isHidden = true
		}
	}
	
	@IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
		sender.target = revealViewController()
		sender.action = #selector(revealViewController()?.revealSideMenu)
	}
	
	@IBAction func barcodeScannerButtonAction(_ sender: UIButton) {
		FirebaseLogging.instance.logEvent(eventName: EnterVinScreenEvents.vinScanner, parameters: nil)
		let storyBaord = UIStoryboard.init(name: "Main", bundle: nil)
		let vc = storyBaord.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
		vc.delegate = self
		self.barcodeTextField.resignFirstResponder()
		self.navigationController?.pushViewController(vc, animated: true)
	}
		
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func nextButtonAction(_ sender: UIButton) {
		if let textFieldData = barcodeTextField.text, textFieldData.count <= 17,  isValidVinNumber(textFieldData) == true {
			//regex validation for vin
			self.fetchVehicalInformation(vin: self.barcodeTextField?.text ?? "N/A")
		} else {
			let dialogMessage = UIAlertController(title: "WHOOPS!", message: "Please enter a Valid Vin Number ", preferredStyle: .alert)
			// Create OK button with action handler
			let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
			})
			self.nextButton.isUserInteractionEnabled = false
			self.nextButton.isEnabled = false
			dialogMessage.addAction(ok)
			self.present(dialogMessage, animated: true, completion: nil)
		}
	}
}
extension VehicalVINScannerViewController: ScannerViewDelegate {
	func didFindScannedText(text: String) {
		//regex validation for vin
		if  text.count <= 17,  isValidVinNumber(text) == true {
			self.barcodeTextField?.text = text
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
}

extension VehicalVINScannerViewController: UITextFieldDelegate {
//	func textFieldDidBeginEditing(_ textField: UITextField) {
//		self.barcodeTextField?.text = "JN1AZ0CPXCT026887"
//		//singleframeVin
//		//"3FA6P0LU8JR142415"
//		//MultiFrame with BMS
//		//"1N4BZ1CP3LC310701"
//		//MultiFrame with SOC
//		//old leaf
//		//1N4BZ0CP4GC311050
//		//1N4AZ0CP3FC331073
//		//"1N4BZ1DP7LC310036"
//	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
	
		if let textFieldData = textField.text, textFieldData.count <= 17,  isValidVinNumber(textFieldData) == true {
			self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
			self.fetchVehicalInformation(vin:  textField.text ?? "N/A")
			
		} else {
			self.view.activityStopAnimating()
			let dialogMessage = UIAlertController(title: "WHOOPS!", message: "Please enter a valid Vin number", preferredStyle: .alert)
			// Create OK button with action handler
			let ok = UIAlertAction(title: "GOT IT", style: .default, handler: { (action) -> Void in
			})
			self.nextButton.isUserInteractionEnabled = false
			self.nextButton.isEnabled = false
			//Add OK button to a dialog message
			dialogMessage.addAction(ok)
			self.view.activityStopAnimating()
			// Present Alert to
			self.present(dialogMessage, animated: true, completion: nil)
		}
		textField.resignFirstResponder()
		return true
	}
	
	private func fetchVehicalInformation(vin: String) {
		if currentReachabilityStatus != .notReachable {
			self.nextButton.isUserInteractionEnabled = true
			self.nextButton.isEnabled = true
			self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
			self.viewModel?.fetchVehicalInformation(vim: vin)
		} else {
			let alertViewController = UIAlertController.init(title: "Oops!", message: "Please check your network connection", preferredStyle: .alert)
			let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
				self.view.activityStopAnimating()
			})
			alertViewController.addAction(ok)
			self.present(alertViewController, animated: true, completion: nil)
		}
	}
	
}

extension VehicalVINScannerViewController: PassVehicleInformationDelegate {
	func handleErrorVehicleInfoUpdate(message: String) {
		self.view.activityStopAnimating()
		func showAlertMessage(title: String, mesg: String, actionMessage: String) {
			let dialogMessage = UIAlertController(title: title, message: mesg, preferredStyle: .alert)
			// Create OK button with action handler
			let ok = UIAlertAction(title: actionMessage, style: .default, handler: { (action) -> Void in
				self.view.activityStopAnimating()
			})
			dialogMessage.addAction(ok)
			// Present Alert to
			self.present(dialogMessage, animated: true, completion: nil)
		}
		if message == "Network Error" {
			showAlertMessage(title: "Oops!", mesg: "Please check your network connection", actionMessage: "Ok")
		} else {
			showAlertMessage(title: "WHOOPS!", mesg: "This vehicle is not supported to run the test. Check testable vehicles.", actionMessage: "GOT IT")
		}
		
	}
	
	func updateVehicleInfo(viewModel: VehicleVinScannerViewModel) {
		self.view.activityStopAnimating()
		nextButton.isUserInteractionEnabled = true
		nextButton.isEnabled = true
		if (viewModel.vehicleInformation?.getBatteryTestInstructions) != nil {
			let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
			let vehicalInformation = storyBoard.instantiateViewController(withIdentifier: "VehicalInformationViewController") as! VehicalInformationViewController
			if let vehicleInfo = viewModel.vehicleInformation {
				vehicalInformation.viewModel = VehicleInformationViewModel(vinNumber: vehicleInfo.vin, vehicleInformation: vehicleInfo)
			}
			
			self.navigationController?.pushViewController(vehicalInformation, animated: true)
			
		} else {
			let dialogMessage = UIAlertController(title: "WHOOPS!", message: "This vehicle is not supported to run the test. Check testable vehicles.", preferredStyle: .alert)
			// Create OK button with action handler
			let ok = UIAlertAction(title: "GOT IT", style: .default, handler: { (action) -> Void in
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
		let emailRegEx = "(?=.*\\d|=.*[A-Z])(?=.*[A-Z])[A-Z0-9]{17}"
		
		let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailPred.evaluate(with: vinNumber)
	}
}
