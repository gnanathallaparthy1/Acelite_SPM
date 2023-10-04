//
//  BaseViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 8/14/23.
//

import UIKit

enum ScreenType {
	case ViewController
	case ScanBle
	case VinScan
	case VehicalInformation
	case WorkOrder
	case TestInstructions
	case Upload
	case TestableModels
	
	var title: String {
		get {
			switch self {
			case .ViewController:
				return ClassNames.obdiConnect
			case .ScanBle:
				return ClassNames.bluetoothScan
			case .VinScan:
				return ClassNames.enterVin
			case .VehicalInformation:
				return ClassNames.vehicleInformation
			case .WorkOrder:
				return ClassNames.workOrder
			case .TestInstructions:
				return ClassNames.testInstructions
			case .Upload:
				return ClassNames.upload
			case .TestableModels:
				return ClassNames.testableModels
			}
		}
	}
}

protocol OffileDelegate: AnyObject {
	func internetStatus(status: Bool)
}


class BaseViewController: UIViewController, OffileViewDelegate {
	private let notificationCenter = NotificationCenter.default
	let network = NetworkManager.sharedInstance
	var isNetworkAvailable: Bool = false
	var baseDelegate: OffileDelegate?
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if  NetworkManager.sharedInstance.reachability.connection == .unavailable {
			self.networkStatusObserver(isConnected: true)
			isNetworkAvailable = false
			self.baseDelegate?.internetStatus(status: true)
			//self.showOfflinePage()
		}
		//else {
			//status update
			NetworkManager.sharedInstance.reachability.whenUnreachable = { reachability in
				//self.showOfflinePage()
				self.isNetworkAvailable = false
				self.baseDelegate?.internetStatus(status: true)
				self.networkStatusObserver(isConnected: true)
			}
		//}
		notificationCenter.addObserver(self, selector: #selector(self.networkResponse(_:)), name: NSNotification.Name.init(rawValue: "Network"), object: nil)
	
	}
	
	//MARK: - Receive User Details
	@objc func networkResponse(_ notification: Notification) {
		
		let notificationobject = notification.object as? [String: Any] ?? [:]
		guard let commandResponse: String = notificationobject["Network"] as? String, commandResponse.count > 0 else {
			return
		}
		if commandResponse.contains("unavailable") {
			self.isNetworkAvailable = false
			self.baseDelegate?.internetStatus(status: true)
			networkStatusObserver(isConnected: true)
			if let vc = self.navigationController?.topViewController {
				let vcName = NSStringFromClass(vc.classForCoder)
				// To drop the module name from the string
				let splitName = vcName.split(separator: ".")
				if splitName.count > 1 {
					let vcName: String = String(splitName[1])
					//Create Constanys for View Controllers
					switch vcName {
					case "ViewController":
						FirebaseLogging.instance.logEvent(eventName:BluetoothScreenEvents.networkDropped, parameters: ["ScreenName": ScreenType.ViewController.title])
					case "ScanBleDevicesViewController":
						FirebaseLogging.instance.logEvent(eventName:BluetoothScreenEvents.networkDropped, parameters: ["ScreenName": ScreenType.ScanBle.title])
					case "VehicalVINScannerViewController":
						FirebaseLogging.instance.logEvent(eventName:BluetoothScreenEvents.networkDropped, parameters: ["ScreenName": ScreenType.VinScan.title])
					case "VehicalInformationViewController":
						FirebaseLogging.instance.logEvent(eventName:BluetoothScreenEvents.networkDropped, parameters: ["ScreenName": ScreenType.VehicalInformation.title])
					case "WorkOrderViewController":
						FirebaseLogging.instance.logEvent(eventName:BluetoothScreenEvents.networkDropped, parameters: ["ScreenName": ScreenType.WorkOrder.title])
					case "BatteryHealthCheckViewController":
						FirebaseLogging.instance.logEvent(eventName:BluetoothScreenEvents.networkDropped, parameters: ["ScreenName": ScreenType.TestInstructions.title])
					case "UploadAnimationViewController":
						FirebaseLogging.instance.logEvent(eventName:BluetoothScreenEvents.networkDropped, parameters: ["ScreenName": ScreenType.Upload.title])
					case "TestableModelsViewController":
						FirebaseLogging.instance.logEvent(eventName:BluetoothScreenEvents.networkDropped, parameters: ["ScreenName": ScreenType.TestableModels.title])
					default:
						FirebaseLogging.instance.logEvent(eventName:BluetoothScreenEvents.networkDropped, parameters: ["ScreenName": vcName])
					}
					//notificationCenter.removeObserver(self)
				}
				
			}
		} else {
			self.isNetworkAvailable = true
			//self.dismiss(animated: true)
			self.baseDelegate?.internetStatus(status: false)
			networkStatusObserver(isConnected: false)
		}
		print("network reponse", commandResponse)
	}
	
	func networkStatusObserver(isConnected: Bool) {
		NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "InternetObserver"), object: ["isConected": isConnected], userInfo: nil)
	}
	
	func showOfflinePage() -> Void {
		 DispatchQueue.main.async {
//			 let storyBaord = UIStoryboard.init(name: "BatteryHealthCheck", bundle: nil)
//			 let vc = storyBaord.instantiateViewController(withIdentifier: "OfflineViewController") as! OfflineViewController
//			 vc.delegate = self
//			 vc.modalPresentationStyle = .overFullScreen
//			 self.present(vc, animated: true)
		 }
	 }

	func navigateToRootView() {
		if let pheriPheral = Network.shared.myPeripheral {
			Network.shared.bluetoothService?.disconnectDevice(peripheral: pheriPheral)
		}
		self.navigationController?.popToRootViewController(animated: false)
	}
	
	deinit {
		notificationCenter.removeObserver(self)
	}
	
}
