//
//  TestingViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 1/12/23.
//

import UIKit

class TestingViewController: UIViewController, GetPreSignedUrlDelegate {
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
	var secoonds = 15*1
	var timer = Timer()
	//var isTimerRunning = false
	
	@IBOutlet weak var bleResponseTextView: UITextView!
	var commandResponseString = ""
	var bluetoothService: BluetoothServices?
	private let notificationCenter = NotificationCenter.default
	var delegate:GetPreSignedUrlDelegate?
//	private lazy var alertView: CustomAlertView = {
//		let view = CustomAlertView.instanceFromNib()
//		view.delegate = self
//		view.translatesAutoresizingMaskIntoConstraints = false
//		return view
//	}()
//	private lazy var backgroundView: UIView = {
//		let view = UIView()
//		view.backgroundColor = .black
//		view.alpha = 0.5
//		view.translatesAutoresizingMaskIntoConstraints = false
//		return view
//	}()

	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.viewModel?.preSignedDelegate = self
//		self.view.addSubview(backgroundView)
//		NSLayoutConstraint.activate([
//					backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
//					backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
////					backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
////					backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
////				])
//		self.view.addSubview(alertView)
		self.viewUpdate()
		self.notificationCenter.addObserver(self, selector: #selector(self.commandResponseSuccess(_:)), name: NSNotification.Name.init(rawValue: "BLEResponse"), object: nil)
		
		let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "InfoPopUpViewController") as! InfoPopUpViewController
		vc.modalPresentationStyle = .fullScreen
		self.present(vc, animated: true)
		
		
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
		
		
		
		let sahreBarButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.shareTxtFile(_ :)))
		sahreBarButton.tintColor = UIColor.appPrimaryColor()
		self.navigationItem.rightBarButtonItem  = sahreBarButton
		
		
	}
	
	func runTimer() {
		viewModel?.isTimeInProgress = true
		 timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
	}
	
	@objc func updateTimer() {
		self.secoonds -= 1
		//This will decrement(count down)the seconds.
		if self.secoonds == 0 {
			timer.invalidate()
			self.viewModel?.isTimeInProgress = false
		} else {
		self.timeLabel.text = timeString(time: TimeInterval(secoonds)) //This will update the label.
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
		DispatchQueue.main.async {
			let sharedFile = self.viewModel?.saveLogsIntoTxtFile()
			let url = URL(string: sharedFile ?? "")
					var filesSharing = [Any]()
			filesSharing.append(url as Any)
					let activityViewController = UIActivityViewController(activityItems: filesSharing, applicationActivities: nil)
			self.present(activityViewController, animated: true)
		}
		
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
extension TestingViewController: CustomAlertViewDelegate {
	func removeAlert(sender: CustomAlertView) {
		sender.removeFromSuperview()
	}
}
