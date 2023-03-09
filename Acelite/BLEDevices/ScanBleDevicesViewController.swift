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
	var bleServices: BluetoothServices!
	var scanTimer = Timer()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		uiUpdates()
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
		
	}
	
	@objc func showScanTimeoutView()  {
		DispatchQueue.main.async {
			print("20 sec completed")
			
			
			if self.bleServices.isPeripheralIdentified == true {
				
				self.view.activityStopAnimating()
				// Create new Alert
				self.scanTimer.invalidate()
				self.bleServices.isPeripheralIdentified = false
				var dialogMessage = UIAlertController(title: "Alert", message: "Please try agian!", preferredStyle: .alert)
				
				// Create OK button with action handler
				let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
					print("Ok button tapped")
				})
				
				//Add OK button to a dialog message
				dialogMessage.addAction(ok)
				self.scanButton.setTitle("Start Scanning", for: .normal)
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
		if self.scanButton.titleLabel?.text == "Stop Scanning" {
			if let cbManager = self.bleServices.centralManager {
				cbManager.stopScan()
				self.scanButton.setTitle("Start Scanning", for: .normal)
				return
			}
		}
		self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
		DispatchQueue.main.async {
			self.scanTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.showScanTimeoutView), userInfo: nil, repeats: false)
		}
		self.bleServices.callBack = { devices in
			self.blePeripheralDevice.removeAll()
			self.blePeripheralDevice = devices
			self.view.activityStopAnimating()
			self.bleTableView.reloadData()
			//print(devices.first)
			if self.blePeripheralDevice.count == 0 {
				self.bleServices.isPeripheralIdentified = true
			} else {
				self.bleServices.isPeripheralIdentified = false
			}
		}
		Network.shared.bluetoothService = self.bleServices
//		if bleServices.myPeripheral.state == .connected {
//			print("Connected::::::::::::::::")
//		} else {
//			print("Not Connected::::::::::::::::")
//		}
//		centralManager = CBCentralManager(delegate: self, queue: nil)
		if self.scanButton.titleLabel?.text == "Start Scanning" {
		self.scanButton.setTitle("Stop Scanning", for: .normal)
		} else {
			self.scanButton.setTitle("Start Scanning", for: .normal)
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
		if let _ = self.selectedIndex {
			cell?.connectButton.setTitle("Disconnected", for: .normal)
			cell?.testButton.isHidden = false
			cell?.testButton.addTarget(self, action: #selector(self.testbuttonAction(_ :)), for: .touchUpInside)
		} else {
			cell?.connectButton.setTitle("Connect", for: .normal)
			cell?.testButton.isHidden = true
		}
		cell?.connectButton.addTarget(self, action: #selector(self.connectBleDevice(_ :)), for: .touchUpInside)
		return cell ?? UITableViewCell()
	}
	
	@IBAction func connectBleDevice(_ sender: UIButton) {
		let deviceModel = self.blePeripheralDevice[sender.tag]
		self.selectedIndex = IndexPath(row: sender.tag, section: 0)
		bleServices.connectDevices(peripheral: deviceModel.peripheral)
		Network.shared.myPeripheral = deviceModel.peripheral
		self.bleTableView.reloadRows(at: [self.selectedIndex ?? IndexPath()], with: .none)
		
	}
	
	@IBAction func testbuttonAction(_ sender: UIButton) {
		let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
		//let testVC = storyboard.instantiateViewController(withIdentifier: "TerminalViewController") as! TerminalViewController
		//testVC.bluetoothService(bleServices: self.bleServices)
		
		let viVC = storyboard.instantiateViewController(withIdentifier: "VehicalInformationViewController") as! VehicalInformationViewController
		let vm = VehicleInformationViewModel(vinNumber: "3FA6P0SU1KR191846")
//		 viVC = VehicalInformationViewController(viewModel: vm)
		viVC.viewModel = vm
		//viVC.delegate = 
		self.navigationController?.pushViewController(viVC, animated: true)
	}
}

extension ScanBleDevicesViewController:  CBPeripheralDelegate, CBCentralManagerDelegate {
	
	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		if central.state == .poweredOn {
			central.scanForPeripherals(withServices: nil, options: nil)
			print("Scanning...")
		}
		
		
		if central.state == CBManagerState.poweredOn {
			print("BLE powered on")
			
			// Turned on
			central.scanForPeripherals(withServices: nil, options: nil)
			
		}
		else {
			print("Something wrong with BLE")
			// Not on, but can have different issues
		}
	}
	
	func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		print(peripheral)
		print(advertisementData)
		
		if let pname = peripheral.name {
			let deviceModel = DeviceModel(id: pname, peripheral: peripheral)
			self.blePeripheralDevice.append(deviceModel)
			filterPeripharalNames()
		}
	}
	
	func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		if let peripheral = self.myPeripheral {
		print("Connected peripheral::::::", peripheral.name ?? "")
		self.myPeripheral.discoverServices(nil)
		}
		
		if self.myPeripheral.state == .connected {
			DispatchQueue.main.async {
				let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
				let viVC = storyboard.instantiateViewController(withIdentifier: "VehicalInformationViewController") as! VehicalInformationViewController
				self.navigationController?.pushViewController(viVC, animated: true)
			}
		}
	}
	
	func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		//print("Disconver services", peripheral.services)
	}
	
	func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
		//print("characterstics", service.characteristics)
	}
	
	func filterPeripharalNames()  {
		var alreadyThere = Set<DeviceModel>()
		let uniquePosts = blePeripheralDevice.compactMap { (post) -> DeviceModel? in
			guard !alreadyThere.contains(post) else { return nil }
			alreadyThere.insert(post)
			return post
		}
		self.blePeripheralDevice.removeAll()
		self.blePeripheralDevice = uniquePosts
		self.bleTableView.reloadData()

	}
}


struct DeviceModel: Hashable, Identifiable {
	let id: String
	var peripheral: CBPeripheral
}

func ==(left:DeviceModel, right:DeviceModel) -> Bool {
	return left.id == right.id
}
