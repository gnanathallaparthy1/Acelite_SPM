//
//  OfflineVINDataViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 04.10.23.
//

import UIKit
import CoreData

class OfflineVINDataViewController: UIViewController {

    @IBOutlet weak var vinOfflineTableView: UITableView!
    @IBOutlet weak var offlineViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var offlineView: UIView!
	var networkStatus = NotificationCenter.default
	let natificationName = NSNotification.Name(rawValue:"InternetObserver")
	var batteryInstructionArray = [[String: Any]]()
	var isShowOfflineView: Bool = false
	var managedObject = [NSManagedObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
		//log
        vinOfflineTableView.delegate = self
        vinOfflineTableView.dataSource = self
        vinOfflineTableView.register(UINib(nibName: "VINDataTableViewCell", bundle: nil), forCellReuseIdentifier: "VINDataCell")
	
    }
	
	override func viewWillAppear(_ animated: Bool) {
		FirebaseLogging.instance.logScreen(screenName: ClassNames.offlineTestList)
		
		
		networkStatus.addObserver(self, selector: #selector(self.showOffileViews(_:)), name: natificationName, object: nil)
		
		navigationItem.backButtonTitle = ""
		navigationController?.navigationBar.tintColor = UIColor.appPrimaryColor()
		offlineView.isHidden = true
		offlineViewHeightConstraint.constant = 0
		addCustomView()
	}
    
	private func addCustomView() {
		let allViewsInXibArray = Bundle.main.loadNibNamed("CustomView", owner: self, options: nil)
		let view = allViewsInXibArray?.first as! CustomView
		view.frame = self.offlineView.bounds
		view.viewType = .WARINING
		view.arrowButton.isHidden = true
		view.setupView(message: Constants.OFFLINE_MESSAGE)
		self.offlineView.addSubview(view)
		displayOfflineView()
	}
	
	@objc func showOffileViews(_ notification: Notification) {
		
		let notificationobject = notification.object as? [String: Any] ?? [:]
		guard let isShowOfflineView = notificationobject["isConected"] as? Bool else {
			return
		}
		self.isShowOfflineView = isShowOfflineView
		self.displayOfflineView()
	}
	private func displayOfflineView() {
		if isShowOfflineView || self.currentReachabilityStatus == .notReachable  {
			offlineViewHeightConstraint.constant = 60
			offlineView.layer.cornerRadius = 8
			offlineView.isHidden = false
			self.isShowOfflineView = true
		} else {
			offlineViewHeightConstraint.constant = 0
			offlineView.isHidden = true
		}
	}

}

extension OfflineVINDataViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return managedObject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VINDataCell") as? VINDataTableViewCell
		let data = managedObject[indexPath.row]
		cell?.loadCellData(data: data)
		cell?.uploadDataButton.tag = indexPath.row
		cell?.uploadDataButton.addTarget(self, action: #selector(navigateToUploadViewController(_ :)), for: .touchUpInside)
        return cell ?? UITableViewCell()
    }
    
	@IBAction func navigateToUploadViewController(_ sender: UIButton) {
		
		// alert - internet
		if self.isShowOfflineView {
			offlineAlertViewController()
		} else {
			let dataObject = self.managedObject[sender.tag]
			print(Date(), "Navigate to UploadAnimationVC", to: &Log.log)
			let cellData = batteryInstructionArray[sender.tag]
			let finalJsonData = cellData[Constants.FINAL_JSON_DATA]
			let vehicalInformation =  "\(cellData[Constants.VEHICAL] ?? "")"
			// Decode
			let data = Data(vehicalInformation.utf8)
			let jsonDecoder = JSONDecoder()
			let vehicalInfo = try! jsonDecoder.decode(Vehicle.self, from: data)
			
			
			let vc = UploadAnimationViewController()
			vc.errorSheetSource  = .OFFLINE_LIST
			let viewModel = UploadAnimationViewModel.init(managedObject: dataObject)
			vc.viewModel = viewModel
			//vc.managedObject = dataObject ?? NSManagedObject()
			vc.finalJsonString = "\(finalJsonData ?? "")"
			vc.vehicleInfo = vehicalInfo
			vc.workOrder = "\(cellData[Constants.WORK_ORDER] ?? "")"
			let stateOfCharge: Double = cellData[Constants.STATE_OF_CHARGE] as? Double ?? 0.0
			vc.stateOfCharge = stateOfCharge
			let odemeter: Double = cellData[Constants.ODOMETER] as? Double ?? 0.0
			vc.odometer = odemeter
			let currentEnergy = cellData[Constants.CURRENT_ENERGY] as? Double ?? 0.0
			vc.currentEnerygy = currentEnergy
			let numberOfCell = cellData[Constants.NUMBER_OF_CELL] as? Int ?? 0
			vc.numberofCells = numberOfCell
			let bmsCapacity: Double =  cellData[Constants.BMS] as? Double ?? 0.0
			vc.bmsCapacity = bmsCapacity
			
			let paramDictionary = [
				Parameters.workOrder: "\(dataObject.value(forKey: Constants.WORK_ORDER) ?? "")",
				Parameters.batteryTestInstructionsId: "\(dataObject.value(forKey: Constants.BATTERY_INSTRUCTION_ID) ?? "")",
				Parameters.year: "\(vehicalInfo.year)", Parameters.make : "\(vehicalInfo.make)", Parameters.model: "\(vehicalInfo.modelName)", Parameters.trim: "\(vehicalInfo.trimName)" ]
			FirebaseLogging.instance.logEvent(eventName:OfflineEvents.offlineUploadTest, parameters: paramDictionary)
			self.navigationController?.pushViewController(vc, animated: true)
		}
		
	}
	
	private func offlineAlertViewController() {
		let dialogMessage = UIAlertController(title: "No Internet Connection", message: "Looks like there is no internet connection. Please connect to Mobile data or Wifi", preferredStyle: .alert)
		let saveAndExit = UIAlertAction(title: "Retry", style: .default, handler: { (action) -> Void in
			self.navigationController?.popViewController(animated: true)
		})
		
		dialogMessage.addAction(saveAndExit)
	
		self.present(dialogMessage, animated: true, completion: nil)
	}
    
    
}
