//
//  VehicalInformationViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 12/23/22.
//

import UIKit
import FirebaseDatabase
import Firebase

class VehicalInformationViewController:  BaseViewController {
	
	@IBOutlet weak var offlineView: UIView!
	@IBOutlet weak var offlineViewHeight: NSLayoutConstraint!
	
	init(viewModel: VehicleInformationViewModel) {
		super.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
		//super.init()
	}
	required init?(coder: NSCoder) {
		//form = Form()
		super.init(coder: coder)
	}
	var delegate:UpdateVehicleInformationDelegate?
	public var viewModel: VehicleInformationViewModel?
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
	@IBOutlet weak var carInfoView: UIView! {
		didSet {
			//barCodeView.isHidden = true
		}
	}
	@IBOutlet weak var screenCountLabel: UILabel! {
		didSet {
			screenCountLabel.layer.cornerRadius = screenCountLabel.frame.size.width / 2
			screenCountLabel.clipsToBounds = true
			screenCountLabel.text = "4/5"
		}
	}
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
	@IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var stackViewWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var quickTestButton: UIButton! {
		didSet {
			quickTestButton.layer.cornerRadius = 8
		}
	}
	@IBOutlet weak var barcodeTextField: UITextField!
	// CardViewInfo
	@IBOutlet weak var vimTitle: UILabel!
	@IBOutlet weak var vimName: UILabel!
	@IBOutlet weak var vimModel: UILabel!
	@IBOutlet weak var vimYear: UILabel!
	@IBOutlet weak var vimBodyStyle: UILabel!
	var networkStatus = NotificationCenter.default
	let natificationName = NSNotification.Name(rawValue:"InternetObserver")
	var remoteConfig = RemoteConfig.remoteConfig()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		FirebaseLogging.instance.logScreen(screenName: ClassNames.vehicleInformation)
		viewModel?.delegate = self
		//self.barcodeTextField.delegate = self
		carInfoView.isHidden = false
		self.vimTitle.text = viewModel?.vehicleInformation?.title
		self.vimModel.text = viewModel?.vehicleInformation?.modelName
		self.vimName.text = viewModel?.vehicleInformation?.vin
		let yr = viewModel?.vehicleInformation?.year
		self.vimYear.text = "\(String(describing: yr))"
		self.vimBodyStyle.text = viewModel?.vehicleInformation?.bodyStyle
		self.vehicleInfoLabel.text = viewModel?.vinNumber
		nextButton.addTarget(self, action: #selector(self.nextButtonAction(_:)), for: .touchUpInside)
		cancelButton.addTarget(self, action: #selector(self.cancelButtonAction(_:)), for: .touchUpInside)
		// Do any additional setup after loading the view.
		offlineViewHeight.constant = 0
		offlineView.isHidden = true
		addCustomView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationItem.setHidesBackButton(true, animated:true)
		
		let menuBarButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.menuButtonAction(_ :)))
		menuBarButton.tintColor = UIColor.appPrimaryColor()
		self.navigationItem.leftBarButtonItem  = menuBarButton
		if  NetworkManager.sharedInstance.reachability.connection == .unavailable {
			self.showOffile(isShowOfflineView: true)
		}
		networkStatus.addObserver(self, selector: #selector(self.showOffileViews(_:)), name: natificationName, object: nil)
		retrieveProfileConfigButtonTitles()
	}
	
	private func retrieveProfileConfigButtonTitles() {
		let profile_test_detail_information = remoteConfig.configValue(forKey: "profile_test_detail_information").jsonValue as? AnyObject
		print(profile_test_detail_information)
		let longProfile = profile_test_detail_information?.value(forKey: "longProfile") as? String
		let shortProfile = profile_test_detail_information?.value(forKey: "shortProfile") as? String
		buttonTitleUpdate(quickTestTitle: shortProfile, nextButtonTitle: longProfile)
	}
	
	private func buttonTitleUpdate(quickTestTitle: String?, nextButtonTitle: String?) {
		quickTestButton.setTitle( quickTestTitle, for: .normal)
		nextButton.setTitle(nextButtonTitle, for: .normal)
		if self.viewModel?.ifShortProfile == true {
			self.nextButton.isHidden = true
			quickTestButton.setTitle( "Next", for: .normal)
			stackViewHeightConstraint.constant = 35
			stackViewWidthConstraint.constant = 86
		} else {
			self.nextButton.isHidden = false
			stackViewHeightConstraint.constant = 120
		}
		
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
		self.showOffile(isShowOfflineView: isShowOfflineView)
	}
	
