//
//  BatteryHealthCheckViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/13/23.
//

import UIKit
import Firebase
import CoreData

enum BatteryHealthInstruction: Int {
   case startTheCar = 0
   case startClimateControls
   case testInProgresInitial
   case turnOffClimateControls
   case testInprogressFinal
	
	var title: String {
		get {
			switch self {
			case .startTheCar:
				return "Start the car"
			case .startClimateControls:
				return "Start climate controls"
			case .testInProgresInitial:
				return  "Test in progress…"
			case .turnOffClimateControls:
				return "Turn OFF all climate controls"
			case .testInprogressFinal:
				return "Test in progress…"
			}
		}
	}
	
	var bodyTitle: String {
		get {
			switch self {
	   
			case .startTheCar:
				return "Turn on the car, hit Start and wait 1 minute till the car reaches a stable state."
			case .startClimateControls:
				return "If the weather is cold…"
			case .testInProgresInitial:
				return "IMPORTANT: As soon as the countdown ends, turn off the climate controls and hit “Continue” then wait one minute till the vehicle reach a stable state."
			case .turnOffClimateControls:
				return "Turn off the climate controls and hit “Start” to reach stable state and upload the data."
			case .testInprogressFinal:
				return "ALL CLIMATE CONTROLS MUST BE OFF"
			}
		}
	}
	
	var bodySubtitle: String {
		get {
			switch self {
			case .startTheCar:
				return "ALL CLIMATE CONTROLS MUST BE OFF"
			case .startClimateControls:
				return "Put the heating on the Auto and Hi settings."
			case .testInProgresInitial:
				return ""
			case .turnOffClimateControls:
				return ""
			case .testInprogressFinal:
				return ""
			}
		}
	}
	
}
class BatteryHealthCheckViewController:  BaseViewController {
	
	@IBOutlet weak var offlineView: UIView!
	
	@IBOutlet weak var offlineViewHeight: NSLayoutConstraint!
	@IBOutlet weak var bodyContentHeightConstrants: NSLayoutConstraint!
	@IBOutlet weak var centerViewContentHeight: NSLayoutConstraint!
	//One
	@IBOutlet weak var climateControlImageOne: UIImageView!
	
	@IBOutlet weak var imageOneWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var firstViewTitle: UILabel!
	@IBOutlet weak var firstViewSubtitle: UILabel! // use warning as warning label
	//Two
	@IBOutlet weak var climateControlImageTwo: UIImageView!
	@IBOutlet weak var imageTwoWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var secondViewTitle: UILabel!
	@IBOutlet weak var secondViewSubtitle: UILabel!
	
	@IBOutlet weak var bodyTitleLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var contentView: UIView!
	@IBOutlet weak var startButton: UIButton!
	@IBOutlet weak var circleView: CircularProgressBarView!
	@IBOutlet weak var timeLabel: UILabel!
	private let notificationCenter = NotificationCenter.default
	var delegate:GetPreSignedUrlDelegate?
	var infoPooDelegate: InfoPopAlertViewDelegate? = nil
	private var backgroundTask: UIBackgroundTaskIdentifier = .invalid

	public var viewModel: BatteryHealthCheckViewModel?
	var networkStatus = NotificationCenter.default
	let natificationName = NSNotification.Name(rawValue:"InternetObserver")
	
	init(viewModel: BatteryHealthCheckViewModel) {
		super.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
		//super.init()
	}
	required init?(coder: NSCoder) {
		//form = Form()
		super.init(coder: coder)
	}
	var secoonds : Int = 0
	var timer: Timer?
	var isStart: Bool = false
	var batteryHealthInstruction: BatteryHealthInstruction = .startTheCar
	
	override func viewDidLoad() {
		super.viewDidLoad()
		FirebaseLogging.instance.logScreen(screenName: ClassNames.testInstructions)
		updateView()
		self.navigationItem.hidesBackButton = true
		self.viewModel?.preSignedDelegate = self
		self.viewModel?.uploadAndSubmitDelegate = self
		Network.shared.bluetoothService?.bleNonResponseDelegate = self
		offlineViewHeight.constant = 0
		offlineView.isHidden = true
		addCustomView()
		wrongCommand()
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
		view.setupView(message: Constants.APP_RECONNECT_INTERNET_MESSAGE)
		self.offlineView.addSubview(view)
	}
	
