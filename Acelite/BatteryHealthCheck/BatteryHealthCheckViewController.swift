//
//  BatteryHealthCheckViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/13/23.
//

import UIKit
import Firebase

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
class BatteryHealthCheckViewController: UIViewController {
	
	@IBOutlet weak var bodyContentHeightConstrants: NSLayoutConstraint!
	
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

	public var viewModel: BatteryHealthCheckViewModel?
	
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
	}
	
	override func viewWillAppear(_ animated: Bool) {
		setUpCircularProgressBarView()
		self.updateBodyContentView(batteryHealthInstruction: .startTheCar)
		setDefaultRemoteConfigDefaults()
		fetchRemoteConfig()
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
		switch batteryHealthInstruction {
		case .startTheCar:
			FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.instructionsStep1Started, parameters: nil)
			// both booleans are true
				self.viewModel?.handleInstructions()
			   // self.viewModel?.isLoopingTimeInProgress = true
			   // self.viewModel?.commandToRunInLoopIndex += 1
			    self.viewModel?.isTimeInProgress = true
			self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector:(#selector(updateTimerforStartCar)), userInfo: nil, repeats: true)
		case .startClimateControls:
			FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.instructionsStep2Started, parameters: nil)
			self.updateBodyContentView(batteryHealthInstruction: .testInProgresInitial)
			updateViewWithRCValues()
			//self.viewModel?.isLoopingTimeInProgress = true
			//self.viewModel?.commandToRunInLoopIndex += 1
			self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector:(#selector(updateTimerforStartClimateControls)), userInfo: nil, repeats: true)
		case .testInProgresInitial:
			self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector:(#selector(updateTimerforTestInProgressInitial)), userInfo: nil, repeats: true)
		case .turnOffClimateControls:
			FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.instructionsStep3Started, parameters: nil)
			self.updateBodyContentView(batteryHealthInstruction: .testInprogressFinal)
			//self.viewModel?.isLoopingTimeInProgress = true
			//self.viewModel?.commandToRunInLoopIndex += 1
			self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector:(#selector(updateTimerforTurnOffClimateControls)), userInfo: nil, repeats: true)
		case .testInprogressFinal:
			updateViewWithRCValues()
			self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector:(#selector(updateTimerforTestInProgressFinal)), userInfo: nil, repeats: true)
		}
		
		circleView.progressAnimation(duration: TimeInterval(secoonds ))
	}
	
	func updateBodyContentView(batteryHealthInstruction: BatteryHealthInstruction)  {
		switch batteryHealthInstruction {
			
		case .startTheCar:
			bodyTitleLabel.text = batteryHealthInstruction.title
			firstViewTitle.text = batteryHealthInstruction.bodyTitle
			firstViewSubtitle.text =  batteryHealthInstruction.bodySubtitle
			firstViewTitle.font = UIFont(name: "Arial", size: 14)
			firstViewSubtitle.textColor = .red
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
			bodyContentHeightConstrants.constant = 160
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
	
	func fetchRemoteConfig() {
		//FIXME remove this before we go in production
	//	let debugSettings = FIRRemoteConfigSettings(developerModeEnabled: true)
		//RemoteConfig.remoteConfig().configSettings =
		RemoteConfig.remoteConfig().fetch(withExpirationDuration: 0) { (status, error) in
			guard error == nil else {
				print("Got an error fetching remote values: \(String(describing: error))")
				self.setDefaultRemoteConfigDefaults()
				self.updateViewWithRCValues()
//				let alertViewController = UIAlertController.init(title: "Oops!", message: "Please check your network connection", preferredStyle: .alert)
//				let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
////					let url = URL(string: "App-Prefs:root=Privacy&path=Bluetooth") //for bluetooth setting
////								   let app = UIApplication.shared
////								   app.openURL(url!)
//				})
//				alertViewController.addAction(ok)
//				self.present(alertViewController, animated: true, completion: nil)
				return
			}
			RemoteConfig.remoteConfig().fetchAndActivate()
			self.updateViewWithRCValues()
		}
	}
	
	func updateViewWithRCValues() {
		var timerValue: NSNumber?
		switch batteryHealthInstruction {
		case .startTheCar:
			//timerValue = 5000
			timerValue = RemoteConfig.remoteConfig().configValue(forKey: "firstStepTimeInMs").numberValue
		case .startClimateControls:
			 //timerValue = 10000
			timerValue = RemoteConfig.remoteConfig().configValue(forKey: "secondStepTimeInMs").numberValue
			self.view.layoutSubviews()
		case .testInProgresInitial:
			 //timerValue = 15000
			timerValue = RemoteConfig.remoteConfig().configValue(forKey: "firstStepTimeInMs").numberValue
			self.view.layoutSubviews()
		case .turnOffClimateControls:
			// timerValue = 10000
			timerValue = RemoteConfig.remoteConfig().configValue(forKey: "firstStepTimeInMs").numberValue
		case .testInprogressFinal:
			self.updateBodyContentView(batteryHealthInstruction: .testInprogressFinal)
			//timerValue = 5000
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
			//self.circleView.changeProgresslayerStockeColor(progress: UIColor.warningColor(), circle: .white)

		} else {
			self.secoonds -= 1
			DispatchQueue.main.async  {
				self.timeLabel.text = self.timeString(time: TimeInterval(self.secoonds ?? 0)) //This will update the label.
			}
		
		}
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
				self.timeLabel.text = self.timeString(time: TimeInterval(self.secoonds ?? 0)) //This will update the label.
			}
		
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
	}
	
	@objc func updateTimerforTurnOffClimateControls() {
		if self.secoonds == 0  {
			timer?.invalidate()
			self.startButton.isUserInteractionEnabled = true
			//self.viewModel?.isLoopingTimeInProgress = false
			self.viewModel?.isTimeInProgress = false
//			self.updateBodyContentView(batteryHealthInstruction: .testInprogressFinal)
			self.batteryHealthInstruction = .testInprogressFinal
		} else {
			self.secoonds -= 1
			DispatchQueue.main.async  {
				self.timeLabel.text = self.timeString(time: TimeInterval(self.secoonds )) //This will update the label.
			}
		
		}
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
	}

	
}
extension BatteryHealthCheckViewController: GetPreSignedUrlDelegate, UploadAndSubmitDataDelegate {
	@objc func navigateToHealthScoreVC() {
		self.notificationCenter.post(name: NSNotification.Name(rawValue: "GotAllData"), object: nil)
		//post(name: "GotAllData", object: nil)
   }
   
   func navigateToAnimationVC() {
	   timer?.invalidate()
	   timer = nil
	   
	   //let vm = UploadAnimationViewModel(delegate: self.viewModel?.uploadAndSubmitDelegate)
	   let vc = UploadAnimationViewController()
	   vc.vehicleInfo = viewModel?.vehicleInfo
	   if let sp = viewModel?.sampledCommandsList {
		   vc.sampledCommandsList = sp
	   }
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
	   if let batteryInstrucId = viewModel?.batteryTestInstructionId {
		   vc.testInstructionsId = batteryInstrucId
	   }
	   let dialogMessage = UIAlertController(title: "TURN OFF THE CAR", message: "Turn off the car and disconnect the OBD-II cable.", preferredStyle: .alert)
	   // Create OK button with action handler
	   let ok = UIAlertAction(title: "Done", style: .default, handler: { (action) -> Void in
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
	
}