	private func showOffile(isShowOfflineView: Bool) {
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
	
	@IBAction func barcodeScannerButtonAction(_ sender: UIButton) {
		let storyBaord = UIStoryboard.init(name: "Main", bundle: nil)
		let vc = storyBaord.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
		vc.delegate = self
		self.navigationController?.pushViewController(vc, animated: true)
	}
		
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func nextButtonAction(_ sender: UIButton) {
		guard let instructions = self.viewModel?.vehicleInformation?.getBatteryTestInstructions, instructions.count > 0 else { return  }
		let instructionId = instructions.first
		let workorder: String = viewModel?.workOrder ?? ""
		let paramDictionary = [
			Parameters.workOrder: workorder,
			Parameters.batteryTestInstructionsId: "\(instructionId?.testCommands?.id ?? "")",
			Parameters.year: "\(self.viewModel?.vehicleInformation?.year ?? 0)", Parameters.make : self.viewModel?.vehicleInformation?.make ?? "", Parameters.model:  self.viewModel?.vehicleInformation?.modelName ?? "", Parameters.trim: self.viewModel?.vehicleInformation?.trimName ?? "" , Parameters.locationCode: "\(self.viewModel?.locationCode ?? "")"] as [String : String]
		FirebaseLogging.instance.logEvent(eventName:BMSCapacityTest.stressTest, parameters: paramDictionary)
		
		
		let storyBoard = UIStoryboard.init(name: "BatteryHealthCheck", bundle: nil)
		let testingVC = storyBoard.instantiateViewController(withIdentifier: "BatteryHealthCheckViewController") as! BatteryHealthCheckViewController
		
		if let vehicleInfo = self.viewModel?.vehicleInformation {
			let vm = BatteryHealthCheckViewModel(vehicleInfo: vehicleInfo, workOrder: viewModel?.workOrder, locationCode: self.viewModel?.locationCode ?? "aaa")
			testingVC.viewModel = vm
		}
		self.navigationController?.pushViewController(testingVC, animated: true)
	}
	
	@IBAction func quickTestButtonAction(_ sender: UIButton) {
		
		guard let instructions = self.viewModel?.vehicleInformation?.getBatteryTestInstructions, instructions.count > 0 else {
			return
			
		}
		let instructionId = instructions.first
		let workorder: String = viewModel?.workOrder ?? ""
		let paramDictionary = [
			Parameters.workOrder:  workorder ,
			Parameters.batteryTestInstructionsId: "\(instructionId?.testCommands?.id ?? "")",
			Parameters.year: "\(self.viewModel?.vehicleInformation?.year ?? 0)", Parameters.make : self.viewModel?.vehicleInformation?.make ?? "", Parameters.model:  self.viewModel?.vehicleInformation?.modelName ?? "", Parameters.trim: self.viewModel?.vehicleInformation?.trimName ?? "", Parameters.locationCode: "\(self.viewModel?.locationCode ?? "")" ] as [String : String]
		FirebaseLogging.instance.logEvent(eventName:BMSCapacityTest.quickTest, parameters: paramDictionary)
		
		let storyBoard = UIStoryboard.init(name: "BatteryHealthCheck", bundle: nil)
		let startCarVC = storyBoard.instantiateViewController(withIdentifier: "StartCarViewController") as! StartCarViewController
		startCarVC.startCarViewModel = StartCarViewModel(vehicalInfo: self.viewModel?.vehicleInformation, workOrder: self.viewModel?.workOrder, locationCode:  self.viewModel?.locationCode ?? "")
		self.navigationController?.pushViewController(startCarVC, animated: true)
	}

}

extension VehicalInformationViewController: ScannerViewDelegate {
	func didFindScannedText(text: String) {
		self.barcodeTextField?.text = text
	}
	
	
}

extension VehicalInformationViewController: UITextFieldDelegate {
	
//	func textFieldDidBeginEditing(_ textField: UITextField) {
//		//self.barcodeTextField?.text = "1N4BZ1CP3LC310701"
//		//singleframeVin
//		//"3FA6P0LU8JR142415"
//		//MultiFrame with BMS
//		//"1N4BZ1CP3LC310701"
//		//MultiFrame with SOC
//		//1N4BZ0CP4GC311050
//		//1N4AZ0CP3FC331073
//	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == self.barcodeTextField && textField.text?.count ?? 0 > 0 {
				self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
			guard let vinNumber = textField.text, vinNumber.count > 0 else {
				self.showAlertMessage(message: "Please enter valid VIN number.")
				return true
			}
				self.viewModel?.fetchVehicalInformation(vim: vinNumber)
		}
		textField.resignFirstResponder()
		return true
	}
}

extension VehicalInformationViewController: UpdateVehicleInformationDelegate {
	func updateVehicleInfo(viewModel: VehicleInformationViewModel) {
		self.view.activityStopAnimating()
		if (viewModel.vehicleInformation?.getBatteryTestInstructions) != nil {
			self.vimTitle.text = viewModel.vehicleInformation?.title
			self.vimModel.text = viewModel.vehicleInformation?.modelName
			self.vimName.text = viewModel.vehicleInformation?.vin
			let yr = viewModel.vehicleInformation?.year
			self.vimYear.text = "\(String(describing: yr))"
			self.vimBodyStyle.text = viewModel.vehicleInformation?.bodyStyle
			self.vehicleInfoLabel.text = viewModel.vinNumber
			self.nextButton.isUserInteractionEnabled = true
			self.nextButton.isEnabled = true
		} else {
			self.showAlertMessage(message: "There is a problem retreiving vehicle data. Please try again")
		}

	}
	private func showAlertMessage(message: String) {
		let dialogMessage = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
		// Create OK button with action handler
		let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in

		})
		self.nextButton.isUserInteractionEnabled = false
		self.nextButton.isEnabled = false
		//Add OK button to a dialog message
		dialogMessage.addAction(ok)
		// Present Alert to
		self.present(dialogMessage, animated: true, completion: nil)
	}
	
	func handleErrorVehicleUpdate() {
		self.view.activityStopAnimating()
	}
}
