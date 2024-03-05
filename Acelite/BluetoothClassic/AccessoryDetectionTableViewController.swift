//
//  AccessoryDetectionTableTableViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 2/27/24.
//

import UIKit
import ExternalAccessory

class AccessoryDetectionTableViewController: UITableViewController {
	
	var sessionController:              SessionController!
	var accessoryList:                  [EAAccessory]?
	var selectedAccessory:              EAAccessory?
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false

		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem()
	}

	override func viewWillAppear(_ animated: Bool) {
		
		NotificationCenter.default.addObserver(self, selector: #selector(accessoryDidConnect), name: NSNotification.Name.EAAccessoryDidConnect, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(accessoryDidDisconnect), name: NSNotification.Name.EAAccessoryDidDisconnect, object: nil)
		EAAccessoryManager.shared().registerForLocalNotifications()
		
		sessionController = SessionController.sharedController
		accessoryList = EAAccessoryManager.shared().connectedAccessories
		
		super.viewWillAppear(animated)
	}
	
	
	
	
	
	// MARK: - EAAccessoryNotification Handlers
	
	@objc func accessoryDidConnect(notificaton: NSNotification) {
		
		let connectedAccessory =        notificaton.userInfo![EAAccessoryKey]
		accessoryList?.append(connectedAccessory as! EAAccessory)
		let indexPath =                 IndexPath(row: (accessoryList?.count)! - 1 , section: 0)
		tableView.insertRows(at: [indexPath], with: .automatic)
	}
	
	
	@objc func accessoryDidDisconnect(notification: NSNotification) {
		
//		let disconnectedAccessory =             notification.userInfo![EAAccessoryKey]
//		var disconnectedAccessoryIndex =        0
//		for accessory in accessoryList! {
//			if (disconnectedAccessory as! EAAccessory).connectionID == accessory.connectionID {
//				break
//			}
//			disconnectedAccessoryIndex += 1
//		}
//		
//		if disconnectedAccessoryIndex < (accessoryList?.count)! {
//			accessoryList?.remove(at: disconnectedAccessoryIndex)
//			let indexPath = IndexPath(row: disconnectedAccessoryIndex, section: 0)
//			tableView.deleteRows(at: [indexPath], with: .right)
//		} else {
//			print("Could not find disconnected accessories in list")
//		}
	}
	
	

	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}

	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return (accessoryList?.count)!
	}
	
	
	 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	 let cell = tableView.dequeueReusableCell(withIdentifier: "AccessoryCell", for: indexPath)
	 
	 // Configure the cell...
		var accessoryName = accessoryList?[indexPath.row].name
		if accessoryName == nil  || accessoryName == "" {
			accessoryName = "Unknown Accessory"
		}
		
		cell.textLabel?.text = accessoryName
	 
	 return cell
	 }
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		selectedAccessory = accessoryList?[indexPath.row]
		sessionController.setupController(forAccessory: selectedAccessory!, withProtocolString: (selectedAccessory?.protocolStrings[0])!)
		let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
		let vm = VehicleVinScannerViewModel()
		let vehicleVinScan = storyboard.instantiateViewController(withIdentifier: "VehicalVINScannerViewController") as! VehicalVINScannerViewController
		vehicleVinScan.viewModel = vm
		vehicleVinScan.selectedAccessory = selectedAccessory
		vehicleVinScan.sessionController = sessionController
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.sessionController = self.sessionController
		appDelegate.selectedAccessory = self.selectedAccessory
		self.navigationController?.pushViewController(vehicleVinScan, animated: true)
	}

}
