//
//  ViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 12/21/22.
//

import UIKit
import ExternalAccessory
import UserNotifications
import CoreData
import FirebaseDatabase
import Firebase

enum ScreenState {
	case ConnectOBDdevice
}

extension ViewController: EAAccessoryDelegate {
	
}

enum InfoWarning {
	case INFO
	case WARINING
}

class ViewController: BaseViewController {
	
	var accessoryManger: EAAccessoryManager!
	@IBOutlet weak var imageTitleLabel: UILabel!
	var screenState = ScreenState.ConnectOBDdevice
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var screenCountLabel: UILabel! {
		didSet {
			screenCountLabel.layer.cornerRadius = screenCountLabel.frame.size.width / 2
			screenCountLabel.clipsToBounds = true
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
	
	@IBOutlet weak var offlineView: UIView!
	@IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var showOfflineDataMessageView: UIView!
	@IBOutlet weak var offlineMessageViewHeight: NSLayoutConstraint!
	
	var networkStatus = NotificationCenter.default
	let natificationName = NSNotification.Name(rawValue:"InternetObserver")
	var batteryInstructionArray = [[String: Any]]()
	var managedObject = [NSManagedObject]()
	var offlineHrsLimit: Int = 0
	var remoteConfig = RemoteConfig.remoteConfig()
	var interfaceType: DeviceInterfaceType = .BLUETOOTH_CLASSIC
	override func viewDidLoad() {
		super.viewDidLoad()
		accessoryManger = EAAccessoryManager.shared()
		FirebaseLogging.instance.logScreen(screenName: ClassNames.obdiConnect)
		FirebaseLogging.instance.setUserProperty(value: "StarCharm", forProperty: UserProperty().productType)
		
		self.navigationController?.setStatusBar(backgroundColor: UIColor.appPrimaryColor())
		self.navigationController?.navigationBar.setNeedsLayout()
		
		let menuBarButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.menuButtonAction(_ :)))
		menuBarButton.tintColor = UIColor.appPrimaryColor()
		self.navigationItem.leftBarButtonItem  = menuBarButton
		
		nextButton.addTarget(self, action: #selector(self.nextButtonAction(_:)), for: .touchUpInside)
		cancelButton.addTarget(self, action: #selector(self.cancelButtonAction(_:)), for: .touchUpInside)
		uiViewUpdate()
		// External Device
		NotificationCenter.default.addObserver(self, selector: #selector(accessoryConnected), name: NSNotification.Name.EAAccessoryDidConnect, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(accessoryDisconnected), name: NSNotification.Name.EAAccessoryDidDisconnect, object: nil)
		EAAccessoryManager.shared().registerForLocalNotifications()
		
		networkStatus.addObserver(self, selector: #selector(self.showOffileViews(_:)), name: natificationName, object: nil)
		offlineView.isHidden = true
		viewHeightConstraint.constant = 0
		self.addCustomView()
		addOfflineDataMessageCustomView()
		getDatabaseTimeLimit()
	}
	
	private func getDatabaseTimeLimit() {
		
		remoteConfig.fetch(withExpirationDuration: 0) { [unowned self] (status, error) in
			guard error == nil else {print("FBase network fail")
				return
			}
		}
		remoteConfig.activate()
		let number = remoteConfig.configValue(forKey: "json_files_deletion_interval_in_hours").numberValue
		self.offlineHrsLimit = Int(truncating: number)
	}
	
	private func addCustomView() {
		let allViewsInXibArray = Bundle.main.loadNibNamed("CustomView", owner: self, options: nil)
		let view = allViewsInXibArray?.first as! CustomView
		view.frame = self.offlineView.bounds
		view.viewType = .WARINING
		view.arrowButton.isHidden = true
		view.setupView(message: Constants.OFFLINE_MESSAGE)
		self.offlineView.addSubview(view)
	}
	
	private func addOfflineDataMessageCustomView() {
		let allViewsInXibArray = Bundle.main.loadNibNamed("CustomView", owner: self, options: nil)
		let view = allViewsInXibArray?.first as! CustomView
		view.frame = self.offlineView.bounds
		view.viewType = .INFO
		view.setupView(message: Constants.APP_UNSUBMITTED)
		view.arrowButton.addTarget(self, action: #selector(navigateVINOfflineDataViewController(_ :)), for: .touchUpInside)
		self.showOfflineDataMessageView.isHidden = true
		self.offlineMessageViewHeight.constant = 60
		showOfflineDataMessageView.frame.size.height = 60
		self.showOfflineDataMessageView.addSubview(view)
	}
	
	private func getBatteryInstructionData() {
		self.batteryInstructionArray.removeAll()
		self.managedObject.removeAll()
		//As we know that container is set up in the AppDelegates so we need to refer that container.
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
		//We need to create a context from this container
		let managedContext = appDelegate.persistentContainer.viewContext
		//Prepare the request of type NSFetchRequest  for the entity
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.BATTERY_INSTRUCTIONS_DATA)
		do {
			let result = try managedContext.fetch(fetchRequest)
			for data in result as! [NSManagedObject] {
				self.managedObject.append(data)
				var instructionDict = [String: Any]()
				
				let numberOfCell = data.value(forKey: Constants.NUMBER_OF_CELL)
				let bms = data.value(forKey: Constants.BMS)
				let odometer = data.value(forKey: Constants.ODOMETER)
				let stateOfCharge = data.value(forKey: Constants.STATE_OF_CHARGE)
				let currentEnergy = data.value(forKey: Constants.CURRENT_ENERGY)
				
				instructionDict[Constants.CURRENT_ENERGY] = currentEnergy as? Double
				instructionDict[Constants.STATE_OF_CHARGE] = stateOfCharge as? Double
				instructionDict[Constants.ODOMETER] = odometer as? Double
				instructionDict[Constants.BMS] = bms as? Double
				instructionDict[Constants.NUMBER_OF_CELL] = numberOfCell as? Int				
				instructionDict[Constants.DATE_TIME] = data.value(forKey: Constants.DATE_TIME) as? String
				instructionDict[Constants.FINAL_JSON_DATA] = data.value(forKey: Constants.FINAL_JSON_DATA) as? String
				instructionDict[Constants.WORK_ORDER] = data.value(forKey: Constants.WORK_ORDER) as? String
				instructionDict[Constants.VEHICAL] = data.value(forKey: Constants.VEHICAL) as? String
				self.batteryInstructionArray.append(instructionDict)
			}
		} catch {
			print("Failed")
		}

		if self.managedObject.count > 0 {
			self.offlineDataTimeDifference()
		}
		showOfflineDataActionbutton()
	}
	
	@IBAction func navigateVINOfflineDataViewController(_ sender: UIButton) {
		print(Date(), "Navigate to OfflineVINDataVC", to: &Log.log)
		let storyBaord = UIStoryboard.init(name: "Main", bundle: nil)
		let vc = storyBaord.instantiateViewController(withIdentifier: "OfflineVINDataViewController") as! OfflineVINDataViewController
		vc.managedObject = self.managedObject
		vc.batteryInstructionArray = self.batteryInstructionArray
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	@objc func showOffileViews(_ notification: Notification) {
		
		let notificationobject = notification.object as? [String: Any] ?? [:]
		guard let isShowOfflineView: Bool = notificationobject["isConected"] as? Bool else {
			return
		}
		if isShowOfflineView  {
			viewHeightConstraint.constant = 60
			offlineView.layer.cornerRadius = 8
			offlineView.isHidden = false
			FirebaseLogging.instance.logEvent(eventName:OfflineEvents.offlineBannerVisible, parameters: nil)
		} else {
			viewHeightConstraint.constant = 0
			offlineView.isHidden = true
		}
	}
	
	@objc func goToVc(notification:Notification) {
		NotificationCenter.default.removeObserver(self)
		if self.navigationController?.topViewController == self {
			let storyBaord = UIStoryboard.init(name: "BatteryHealthCheck", bundle: nil)
			let vc = storyBaord.instantiateViewController(withIdentifier: "TestableModelsViewController") as! TestableModelsViewController
			vc.isModallyPresented = false
			self.navigationController?.pushViewController(vc, animated: true)
		}
		
	}
	
	@objc func accessoryConnected(notification: NSNotification) {
		print("connected notification called")
		if let accessory = notification.userInfo?[EAAccessoryKey] as? EAAccessory {
			let session = EASession(accessory: accessory, forProtocol: "com.obdlink")
			if let inputStream = session?.inputStream, let outputStream = session?.outputStream {
				// Open the input and output streams and start communication
				inputStream.open()
				outputStream.open()
				// Handle communication with the accessory
			}
		}
	}
		
	@objc func accessoryDisconnected(notification: NSNotification) {
		
		if let _ = notification.userInfo?[EAAccessoryKey] as? EAAccessory {
			// Accessory disconnected, handle it
		}
	}
	
	func showBluetoothAccessoryPicker(
		withNameFilter predicate: NSPredicate?,
		completion: EABluetoothAccessoryPickerCompletion? = nil
	) {
		
	}
	
	@IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
		sender.target = revealViewController()
		sender.action = #selector(revealViewController()?.revealSideMenu)
	}
		
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		// GET offline data
		self.getBatteryInstructionData()
		imageTitleLabel.text = "Connect The OBD-II Device"
		cancelButton.backgroundColor = .lightGray
		cancelButton.isUserInteractionEnabled = false
		cancelButton.isHidden = true
		imageView.image = UIImage.init(named: "1-5")
		screenCountLabel.text = "1/5"
		
		// Remote Nitification
		NotificationCenter.default.addObserver(self, selector: #selector(self.goToVc(notification:)), name:NSNotification.Name(rawValue:"identifier"), object: nil)
	}
	
	private func uiViewUpdate()  {
		nextButton.backgroundColor = UIColor.appPrimaryColor()
		if screenState == .ConnectOBDdevice {
			imageTitleLabel.text = "Connect The OBD-II Device"
			cancelButton.backgroundColor = .lightGray
			cancelButton.isUserInteractionEnabled = false
			cancelButton.isHidden = true
			imageView.image = UIImage.init(named: "1-5")
			screenCountLabel.text = "1/5"
		} else {
			
			let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
			let vehicalVC = storyBoard.instantiateViewController(withIdentifier: "ScanBleDevicesViewController") as! ScanBleDevicesViewController
			self.navigationController?.pushViewController(vehicalVC, animated: false)
		}
		
	}
	
	@IBAction func backButtonAction(_ sender: UIButton) {
		screenState = .ConnectOBDdevice
		uiViewUpdate()
	}
		
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		screenState = .ConnectOBDdevice
		uiViewUpdate()
	}
	
	@IBAction func nextButtonAction(_ sender: UIButton) {
		if interfaceType == .BLEUTOOTH_LOW_ENERGY {
			let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
			let vehicalVC = storyBoard.instantiateViewController(withIdentifier: "ScanBleDevicesViewController") as! ScanBleDevicesViewController
			self.navigationController?.pushViewController(vehicalVC, animated: false)
		} else {
			let storyboard = UIStoryboard.init(name: "BluetoothClassic", bundle: nil)
			let vehicalVC = storyboard.instantiateViewController(withIdentifier: "AccessoryDetectionTableViewController") as! AccessoryDetectionTableViewController
			self.navigationController?.pushViewController(vehicalVC, animated: false)
		}
	}
	
	//MARK: - Logic : Based on time difference condition removed DB data
	private func offlineDataTimeDifference() {
		//for item in self.managedObject {
		print(Date(), "Offline Data: Time difference Calculation", to: &Log.log)
		for (index, item) in self.managedObject.enumerated() {
			let savedDate: String = item.value(forKey: Constants.DATE_TIME) as! String
			let formatter = DateFormatter()
			let calendar = Calendar.current
			formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
			let startDate = formatter.date(from: savedDate)
			let diff = calendar.dateComponents([.hour], from: startDate!, to: Date())
			print("Time Difference",diff)
			guard let totalHrs = diff.hour, totalHrs > self.offlineHrsLimit else {
				return
			}
			print(Date(), "Offline Data: Time difference -> \(totalHrs)", to: &Log.log)
			self.deleteUploadedRecordInCoreData(deletedObject: item)
			self.managedObject.remove(at: index)
		}
		self.showOfflineDataActionbutton()
		
	}
	
	private func showOfflineDataActionbutton() {
		DispatchQueue.main.async(execute: {
			if self.managedObject.count > 0 {
				print("show offline control")
				self.showOfflineDataMessageView.isHidden = false
				self.offlineMessageViewHeight.constant = 60
			} else {
				print("hide offline control")
				self.showOfflineDataMessageView.isHidden = true
				self.offlineMessageViewHeight.constant = 0
			}
		})
	}
	
	
	private func deleteUploadedRecordInCoreData(deletedObject: NSManagedObject) {
		//As we know that container is set up in the AppDelegates so we need to refer that container.
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
		//We need to create a context from this container
		let managedContext = appDelegate.persistentContainer.viewContext
		managedContext.delete(deletedObject)
		print(Date(), "CoreData: Selected ManagedObject is deleted", to: &Log.log)
		appDelegate.saveContext()
		print(Date(), "CoreData: Updated save context", to: &Log.log)
	}
		
}

extension ViewController: UIPopoverPresentationControllerDelegate {
	public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
		return .none
	}
}

extension UINavigationController {
	
	func setStatusBar(backgroundColor: UIColor) {
		let statusBarFrame: CGRect
		if #available(iOS 13.0, *) {
			statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
		} else {
			statusBarFrame = UIApplication.shared.statusBarFrame
		}
		let statusBarView = UIView(frame: statusBarFrame)
		statusBarView.backgroundColor = backgroundColor
		view.addSubview(statusBarView)
	}
	
}