	private func wrongCommand() {
		Network.shared.bluetoothService?.writeByteDataOnDevice(commandType: .Other, data: "ATZ00", completionHandler: { data in
			print("NOOO data")
		})
	}
	
	override func viewWillAppear(_ animated: Bool) {
		setUpCircularProgressBarView()
		self.updateBodyContentView(batteryHealthInstruction: .startTheCar)
		setDefaultRemoteConfigDefaults()
		fetchRemoteConfig()
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
			FirebaseLogging.instance.logEvent(eventName:OfflineEvents.offlineBannerVisible, parameters: nil)
		} else {
			offlineViewHeight.constant = 0
			offlineView.isHidden = true
		}
	}
	
	func fetchRemoteConfig() {

		RemoteConfig.remoteConfig().fetch(withExpirationDuration: 0) { (status, error) in
			guard error == nil else {
				print("Got an error fetching remote values: \(String(describing: error))")
				self.setDefaultRemoteConfigDefaults()
				self.updateViewWithRCValues()
				return
			}
			RemoteConfig.remoteConfig().fetchAndActivate()
		self.viewModel?.isJSON  = true
			self.updateViewWithRCValues()
		}
	}
	
	@objc func addTapped() {
		self.navigationController?.popViewController(animated: true)
	}
	
	func updateView() {
		startButton.layer.cornerRadius = 4.0
		contentView.layer.cornerRadius = 8.0
		climateControlImageOne.layer.cornerRadius = 25
		climateControlImageTwo.layer.cornerRadius = 25
	}
	
	@IBAction func startButtonAction(_ sender: UIButton) {
		self.startButton.setTitle("In progress...", for: .normal)
		self.startButton.isUserInteractionEnabled = false
		self.startButton.backgroundColor = AceliteColors.buttonBgColorGray
		backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
			self?.endBackgroundTask()
		}
		switch batteryHealthInstruction {
		case .startTheCar:
			deleteExistingLogFile()
			FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.instructionsStep1Started, parameters: nil)
			// both booleans are true
				self.viewModel?.initialCommand()
				self.viewModel?.isTimeInProgress = true
			self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector:(#selector(updateTimerforStartCar)), userInfo: nil, repeats: true)
		case .startClimateControls:
			FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.instructionsStep2Started, parameters: nil)
			self.updateBodyContentView(batteryHealthInstruction: .testInProgresInitial)
			updateViewWithRCValues()
			self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector:(#selector(updateTimerforStartClimateControls)), userInfo: nil, repeats: true)
		case .testInProgresInitial:
			self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector:(#selector(updateTimerforTestInProgressInitial)), userInfo: nil, repeats: true)
		case .turnOffClimateControls:
			FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.instructionsStep3Started, parameters: nil)
			self.updateBodyContentView(batteryHealthInstruction: .testInprogressFinal)
			self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector:(#selector(updateTimerforTurnOffClimateControls)), userInfo: nil, repeats: true)
		case .testInprogressFinal:
			updateViewWithRCValues()
			self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector:(#selector(updateTimerforTestInProgressFinal)), userInfo: nil, repeats: true)
		}
		circleView.progressAnimation(duration: TimeInterval(secoonds ))
	}
	private func endBackgroundTask() {
		UIApplication.shared.endBackgroundTask(backgroundTask)
		backgroundTask = .invalid
	}
	
	func updateBodyContentView(batteryHealthInstruction: BatteryHealthInstruction)  {
		switch batteryHealthInstruction {
			
		case .startTheCar:
			bodyTitleLabel.text = batteryHealthInstruction.title
			firstViewTitle.text = batteryHealthInstruction.bodyTitle
			firstViewSubtitle.text =  batteryHealthInstruction.bodySubtitle
			firstViewTitle.font = UIFont(name: "Arial", size: 14)
			firstViewSubtitle.textColor = .red
			centerViewContentHeight.constant = 380
			bodyContentHeightConstrants.constant = 70
			imageOneWidthConstraint.constant = 0
			imageTwoWidthConstraint.constant = 0
			secondViewTitle.text = ""
			secondViewSubtitle.text = ""
		
		case .startClimateControls:
			circleView.changeProgresslayerStockeColor(progress: UIColor.appPrimaryColor(), circle: .white)
			bodyTitleLabel.text = "Start climate controls"//batteryHealthInstruction.title
			firstViewTitle.text = batteryHealthInstruction.bodyTitle
			firstViewTitle.font = UIFont(name: "Arial-BoldMT", size: 14)
			firstViewSubtitle.text = batteryHealthInstruction.bodySubtitle
			firstViewSubtitle.textColor = UIColor.bodySubtitleTextColor()
			centerViewContentHeight.constant = 425
			bodyContentHeightConstrants.constant = 140
			imageOneWidthConstraint.constant = 50
			imageTwoWidthConstraint.constant = 50
			secondViewTitle.text = "If the weather is hot…"
			secondViewSubtitle.text = "Put the AC to Auto and Hi settings."
			
		case .testInProgresInitial:
			circleView.changeProgresslayerStockeColor(progress: UIColor.appPrimaryColor(), circle: .white)
			bodyTitleLabel.text = batteryHealthInstruction.title
			firstViewTitle.text = batteryHealthInstruction.bodyTitle
			firstViewTitle.font = UIFont(name: "Arial-BoldMT", size: 14)
			firstViewSubtitle.text = ""
			firstViewSubtitle.textColor = .lightGray
			firstViewTitle.textColor = UIColor.warningColor()
			centerViewContentHeight.constant = 380
			bodyContentHeightConstrants.constant = 60
			imageOneWidthConstraint.constant = 0
			imageTwoWidthConstraint.constant = 0
			secondViewTitle.text = ""
			secondViewSubtitle.text = ""
			
		case .turnOffClimateControls:
			circleView.changeProgresslayerStockeColor(progress: UIColor.appPrimaryColor(), circle: .white)
			bodyTitleLabel.text = batteryHealthInstruction.title
			firstViewTitle.text = batteryHealthInstruction.bodyTitle
			firstViewTitle.textColor = UIColor.warningColor()
			firstViewTitle.font = UIFont(name: "Arial-BoldMT", size: 14)
			firstViewSubtitle.text = ""
			firstViewSubtitle.textColor = .lightGray
			centerViewContentHeight.constant = 380
			bodyContentHeightConstrants.constant = 60
			imageOneWidthConstraint.constant = 0
			imageTwoWidthConstraint.constant = 0
			secondViewTitle.text = ""
			secondViewSubtitle.text = ""
			
		case .testInprogressFinal:
			circleView.changeProgresslayerStockeColor(progress: UIColor.appPrimaryColor(), circle: .white)
			bodyTitleLabel.text = batteryHealthInstruction.title
			firstViewTitle.text = batteryHealthInstruction.bodyTitle
			firstViewTitle.textColor = UIColor.warningColor()
			firstViewTitle.font = UIFont(name: "Arial-BoldMT", size: 14)
			firstViewSubtitle.text = ""
			firstViewSubtitle.textColor = .lightGray
			centerViewContentHeight.constant = 380
			bodyContentHeightConstrants.constant = 60
			imageOneWidthConstraint.constant = 0
			imageTwoWidthConstraint.constant = 0
			secondViewTitle.text = ""
			secondViewSubtitle.text = ""
		}
	}
	
	func setDefaultRemoteConfigDefaults() {
		let defaultValues = [
			"totalTimeInMinutes": 5 as NSObject,
			"totalTimeInMs": 300000 as NSObject,
			"firstStepTimeInMs": 60000 as NSObject,
			"secondStepTimeInMs": 180000 as NSObject,
			"thirdStepTimeInMs": 60000 as NSObject,
			"timeInternal": 1000 as NSObject
		]
		RemoteConfig.remoteConfig().setDefaults(defaultValues)
	}

	
	func updateViewWithRCValues() {
		var timerValue: NSNumber?
		switch batteryHealthInstruction {
		case .startTheCar:
			//timerValue = 60000
			timerValue = RemoteConfig.remoteConfig().configValue(forKey: "firstStepTimeInMs").numberValue
		case .startClimateControls:
			// timerValue = 60000
			timerValue = RemoteConfig.remoteConfig().configValue(forKey: "secondStepTimeInMs").numberValue
			self.view.layoutSubviews()
		case .testInProgresInitial:
			 //timerValue = 60000
			timerValue = RemoteConfig.remoteConfig().configValue(forKey: "firstStepTimeInMs").numberValue
			self.view.layoutSubviews()
		case .turnOffClimateControls:
			 //timerValue = 60000
			timerValue = RemoteConfig.remoteConfig().configValue(forKey: "firstStepTimeInMs").numberValue
		case .testInprogressFinal:
			self.updateBodyContentView(batteryHealthInstruction: .testInprogressFinal)
			//timerValue = 60000
			timerValue = RemoteConfig.remoteConfig().configValue(forKey: "firstStepTimeInMs").numberValue
		}
		if let timer =  timerValue {
			secoonds = Int(truncating: timer) / 1000
		}
		DispatchQueue.main.async  {
			self.timeLabel.text = self.timeString(time: TimeInterval(self.secoonds)) //This will update the label.
		}
	}
	
	func setUpCircularProgressBarView() {
		circleView.createCircularPath()
		circleView.changeProgresslayerStockeColor(progress: UIColor.appPrimaryColor() , circle: .white )
		// align to the center of the screen
		circleView.center = circleView.center
	}
	
	func timeString(time:TimeInterval) -> String {
		let minutes = Int(time) / 60 % 60
		let seconds = Int(time) % 60
		
		return String(format:"%02i:%02i",minutes, seconds)
	}
	
	@objc func updateTimerforStartCar() {
		if self.secoonds == 0  {
			timer?.invalidate()
			//self.viewModel?.isLoopingTimeInProgress = false
			self.startButton.isUserInteractionEnabled = true
			self.updateBodyContentView(batteryHealthInstruction: .startClimateControls)
			self.batteryHealthInstruction = .startClimateControls
			self.startButton.setTitle("Start", for: .normal)
			self.startButton.backgroundColor = UIColor.appPrimaryColor()
			self.updateBodyContentView(batteryHealthInstruction: .startClimateControls)
			self.updateViewWithRCValues()
			
		} else {
			self.secoonds -= 1
			DispatchQueue.main.async  {
				self.timeLabel.text = self.timeString(time: TimeInterval(self.secoonds )) //This will update the label.
			}
		
		}
		runInLoopTimer()
	}
	
	@objc func updateTimerforStartClimateControls() {
		if self.secoonds == 0  {
			timer?.invalidate()
			self.startButton.isUserInteractionEnabled = true
			//self.viewModel?.isLoopingTimeInProgress = false
			self.updateBodyContentView(batteryHealthInstruction: .turnOffClimateControls)
			self.batteryHealthInstruction = .turnOffClimateControls
			self.startButton.setTitle("Start", for: .normal)
			self.startButton.backgroundColor = UIColor.appPrimaryColor()
			self.updateViewWithRCValues()
			
		} else {
			self.secoonds -= 1
			DispatchQueue.main.async  {
				self.timeLabel.text = self.timeString(time: TimeInterval(self.secoonds )) //This will update the label.
			}
		
		}
		runInLoopTimer()
	}
	
	private func runInLoopTimer() {
		// Schedule the timer to run in the background
		DispatchQueue.main.async {
			//let runLoop = RunLoop.current
			//runLoop.add(self.timer ?? Timer(), forMode: .common)
		}
		
	}
	
	
	@objc func updateTimerforTestInProgressInitial() {
		if self.secoonds == 0  {
			timer?.invalidate()
			self.startButton.isUserInteractionEnabled = true
			self.updateBodyContentView(batteryHealthInstruction: .turnOffClimateControls)
			self.batteryHealthInstruction = .turnOffClimateControls
		} else {
			self.secoonds -= 1
			DispatchQueue.main.async  {
				self.timeLabel.text = self.timeString(time: TimeInterval(self.secoonds )) //This will update the label.
			}
		
		}
		runInLoopTimer()
	}
	
	@objc func updateTimerforTurnOffClimateControls() {
		if self.secoonds == 0  {
			timer?.invalidate()
			self.startButton.isUserInteractionEnabled = true
			self.viewModel?.isTimeInProgress = false
			self.batteryHealthInstruction = .testInprogressFinal
		} else {
			self.secoonds -= 1
			DispatchQueue.main.async  {
				self.timeLabel.text = self.timeString(time: TimeInterval(self.secoonds )) //This will update the label.
			}
		
		}
		runInLoopTimer()
	}
	
	@objc func updateTimerforTestInProgressFinal() {
		if self.secoonds == 0  {
			timer?.invalidate()
		
			self.startButton.isUserInteractionEnabled = true
		} else {
			self.secoonds -= 1
			DispatchQueue.main.async  {
				self.timeLabel.text = self.timeString(time: TimeInterval(self.secoonds )) //This will update the label.
			}
		
		}
		runInLoopTimer()
	}

	
}
extension BatteryHealthCheckViewController: GetPreSignedUrlDelegate, UploadAndSubmitDataDelegate {
	func showNoDataFromCommandsAlert() {
		DispatchQueue.main.async  {
			let dialogMessage = UIAlertController(title: "Error", message: "Sorry,something went wrong.Please try again", preferredStyle: .alert)
			let ok = UIAlertAction(title: "GOT IT", style: .default, handler: { (action) -> Void in
				self.navigationController?.popToRootViewController(animated: true)
				if let pheriPheral = Network.shared.myPeripheral {
					Network.shared.bluetoothService?.disconnectDevice(peripheral: pheriPheral)
				}
			})
			dialogMessage.addAction(ok)
			self.present(dialogMessage, animated: true, completion: nil)
		}
	}
	
