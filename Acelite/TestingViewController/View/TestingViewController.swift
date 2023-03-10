//
//  TestingViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 1/12/23.
//

import UIKit

class TestingViewController: UIViewController, GetPreSignedUrlDelegate, UploadAndSubmitDataDelegate {
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
		
		self.navigationController?.pushViewController(vc, animated: true)
		//let dialogMessage = UIAlertController(title: "TURN OFF THE CAR", message: "Turn off the car and disconnectthe OBD-II cable", preferredStyle: .alert)
		
		
//		// Create OK button with action handler
//		let ok = UIAlertAction(title: "Done", style: .default, handler: { (action) -> Void in
//			
//			//vc.uploadAndSubmitDelegate = self
//			//pass delegate
//			//vc.uploadAndSubmitDelegate = self.viewModel?.uploadAndSubmitDelegate
//			
//		})
//		
//		//Add OK button to a dialog message
//		dialogMessage.addAction(ok)
//		// Present Alert to
		//self.present(dialogMessage, animated: true, completion: nil)
		}
	
	func getTransactionIdInfo(viewModel: TestingViewModel) {
		
	}
	
	func handleErrorTransactionID() {
		
	}
	
	public var viewModel: TestingViewModel?
	
	init(viewModel: TestingViewModel) {
		super.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
		//super.init()
	}
	required init?(coder: NSCoder) {
		//form = Form()
		super.init(coder: coder)
	}

	@IBOutlet weak var backButton: UIButton! {
		didSet {
			backButton.layer.cornerRadius = 8
		}
	}
	@IBOutlet weak var countLabel: UILabel! {
		didSet {
			countLabel.text = "5/5"
			countLabel.layer.cornerRadius = countLabel.frame.size.width / 2
			countLabel.clipsToBounds = true
		}
	}
	@IBOutlet weak var timeLabel: UILabel!
	var secoonds = 1 * 60
	var timer: Timer?
	
	
	@IBOutlet weak var bleResponseTextView: UITextView!
	var commandResponseString = ""
	var bluetoothService: BluetoothServices?
	private let notificationCenter = NotificationCenter.default
	var delegate:GetPreSignedUrlDelegate?
	var infoPooDelegate: InfoPopAlertViewDelegate? = nil

	
	override func viewDidLoad() {
        super.viewDidLoad()
		//runTimer()
		self.navigationItem.hidesBackButton = true
		self.viewModel?.preSignedDelegate = self
		self.viewModel?.uploadAndSubmitDelegate = self
		self.viewUpdate()
		self.notificationCenter.addObserver(self, selector: #selector(self.commandResponseSuccess(_:)), name: NSNotification.Name.init(rawValue: "BLEResponse"), object: nil)
		
		let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "InfoPopUpViewController") as! InfoPopUpViewController
		vc.modalPresentationStyle = .fullScreen
		vc.delegate = self
		self.present(vc, animated: true)
//		self.notificationCenter.addObserver(self, selector: #selector(self.navigateToHealthScoreVC), name: NSNotification.Name.init(rawValue: "GotAllData"), object: nil)
    }

	private func viewUpdate() {
		bleResponseTextView.delegate = self
		bleResponseTextView.text = ""
		bleResponseTextView.textColor = .white
		bleResponseTextView.backgroundColor = .black
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
		runTimer()
		self.navigationItem.setHidesBackButton(true, animated:true)
		
		let menuBarButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.menuButtonAction(_ :)))
		menuBarButton.tintColor = UIColor.appPrimaryColor()
		self.navigationItem.leftBarButtonItem  = menuBarButton
		
		
		
		let sahreBarButton = UIBarButtonItem(image: UIImage(systemName: "share"), style: .plain, target: self, action: #selector(self.shareTxtFile(_ :)))
		sahreBarButton.tintColor = UIColor.appPrimaryColor()
		self.navigationItem.rightBarButtonItem  = sahreBarButton
		
		
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		timer?.invalidate()
		timer = nil
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		timer?.invalidate()
		timer = nil
	}
	
	func runTimer() {
//		let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
//		 selector: #selector(updateTimer), userInfo: nil, repeats: true) // sets it on `.default` mode
//
//		RunLoop.main.add(timer, forMode: .common)
		//viewModel?.isTimeInProgress = true
//		if let tm = self.timer {
//			self.timer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
//				self?.updateTimer()
//			}
//			RunLoop.current.add(tm, forMode: .common)
//		}
//		self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
//		if let tm = self.timer {
//			RunLoop.main.add(tm, forMode: RunLoop.Mode.tracking)
//		}
		
		//DispatchQueue.main.async  {
//		if let tm = self.timer {
	//	DispatchQueue.main.async  {
		//if let tm = self.timer {
			self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
		//RunLoop.main.add(tm, forMode: RunLoop.Mode.tracking)
		//}
	}
	
	@objc func updateTimer() {
		self.secoonds -= 1
		let bool = self.viewModel?.isTimeInProgress
		//This will decrement(count down)the seconds.
		//
		if self.secoonds == 0 && bool == true  {
			timer?.invalidate()
			self.viewModel?.isTimeInProgress = false
		} else {
			print("::TIME IN SECONDS",self.secoonds)
			DispatchQueue.main.async  {
				self.timeLabel.text = self.timeString(time: TimeInterval(self.secoonds)) //This will update the label.
			}
		//timerLabel.text = timeString(time: TimeInterval(seconds))
		}
	}
	
	func timeString(time:TimeInterval) -> String {
		let hours = Int(time) / 3600
		let minutes = Int(time) / 60 % 60
		let seconds = Int(time) % 60
		
		return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
	}
	
	@IBAction func shareTxtFile(_ sender: UIBarButtonItem) {
//		DispatchQueue.main.async {
//			//let sharedFile = self.viewModel?.saveLogsIntoTxtFile()
//			let url = URL(string: sharedFile ?? "")
//					var filesSharing = [Any]()
//			filesSharing.append(url as Any)
//					let activityViewController = UIActivityViewController(activityItems: filesSharing, applicationActivities: nil)
//			self.present(activityViewController, animated: true)
//		}
		
	}
	
	@IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
		sender.target = revealViewController()
		sender.action = #selector(revealViewController()?.revealSideMenu)
	}
	
	//MARK: - Receive User Details
	@objc func commandResponseSuccess(_ notification: Notification) {
		
		let notificationobject = notification.object as? [String: Any] ?? [:]
		let commandResponse = notificationobject["BLEResponse"]
		print("command Response::::::", commandResponse ?? "")
		guard let commandResponse: String = notificationobject["BLEResponse"] as? String, commandResponse.count > 0 else {
			return
		}
		self.commandResponseString += commandResponse
		self.commandResponseString += "\n"
		updateTextView()
	}
	
	func updateTextView() {
		DispatchQueue.main.async {
		self.bleResponseTextView.text = ""
		self.bleResponseTextView.text = self.commandResponseString
			if self.bleResponseTextView.text.count > 0 {
				let location = self.bleResponseTextView.text.count - 1
				  let bottom = NSMakeRange(location, 1)
				self.bleResponseTextView.scrollRangeToVisible(bottom)
			  }
		}
	}
	
	func bluetoothService(bleServices: BluetoothServices)  {
		self.bluetoothService = bleServices
	}
	
	@IBAction func backButtonAction(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
	}
}

