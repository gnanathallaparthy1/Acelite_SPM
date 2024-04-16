//
//  AccessoryDetectionTableTableViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 2/27/24.
//

import UIKit
import ExternalAccessory

class AccessoryDetectionTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var offlineViewConstraint: NSLayoutConstraint!
	@IBOutlet weak var offlineView: UIView!
	
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var assessoryTableView: UITableView!

	var networkStatus = NotificationCenter.default
	let natificationName = NSNotification.Name(rawValue:"InternetObserver")
	var selectedDeviceName: String = ""
	var viewModel = AccessoryDetectionViewModel()
	override func viewDidLoad() {
		super.viewDidLoad()
		offlineViewConstraint.constant = 0
		offlineView.isHidden = true
		addCustomView()
		self.navigationItem.hidesBackButton = true
		self.navigationController?.setStatusBar(backgroundColor: UIColor.appPrimaryColor())
		self.navigationController?.navigationBar.setNeedsLayout()
		let menuBarButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.menuButtonAction(_ :)))
		menuBarButton.tintColor = UIColor.appPrimaryColor()
		self.navigationItem.leftBarButtonItem  = menuBarButton
		backButton.layer.cornerRadius = 8
		
		assessoryTableView.register(UINib(nibName: "BluetoohClassicTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
		assessoryTableView.delegate = self
		assessoryTableView.dataSource = self
		
		let nc = NotificationCenter.default
		nc.addObserver(self, selector: #selector(verifyBluetoohClassicStatus), name: UIApplication.willEnterForegroundNotification, object: nil)
		assessoryTableView.reloadData()
		
	}

	@IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
		sender.target = revealViewController()
		sender.action = #selector(revealViewController()?.revealSideMenu)
	}
	
	
	@IBAction func navigateToSettingsScreen(_ sender: UIButton) {
		print("Navigate to settings Screen")
		
		DispatchQueue.main.async {
			UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
		}

	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NotificationCenter.default.addObserver(self, selector: #selector(accessoryDidConnect), name: NSNotification.Name.EAAccessoryDidConnect, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(accessoryDidDisconnect), name: NSNotification.Name.EAAccessoryDidDisconnect, object: nil)
		EAAccessoryManager.shared().registerForLocalNotifications()
		verifyBluetoohClassicStatus()
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
	
	@objc func verifyBluetoohClassicStatus() {
		
		self.viewModel.accessoryList?.removeAll()
		self.viewModel.accessoryList = EAAccessoryManager.shared().connectedAccessories
		if self.viewModel.accessoryList?.count == 0 {
			print("device disconnected")
			DispatchQueue.main.async {
				let viewModel = OfflineViewModel(submitApiResponse: SubmitApiResponse.BLUETOOTH_CLASSIC)
				let storyBaord = UIStoryboard.init(name: "BatteryHealthCheck", bundle: nil)
				let vc = storyBaord.instantiateViewController(withIdentifier: "OfflineViewController") as! OfflineViewController
				vc.viewModel = viewModel
				vc.modalPresentationStyle = .overFullScreen
				self.present(vc, animated: true)
				self.viewModel.accessoryList?.removeAll()
				self.assessoryTableView.reloadData()
			}
		
		} else {
			assessoryTableView.reloadData()
		}
	}
	
	@IBAction func backButtonAction(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
	}
	
	private func showAndHideOffline(isShowOfflineView: Bool) {
		if isShowOfflineView  {
			offlineViewConstraint.constant = 60
			offlineView.layer.cornerRadius = 8
			offlineView.layer.borderColor = UIColor.offlineViewBorderColor().cgColor
			offlineView.layer.borderWidth = 4
			offlineView.isHidden = false
		} else {
			offlineViewConstraint.constant = 0
			offlineView.isHidden = true
		}
	}
	
	// MARK: - EAAccessoryNotification Handlers
	
	@objc func accessoryDidConnect(notificaton: NSNotification) {
	}
	
	
	@objc func accessoryDidDisconnect(notification: NSNotification) {

	}
	
	

	// MARK: - Table view data source
	
	 func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}

	
	 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		 viewModel.finalFilterArray = self.viewModel.accessoryList?.filter({ $0.name.contains(selectedDeviceName)})
		 if Int(viewModel.finalFilterArray?.count ?? 0) > 0 {
			 return viewModel.finalFilterArray?.count ?? 0
		 } else {
			 return 1
		 }
	}
	
	
	  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	 let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? BluetoohClassicTableViewCell
	 
		  if viewModel.finalFilterArray?.count == 0 {
			  cell?.accessoryName.text = "Selected device is not connected"
			  cell?.accessoryName.textAlignment = .center
			  cell?.disclosureButton.isHidden = true
			  return cell ?? UITableViewCell()
		  } else {
			  // Configure the cell...
			  var accessoryName = self.viewModel.finalFilterArray?[indexPath.row].name
			  if accessoryName == nil  || accessoryName == "" {
				  accessoryName = "Unknown Accessory"
			  }
			  
			  cell?.accessoryName.text = accessoryName
			  cell?.disclosureButton.addTarget(self, action: #selector(self.navigateToVehicalVinScannerVC(_ :)), for: .touchUpInside)
			  cell?.disclosureButton.isHidden = false
			  cell?.disclosureButton.tag = indexPath.row
			  let tap = UITapGestureRecognizer(target: self, action: #selector(self.navigateToVehicalVinScannerVC(_ :)))
			  cell?.tag = indexPath.row
			  cell?.addGestureRecognizer(tap)
			  return cell ?? UITableViewCell()
		  }
	 }
	
	
	@IBAction func navigateToVehicalVinScannerVC(_ sender: UIButton) {
		if let accessoryList = viewModel.finalFilterArray {
			self.viewModel.selectedName = accessoryList[sender.tag].name
			self.viewModel.setSelectedAccessory(accessory: accessoryList[sender.tag])
			self.viewModel.sessionController?.setupController(forAccessory: self.viewModel.getSelectedAccessory(), withProtocolString: (self.viewModel.getSelectedAccessoryProtocolString()))
			DispatchQueue.main.async {
				BluetoothClassicSharedInstance.sharedInstance.setSessionController(sessionController:  self.viewModel.getSessionController())
				BluetoothClassicSharedInstance.sharedInstance.setAccessoryValue(accessory:  self.viewModel.getSelectedAccessory())
				BluetoothClassicSharedInstance.sharedInstance.setProtocolStringName(protocolStringName: self.viewModel.getSelectedAccessoryProtocolString())
				
				let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
				let vm = VehicleVinScannerViewModel()
				let vehicleVinScan = storyboard.instantiateViewController(withIdentifier: "VehicalVINScannerViewController") as! VehicalVINScannerViewController
				vehicleVinScan.viewModel = vm
				self.navigationController?.pushViewController(vehicleVinScan, animated: true)
			}
		} else {
			print(Date(), "Accessory Not available", to: &Log.log)
		}
	}
	
	 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		 if let accessory = self.viewModel.finalFilterArray?[indexPath.row] {
			 self.viewModel.setSelectedAccessory(accessory: accessory)
	
			 self.viewModel.sessionController?.setupController(forAccessory: self.viewModel.getSelectedAccessory(), withProtocolString: (self.viewModel.getSelectedAccessoryProtocolString()))
			 DispatchQueue.main.async {
				 BluetoothClassicSharedInstance.sharedInstance.setSessionController(sessionController:  self.viewModel.getSessionController())
				 BluetoothClassicSharedInstance.sharedInstance.setAccessoryValue(accessory: accessory)
				
				 let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
				 let vm = VehicleVinScannerViewModel()
				 let vehicleVinScan = storyboard.instantiateViewController(withIdentifier: "VehicalVINScannerViewController") as! VehicalVINScannerViewController
				 vehicleVinScan.viewModel = vm
				 self.navigationController?.pushViewController(vehicleVinScan, animated: true)
			 }
			
		 }
	}

}