	@objc func navigateToHealthScoreVC() {
		self.notificationCenter.post(name: NSNotification.Name(rawValue: "GotAllData"), object: nil)
	}
	
	func navigateToAnimationVC() {
		timer?.invalidate()
		timer = nil
		var jsonString = ""
		let vm = UploadAnimationViewModel(vehicleInfo: (self.viewModel?.vehicleInfo)!, workOrder: self.viewModel?.workOrder, isShortProfile: false, managedObject: NSManagedObject())
		let vc = UploadAnimationViewController(viewModel: vm)
		vc.errorSheetSource = .INSTRUCTION_FLOW
		if self.viewModel?.isJSON == true {
			var minVlaue: Int = 0
			let listCount: [Int] = [self.viewModel?.packVoltageArray.count ?? 0,  self.viewModel?.packCurrentArray.count ?? 0, ((self.viewModel?.multiCellVoltageArray.count ?? 0) / (self.viewModel?.numberOfCells ?? 0)) ]
			
			minVlaue = listCount.min() ?? 0
			if minVlaue == 0 {
				print(Date(), "Min Count of the Data Files Not Fullfilled", to: &Log.log)
				return
			}
			
			if self.viewModel?.packVoltageArray.count ?? 0 > minVlaue {
				var pvDiff =  (self.viewModel?.packVoltageArray.count ?? 0) - minVlaue
				self.viewModel?.packVoltageArray.removeLast(pvDiff)
			}
			
			if self.viewModel?.packCurrentArray.count ?? 0 > minVlaue {
				let pcDiff =  (self.viewModel?.packCurrentArray.count ?? 0) - minVlaue
				self.viewModel?.packCurrentArray.removeLast(pcDiff)
			}
			
			if self.viewModel?.multiCellVoltageArray.count ?? 0 > minVlaue {
				let cvDiff = (self.viewModel?.multiCellVoltageArray.count ?? 0) - minVlaue
				self.viewModel?.multiCellVoltageArray.removeLast(cvDiff)
			}
			
			let packVoltageScan = ["packVoltageScan": self.viewModel?.packVoltageArray]
			let packCurrentScan = ["packCurrentScan": self.viewModel?.packCurrentArray]
			let packCellVoltageScan = ["packCellVoltageScan": self.viewModel?.multiCellVoltageArray]
			
			let mergedDictionary = packVoltageScan.merged(with: packCurrentScan)
			let finalDictionary = mergedDictionary.merged(with: packCellVoltageScan)
			
			jsonString = self.convertToJSONString(value: finalDictionary as AnyObject) ?? ""
			
			let finalDictJSON = self.convertToJSONString(value: finalDictionary as AnyObject) ?? ""
			
			print(finalDictJSON)
			
			let packVoltageScanString =  self.convertToJSONString(value: packVoltageScan as AnyObject) ?? ""
			let packCurrentScanString = self.convertToJSONString(value: packCurrentScan as AnyObject) ?? ""
			let packCellVoltageScanString = self.convertToJSONString(value: packCellVoltageScan as AnyObject) ?? ""
			let _ = packVoltageScanString + "," + packCurrentScanString + "," + packCellVoltageScanString
			
			vc.finalJsonString = jsonString
			
		}
		
		vc.vehicleInfo = viewModel?.vehicleInfo
		vc.sampledCommandsList = Network.shared.sampledCommandsList
		vc.isJsonEnabled = self.viewModel?.isJSON ?? false
		vc.workOrder = self.viewModel?.workOrder
		if let pc = viewModel?.packCurrentData {
			vc.packCurrentData = pc
		}
		if let pv = viewModel?.packVoltageData {
			vc.packVoltageData = pv
		}
		if let cv = viewModel?.cellVoltageData {
			vc.cellVoltageData = cv
		}
		if let soc = viewModel?.stateOfCharge {
			vc.stateOfCharge = soc
		}
		if let bms = viewModel?.bms {
			vc.bmsCapacity = bms
		}
		if let odometer = viewModel?.odometer {
			vc.odometer = odometer
		}
		if let currentEnergey = viewModel?.currentEnergy {
			vc.currentEnerygy = currentEnergey
		}
		
		if let numberofCell = viewModel?.numberOfCells {
			vc.numberofCells = numberofCell
		}
		if let multiCellVoltageData = viewModel?.multiCellVoltageData {
			vc.multiCellVoltageData = multiCellVoltageData
		}
		if let batteryInstrucId = Network.shared.batteryTestInstructionId {
			vc.testInstructionsId = batteryInstrucId
		}
		if let workOrd = viewModel?.workOrder {
			vc.workOrder = workOrd
		}

		let dialogMessage = UIAlertController(title: "TURN OFF THE CAR", message: "Turn off the car and disconnect the OBD-II cable.", preferredStyle: .alert)
		// Create OK button with action handler
		let ok = UIAlertAction(title: "Done", style: .default, handler: { (action) -> Void in
			self.endBackgroundTask()
			self.navigationController?.pushViewController(vc, animated: true)
		})
		//Add OK button to a dialog message
		dialogMessage.addAction(ok)
		// Present Alert to
		self.present(dialogMessage, animated: true, completion: nil)
		
	}
	
