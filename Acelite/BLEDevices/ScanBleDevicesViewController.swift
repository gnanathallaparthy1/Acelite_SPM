//
//  ScanBleDevicesViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 12/29/22.
//

import UIKit
import CoreBluetooth




class ScanBleDevicesViewController: BaseViewController {

	@IBOutlet weak var offlineView: UIView!
	@IBOutlet weak var offlineViewHeight: NSLayoutConstraint!
	@IBOutlet weak var scanButton: UIButton!
	@IBOutlet weak var bleTableView: UITableView!
	private var bleDevicesArray = [CBPeripheral]()
	private var centralManager: CBCentralManager!
	private var myPeripheral: CBPeripheral!
	private var blePeripheralDevice = [DeviceModel]()
	private var selectedIndex: IndexPath?
	private var selectedRow: Int?
	var bleServices: BluetoothServices?
	var scanTimer = Timer()
	var networkStatus = NotificationCenter.default
	let natificationName = NSNotification.Name(rawValue:"InternetObserver")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		FirebaseLogging.instance.logScreen(screenName: ClassNames.bluetoothScan)
		uiUpdates()
		offlineViewHeight.constant = 0
		offlineView.isHidden = true
		addCustomView()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		scanTimer.invalidate()
	}
	
	private func uiUpdates() {
		bleTableView.delegate = self
		bleTableView.dataSource = self
		bleTableView.register(UINib(nibName: "BLETableViewCell", bundle: nil), forCellReuseIdentifier: "BLECell")
		scanButton.layer.cornerRadius = 10
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
		super.viewWillAppear(animated)
			self.navigationItem.setHidesBackButton(true, animated:true)
			let menuBarButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.menuButtonAction(_ :)))
			menuBarButton.tintColor = UIColor.appPrimaryColor()
			self.navigationItem.leftBarButtonItem  = menuBarButton
			
#if DEV
		let terminalBarButtonItem = UIBarButtonItem(title: "Terminal", style: .done, target: self, action: #selector(navigateToTerminal))
			terminalBarButtonItem.tintColor = UIColor.appPrimaryColor()
			self.navigationItem.rightBarButtonItem  = terminalBarButtonItem
#else
		print("Prod")
#endif
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
	
	@objc func navigateToTerminal(){
		if self.bleServices?.rxCharacteristic?.uuid.uuidString != nil {
			let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
			let vehicalVC = storyBoard.instantiateViewController(withIdentifier: "TerminalViewController") as! TerminalViewController
			vehicalVC.bluetoothService(bleServices: self.bleServices ?? BluetoothServices())
			self.navigationController?.pushViewController(vehicalVC, animated: false)
		} else {
			let dialogMessage = UIAlertController(title: "Alert", message: "Please scan and connect to BLE device", preferredStyle: .alert)
			
			// Create OK button with action handler
			let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
				print("Ok button tapped")
			})
			dialogMessage.addAction(ok)
			self.present(dialogMessage, animated: true, completion: nil)
			
		}
	}
	
	@objc func showScanTimeoutView()  {
		DispatchQueue.main.async {
			if self.blePeripheralDevice.count == 0 {
				
				self.view.activityStopAnimating()
				// Create new Alert
				self.scanTimer.invalidate()
				self.bleServices?.isPeripheralIdentified = false
				let dialogMessage = UIAlertController(title: "Alert", message: "Please try agian!", preferredStyle: .alert)
				
				// Create OK button with action handler
				let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
					print("Ok button tapped")
				})
				
				//Add OK button to a dialog message
				dialogMessage.addAction(ok)
				self.scanButton.setTitle("START SCANNING FOR OBD II DEVICES", for: .normal)
				// Present Alert to
				self.present(dialogMessage, animated: true, completion: nil)
				//}
			}
		}
	}
	
	@IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
		
		sender.target = revealViewController()
		sender.action = #selector(revealViewController()?.revealSideMenu)
	}
	
	
	@IBAction func scanButtonAction(_ sender: UIButton) {
		self.bleServices = BluetoothServices()
		self.bleServices?.delegate = self
		if self.scanButton.titleLabel?.text == "Stop Scanning" {
			if let cbManager = self.bleServices?.centralManager {
				FirebaseLogging.instance.logEvent(eventName:BluetoothScreenEvents.bleScanStop, parameters: nil)
				cbManager.stopScan()
				self.scanButton.setTitle("START SCANNING FOR OBD II DEVICES", for: .normal)
				return
			}
		}
		self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
		DispatchQueue.main.async {
			self.scanTimer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(self.showScanTimeoutView), userInfo: nil, repeats: false)
		}
		self.bleServices?.callBack = { devices in
			self.blePeripheralDevice.removeAll()
			self.blePeripheralDevice = devices
			self.view.activityStopAnimating()
			self.bleTableView.reloadData()
			if self.blePeripheralDevice.count == 0 {
				FirebaseLogging.instance.logEvent(eventName:BluetoothScreenEvents.bleConnectionFailure, parameters: nil)
				self.bleServices?.isPeripheralIdentified = true
			} else {
				FirebaseLogging.instance.logEvent(eventName:BluetoothScreenEvents.bleConnectionSuccess, parameters: nil)
				self.bleServices?.isPeripheralIdentified = false
			}
		}
		Network.shared.bluetoothService = self.bleServices
		if self.scanButton.titleLabel?.text == "START SCANNING FOR OBD II DEVICES" {
		FirebaseLogging.instance.logEvent(eventName:BluetoothScreenEvents.bleScanStart, parameters: nil)
		self.scanButton.setTitle("STOP SCANNING FOR OBD II DEVICES", for: .normal)
		} else {
			self.scanButton.setTitle("START SCANNING FOR OBD II DEVICES", for: .normal)
		}
	}
}

