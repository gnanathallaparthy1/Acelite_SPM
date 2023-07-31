//
//  ScanBleDevicesViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 12/29/22.
//

import UIKit
import CoreBluetooth




class ScanBleDevicesViewController: UIViewController {

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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		FirebaseLogging.instance.logScreen(screenName: ClassNames.bluetoothScan)
		uiUpdates()
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
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationItem.setHidesBackButton(true, animated:true)
		let menuBarButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.menuButtonAction(_ :)))
		menuBarButton.tintColor = UIColor.appPrimaryColor()
		self.navigationItem.leftBarButtonItem  = menuBarButton
		
		let terminalBarButtonItem = UIBarButtonItem(title: "Terminal", style: .done, target: self, action: #selector(navigateToTerminal))
		terminalBarButtonItem.tintColor = UIColor.appPrimaryColor()
		self.navigationItem.rightBarButtonItem  = terminalBarButtonItem
		
#if DEV
		
		print("Dev")
#else
		print("Prod")
#endif
		
		
	}
	
	@objc func navigateToTerminal(){
		if self.bleServices?.rxCharacteristic?.uuid.uuidString != nil {
			let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
			let vehicalVC = storyBoard.instantiateViewController(withIdentifier: "TerminalViewController") as! TerminalViewController
			vehicalVC.bluetoothService(bleServices: self.bleServices ?? BluetoothServices())
			self.navigationController?.pushViewController(vehicalVC, animated: false)
		} else {
			var dialogMessage = UIAlertController(title: "Alert", message: "Please scan and connect to BLE device", preferredStyle: .alert)
			
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
				var dialogMessage = UIAlertController(title: "Alert", message: "Please try agian!", preferredStyle: .alert)
				
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
			//print(devices.first)
			if self.blePeripheralDevice.count == 0 {
				FirebaseLogging.instance.logEvent(eventName:BluetoothScreenEvents.bleConnectionFailure, parameters: nil)
				self.bleServices?.isPeripheralIdentified = true
			} else {
				FirebaseLogging.instance.logEvent(eventName:BluetoothScreenEvents.bleConnectionSuccess, parameters: nil)
				self.bleServices?.isPeripheralIdentified = false
			}
		}
		Network.shared.bluetoothService = self.bleServices
//		if bleServices.myPeripheral.state == .connected {
//			print("Connected::::::::::::::::")
//		} else {
//			print("Not Connected::::::::::::::::")
//		}
//		centralManager = CBCentralManager(delegate: self, queue: nil)
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
		//cell?.bleAddress.text = "\(deviceModel.peripheral.identifier)"
		cell?.connectButton.tag = indexPath.row
		
		
		
		
		cell?.connectButton.setTitle("Connect", for: .normal)
		cell?.testButton.isHidden = true
		
//		if  self.selectedIndex == indexPath {
//			if cell?.connectButton.titleLabel?.text == "Disconnected" {
//				cell?.connectButton.setTitle("Connect", for: .normal)
//				cell?.testButton.isHidden = false
//			} else {
//				cell?.connectButton.setTitle("Disconnected", for: .normal)
//				cell?.testButton.isHidden = true
//			}
//			//cell?.connectButton.setTitle("Disconnected", for: .normal)
//			cell?.testButton.isHidden = false
//			cell?.testButton.addTarget(self, action: #selector(self.testbuttonAction(_ :)), for: .touchUpInside)
//		} else {
//			cell?.connectButton.setTitle("Connect", for: .normal)
//			cell?.testButton.isHidden = true
//		}
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
		//self.bleTableView.reloadData()
		let cell = bleTableView.cellForRow(at: self.selectedIndex ?? IndexPath()) as! BLETableViewCell
		//print(cell.connectButton?.titleLabel?.text)
		
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
		
		//self.bleTableView.reloadRows(at: [self.selectedIndex ?? IndexPath()], with: .none)
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
		//let testVC = storyboard.instantiateViewController(withIdentifier: "TerminalViewController") as! TerminalViewController
		//testVC.bluetoothService(bleServices: self.bleServices)
		
//		let viVC = storyboard.instantiateViewController(withIdentifier: "VehicalInformationViewController") as! VehicalInformationViewController
//		let vm = VehicleInformationViewModel(vinNumber: "")
////		 viVC = VehicalInformationViewController(viewModel: vm)
//		viVC.viewModel = vm
//		//viVC.delegate =
//		self.navigationController?.pushViewController(viVC, animated: true)
		let vm = VehicleVinScannerViewModel()
	////		 viVC = VehicalInformationViewController(viewModel: vm)
		let vehicleVinScan = storyboard.instantiateViewController(withIdentifier: "VehicalVINScannerViewController") as! VehicalVINScannerViewController
		//vehicleVinScan.vehicleInfo = viewModel?.vehicleInformation
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
			
			
//			let url = URL(string: "App-Prefs:root=Privacy&path=Bluetooth") //for bluetooth setting
//			   let app = UIApplication.shared
//			   app.openURL(url!)
		}))
		self.present(alert, animated: true, completion: nil)
	}
	
	
}

//extension ScanBleDevicesViewController:  CBPeripheralDelegate, CBCentralManagerDelegate {
//
//	func centralManagerDidUpdateState(_ central: CBCentralManager) {
//		if central.state == .poweredOn {
//			central.scanForPeripherals(withServices: nil, options: nil)
//			print("Scanning...")
//		}
//
//
//		if central.state == CBManagerState.poweredOn {
//			print("BLE powered on")
//
//			// Turned on
//			central.scanForPeripherals(withServices: nil, options: nil)
//
//		}
//		else {
//			print("Something wrong with BLE")
//			// Not on, but can have different issues
//		}
//	}
//
//	func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//		print(peripheral)
//		print(advertisementData)
//
//		if let pname = peripheral.name {
//			let deviceModel = DeviceModel(id: pname, peripheral: peripheral)
//			self.blePeripheralDevice.append(deviceModel)
//			filterPeripharalNames()
//		}
//	}
//
//	func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//		if let peripheral = self.myPeripheral {
//		print("Connected peripheral::::::", peripheral.name ?? "")
//		self.myPeripheral.discoverServices(nil)
//		}
//
//		if self.myPeripheral.state == .connected {
//			DispatchQueue.main.async {
//				let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//				let viVC = storyboard.instantiateViewController(withIdentifier: "VehicalInformationViewController") as! VehicalInformationViewController
//				self.navigationController?.pushViewController(viVC, animated: true)
//			}
//		}
//	}
//
//	func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//		//print("Disconver services", peripheral.services)
//	}
//
//	func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//		//print("characterstics", service.characteristics)
//	}
//
//	func filterPeripharalNames()  {
//		var alreadyThere = Set<DeviceModel>()
//		let uniquePosts = blePeripheralDevice.compactMap { (post) -> DeviceModel? in
//			guard !alreadyThere.contains(post) else { return nil }
//			alreadyThere.insert(post)
//			return post
//		}
//		self.blePeripheralDevice.removeAll()
//		self.blePeripheralDevice = uniquePosts
//		self.bleTableView.reloadData()
//
//	}
//}


struct DeviceModel: Hashable, Identifiable {
	let id: String
	var peripheral: CBPeripheral
}

func ==(left:DeviceModel, right:DeviceModel) -> Bool {
	return left.id == right.id
}
