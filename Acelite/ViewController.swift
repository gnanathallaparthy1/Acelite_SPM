//
//  ViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 12/21/22.
//

import UIKit
import ExternalAccessory
import UserNotifications
enum ScreenState {
case ConnectOBDdevice
}

extension ViewController: EAAccessoryDelegate {
	
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
		print("Connected/Disconnected notification centers")
		print(AceliteExternalAccessory.accessoryManager.connectedAccessories)
		EAAccessoryManager.shared().registerForLocalNotifications()
		
		// Remote Notification
		NotificationCenter.default.addObserver(self, selector: #selector(self.goToVc(notification:)), name:NSNotification.Name(rawValue:"identifier"), object: nil)
		
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
			let session = EASession(accessory: accessory, forProtocol: "com.acelite.protocol")
			if let inputStream = session?.inputStream, let outputStream = session?.outputStream {
				// Open the input and output streams and start communication
				inputStream.open()
				outputStream.open()
				// Handle communication with the accessory
			}
		}
	}
	
	
	@objc func accessoryDisconnected(notification: NSNotification) {
		print("disconnected notification called")
		if let accessory = notification.userInfo?[EAAccessoryKey] as? EAAccessory {
			// Accessory disconnected, handle it
		}
	}
	func showBluetoothAccessoryPicker(
		withNameFilter predicate: NSPredicate?,
		completion: EABluetoothAccessoryPickerCompletion? = nil
	) {
		print(predicate)
	}
	
	@IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
		sender.target = revealViewController()
		sender.action = #selector(revealViewController()?.revealSideMenu)
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
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
		
		let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
		let vehicalVC = storyBoard.instantiateViewController(withIdentifier: "ScanBleDevicesViewController") as! ScanBleDevicesViewController
		self.navigationController?.pushViewController(vehicalVC, animated: false)
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
