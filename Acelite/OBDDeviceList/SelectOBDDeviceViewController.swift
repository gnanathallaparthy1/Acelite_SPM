//
//  SelectOBDDeviceViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/12/24.
//

import UIKit

class SelectOBDDeviceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var offlineViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var offlineView: UIView!
	@IBOutlet weak var obdDeviceTableView: UITableView!
	//var obdDeviceArray = ["Starcharm", "OBDLink", "vLinker"]
	//var interfaceType: DeviceInterfaceType = .BLUETOOTH_CLASSIC
	var networkStatus = NotificationCenter.default
	let natificationName = NSNotification.Name(rawValue:"InternetObserver")
	var viewModel: SelectOBDDeviceViewModel?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.hidesBackButton = true
		self.navigationController?.setStatusBar(backgroundColor: UIColor.appPrimaryColor())
		self.navigationController?.navigationBar.setNeedsLayout()
		let menuBarButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.menuButtonAction(_ :)))
		menuBarButton.tintColor = UIColor.appPrimaryColor()
		self.navigationItem.leftBarButtonItem  = menuBarButton
		obdDeviceTableView.register(UINib(nibName: "OBDDeviceTableViewCell", bundle: nil), forCellReuseIdentifier: "DeviceCell")
		obdDeviceTableView.delegate = self
		obdDeviceTableView.dataSource = self
		offlineViewHeightConstraint.constant = 0
		offlineView.isHidden = true
		addCustomView()
        // Do any additional setup after loading the view.
    }
	
	@IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
		sender.target = revealViewController()
		sender.action = #selector(revealViewController()?.revealSideMenu)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	
		if  NetworkManager.sharedInstance.reachability.connection == .unavailable {
			self.showAndHideOffline(isShowOfflineView: true)
		}
		networkStatus.addObserver(self, selector: #selector(self.showOffileViews(_:)), name: natificationName, object: nil)
		
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
	
	@objc func showOffileViews(_ notification: Notification) {
		
		let notificationobject = notification.object as? [String: Any] ?? [:]
		guard let isShowOfflineView: Bool = notificationobject["isConected"] as? Bool else {
			return
		}
		self.showAndHideOffline(isShowOfflineView: isShowOfflineView)
	
	}
	
	private func showAndHideOffline(isShowOfflineView: Bool) {
		if isShowOfflineView  {
			offlineViewHeightConstraint.constant = 60
			offlineView.layer.cornerRadius = 8
			offlineView.layer.borderColor = UIColor.offlineViewBorderColor().cgColor
			offlineView.layer.borderWidth = 4
			offlineView.isHidden = false
		} else {
			offlineViewHeightConstraint.constant = 0
			offlineView.isHidden = true
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel?.obdDeviceArray.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell") as? OBDDeviceTableViewCell
		if let data = self.viewModel {
			cell?.obdDeviceName.text = data.obdDeviceArray[indexPath.row]
			
			cell?.obdDeviceImage.image = UIImage(named: data.obdDeviceArray[indexPath.row])
			
			let tap = UITapGestureRecognizer(target: self, action: #selector(self.navigateToNextViewController(_:)))
			cell?.tag = indexPath.row
			cell?.addGestureRecognizer(tap)
		}
		
		return cell ?? UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
	
	@objc func navigateToNextViewController(_ sender: UITapGestureRecognizer) {

		let indexValue = sender.view?.tag
		switch indexValue {
		case 0:
			//interfaceType = .BLEUTOOTH_LOW_ENERGY
			let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
			let vehicalVC = storyBoard.instantiateViewController(withIdentifier: "ScanBleDevicesViewController") as! ScanBleDevicesViewController
			self.navigationController?.pushViewController(vehicalVC, animated: false)
			break

		case 1, 2:
			//interfaceType = .BLUETOOTH_CLASSIC
			let storyboard = UIStoryboard.init(name: "BluetoothClassic", bundle: nil)
			let vehicalVC = storyboard.instantiateViewController(withIdentifier: "AccessoryDetectionTableViewController") as! AccessoryDetectionTableViewController
			if let potitionIndex = indexValue {
				vehicalVC.selectedDeviceName = self.viewModel?.obdDeviceArray[potitionIndex] ?? ""
				self.navigationController?.pushViewController(vehicalVC, animated: false)
			}
			
			break
		case .some(_):
			break
		case .none:
		    break
		}
		
	}

}