	func getTransactionIdInfo(viewModel: BatteryHealthCheckViewModel) {
		
	}
	
	func handleErrorTransactionID() {
		
	}
	
	func deleteExistingLogFile() {
		
		let fileManager = FileManager.default
		do {
			let path = try? fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
			let fileURL: URL = (path?.appendingPathComponent("\(Date.getCurrentDate()).txt"))!
			do {
				try FileManager.default.removeItem(at: fileURL)
				print("Image has been deleted")
			} catch {
				print(error)
			}
			
		}
	}
	
	func convertToJSONString(value: AnyObject) -> String? {
		if JSONSerialization.isValidJSONObject(value) {
			do{
				let data = try JSONSerialization.data(withJSONObject: value, options:  [.prettyPrinted])
				if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
					return string as String
				}
			}catch{
				print("error")
			}
		}
		print("nil")
		return nil
	}
	
}

extension BatteryHealthCheckViewController: BLENonResponsiveDelegate {
	func showBleNonResponsiveError() {
		let dialogMessage = UIAlertController(title: "Error", message: "Sorry,something went wrong.Please try again", preferredStyle: .alert)
		let ok = UIAlertAction(title: "GOT IT", style: .default, handler: { (action) -> Void in
			if let pheriPheral = Network.shared.myPeripheral {
				Network.shared.bluetoothService?.disconnectDevice(peripheral: pheriPheral)
			}
			self.navigationController?.popToRootViewController(animated: true)
		})
		dialogMessage.addAction(ok)
		self.present(dialogMessage, animated: true, completion: nil)
	}
	
	
}

extension Dictionary {
	var jsonData: Data? {
		return try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
	}
	
	func toJSONString() -> String? {
		if let jsonData = jsonData {
			let jsonString = String(data: jsonData, encoding: .utf8)
			return jsonString
		}
		
		return "[]"
	}
}

// MARK: - Merging two dictionariess
extension Dictionary {

	mutating func merge(with dictionary: Dictionary) {
		dictionary.forEach { updateValue($1, forKey: $0) }
	}

	func merged(with dictionary: Dictionary) -> Dictionary {
		var dict = self
		dict.merge(with: dictionary)
		return dict
	}
}