extension TestingViewController: UITextViewDelegate {
	func textViewDidBeginEditing(_ textView: UITextView) {
		textView.resignFirstResponder()
	}
	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		
		textView.resignFirstResponder()
		return true
	}
	func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		textView.resignFirstResponder()
		return true
	}
}
extension TimeInterval {
	var hourMinuteSecondMS: String {
		String(format:"%d:%02d:%02d.%03d", hour, minute, second, millisecond)
	}
	var minuteSecondMS: String {
		String(format:"%d:%02d.%03d", minute, second, millisecond)
	}
	var hour: Int {
		Int((self/3600).truncatingRemainder(dividingBy: 3600))
	}
	var minute: Int {
		Int((self/60).truncatingRemainder(dividingBy: 60))
	}
	var second: Int {
		Int(truncatingRemainder(dividingBy: 60))
	}
	var millisecond: Int {
		Int((self*1000).truncatingRemainder(dividingBy: 1000))
	}
}
extension TestingViewController: InfoPopAlertViewDelegate {
	func removeAlert(sender: InfoPopUpViewController) {
		self.viewModel?.handleInstructions()
		sender.dismiss(animated: true)
	}
	
//	func removeAlert(sender: InfoPopUpViewController) {
//		//sender.dismiss(animated: true)
//		self.viewModel?.handleInstructions()
//
//	}
}