extension ScanBleDevicesViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.blePeripheralDevice.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "BLECell",
												 for: indexPath) as? BLETableViewCell
		let deviceModel = self.blePeripheralDevice[indexPath.row]
		cell?.bleNameLable.text = deviceModel.peripheral.name
		cell?.connectButton.tag = indexPath.row
		cell?.connectButton.setTitle("Connect", for: .normal)
		cell?.testButton.isHidden = true
		cell?.connectButton.addTarget(self, action: #selector(self.connectBleDevice(_ :)), for: .touchUpInside)
		return cell ?? UITableViewCell()
	}
	
	@IBAction func connectBleDevice(_ sender: UIButton) {
		let deviceModel = self.blePeripheralDevice[sender.tag]
		self.selectedRow = sender.tag
		if self.selectedIndex == IndexPath(row: sender.tag, section: 0) {
			self.selectedIndex = IndexPath(row: sender.tag, section: 0)
			bleServices?.disconnectDevice(peripheral: deviceModel.peripheral)
		} else {
			disconnectPreviousConnectedDevices()
			self.selectedIndex = IndexPath(row: sender.tag, section: 0)
			bleServices?.bluetoothPeripheral = deviceModel.peripheral
			bleServices?.connectDevices(peripheral: deviceModel.peripheral)
			Network.shared.myPeripheral = deviceModel.peripheral
		}
		let cell = bleTableView.cellForRow(at: self.selectedIndex ?? IndexPath()) as! BLETableViewCell
		if cell.connectButton?.titleLabel?.text == "Connect" {
			FirebaseLogging.instance.logEvent(eventName:BluetoothScreenEvents.bleConnect, parameters: nil)
			cell.connectButton.setTitle("Disconnect", for: .normal)
			cell.testButton.isHidden = false
			cell.testButton.addTarget(self, action: #selector(self.testbuttonAction(_ :)), for: .touchUpInside)
		} else {
			FirebaseLogging.instance.logEvent(eventName:BluetoothScreenEvents.bleDisconnect, parameters: nil)
			cell.connectButton.setTitle("Connect", for: .normal)
			cell.testButton.isHidden = true
		}
	}
	
	func disconnectPreviousConnectedDevices() {
		guard let previousDevice = Network.shared.myPeripheral  else { return  }
		bleServices?.disconnectDevice(peripheral: previousDevice)
		//TODO update UI state
	}
	
	@IBAction func testbuttonAction(_ sender: UIButton) {
		Network.shared.bluetoothService?.centralManager.stopScan()
		FirebaseLogging.instance.logEvent(eventName:BluetoothScreenEvents.bleTest, parameters: nil)
		let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
		let vm = VehicleVinScannerViewModel()
		let vehicleVinScan = storyboard.instantiateViewController(withIdentifier: "VehicalVINScannerViewController") as! VehicalVINScannerViewController
		vehicleVinScan.viewModel = vm
		self.navigationController?.pushViewController(vehicleVinScan, animated: true)
	}
}

extension ScanBleDevicesViewController: BLEPermissionDelegate {
	func handleBleCommandError() {
		let alert = UIAlertController(title: "Error", message: "Sorry, something went wrong. Please try again. ", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
			guard let viewControllers = self.navigationController?.viewControllers else {
				return
			}
			for workOrderVc in viewControllers {
				if workOrderVc is WorkOrderViewController {
					self.navigationController?.popToViewController(workOrderVc, animated: true)
					break
				}
			}
		}))
		self.present(alert, animated: true, completion: nil)
	}
	
	func blePermissionDelegate() {
		let alert = UIAlertController(title: "Alert", message: "Please enable Bluetooth in the settings.", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Go to -> Settings", style: .default, handler: { action in
			UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
		}))
		self.present(alert, animated: true, completion: nil)
	}
	
}

struct DeviceModel: Hashable, Identifiable {
	let id: String
	var peripheral: CBPeripheral
}

func ==(left:DeviceModel, right:DeviceModel) -> Bool {
	return left.id == right.id
}
