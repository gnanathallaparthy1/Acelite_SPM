//
//  WorkOrderViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 1/12/23.
//

import UIKit
import CoreData
import FirebaseDatabase
import Firebase
import ExternalAccessory

class WorkOrderViewController: BaseViewController, UIGestureRecognizerDelegate {
	
//	var sessionController:              SessionController!
//	var selectedAccessory:              EAAccessory?
	
	@IBOutlet weak var locationCodeTextFiled: UITextField!
	@IBOutlet weak var dropDownView: UIView!
	private let tableView = UITableView()
	private let transparentView = UIView()
	private var dataSource = [String]()
	private var searchedCountry = [String]()
	private var searching = false
	let leftVeiwView = UIView(frame: CGRect(x: 20, y: 5, width: 40, height: 40))
	let iconImage = UIImageView(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
	let dropDownImage = UIImage.init(named: "icon_dropdown")
	@IBOutlet weak var offlineViewHeight: NSLayoutConstraint!
	@IBOutlet weak var offlineView: UIView!
	public var vehicleInfo: Vehicle?
	
	// remove
	var remoteConfig = RemoteConfig.remoteConfig()
	var locations = [[String: Any]]()
	
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
	@IBOutlet weak var backButton: UIButton! {
		didSet {
			backButton.layer.cornerRadius = 8
		}
	}
	@IBOutlet weak var countLabel: UILabel! {
		didSet {
			countLabel.text = "3/5"
			countLabel.layer.cornerRadius = countLabel.frame.size.width / 2
			countLabel.clipsToBounds = true
			
		}
	}
	@IBOutlet weak var barCodeTextField: UITextField!
	@objc public weak var delegate: ScannerViewDelegate?
	var networkStatus = NotificationCenter.default
	let natificationName = NSNotification.Name(rawValue:"InternetObserver")
	var viewModel: WorkOrderViewModel?
	var previousLocationCode = ""
	var interfaceType: DeviceInterfaceType = .BLEUTOOTH_LOW_ENERGY
	init(viewModel: WorkOrderViewModel) {
		super.init(nibName: nil, bundle: nil)
	
		self.viewModel = viewModel
		self.viewModel?.delegate = self
		//super.init()
	}
	
//	required init?(coder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		//self.revealViewController()?.to
		FirebaseLogging.instance.logScreen(screenName: ClassNames.workOrder)
		barCodeTextField.delegate = self
		offlineViewHeight.constant = 0
		offlineView.isHidden = true
		addCustomView()
		addDropDownValues()
		setupTapPress()
		locationCodeTextFiled.rightView = leftVeiwView
		locationCodeTextFiled.rightViewMode = .always
			 iconImage.image = dropDownImage
			 leftVeiwView.addSubview(iconImage)
		locationCodeTextFiled.delegate = self
		previousLocationCode = UserDefaults.standard.string(forKey: "locationCode") ?? "aaa"
		fetchLocationCodes()
	}
	
	func setupTapPress() {

		let singlePressGesture = UITapGestureRecognizer(target: self, action: #selector(tapPress))
		singlePressGesture.delegate = self
		singlePressGesture.cancelsTouchesInView = false
		self.tableView.addGestureRecognizer(singlePressGesture)
	}

	@objc func tapPress(gesture: UIGestureRecognizer) {

		if gesture.state == .ended {
			let touchPoint = gesture.location(in: self.tableView)
			if let indexPath = tableView.indexPathForRow(at: touchPoint) {
				// do your task on single tap
				var selectedLocation = ""
			if searching {
				selectedLocation = searchedCountry[indexPath.row]
					locationCodeTextFiled.text = selectedLocation
					} else {
						selectedLocation = dataSource[indexPath.row]
						locationCodeTextFiled.text = selectedLocation
					}
			
					for item in self.locations {
						let name: String = item["name"] as? String ?? ""
						if name.elementsEqual(selectedLocation) {
							let lCode: String = item["code"] as? String ?? ""
							UserDefaults.standard.set(lCode, forKey: "locationCode")
							self.previousLocationCode = lCode
						}
					}
				UserDefaults.standard.set(locationCodeTextFiled.text, forKey: "selectedLocation")
			
				hideTableView()
				locationCodeTextFiled.resignFirstResponder()
				searching = false
			
				let finalImage =  UIImage(cgImage: (iconImage.image?.cgImage)!, scale: 1.0, orientation: .up)
				locationCodeTextFiled.rightView = UIImageView.init(image: finalImage)

			}
		}
	}

	func rotateImage(image:UIImage) -> UIImage
	{
		var rotatedImage = UIImage()
		switch image.imageOrientation
		{
			case .right:
				rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .up)
			case .down:
				rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .right)
			case .left:
				rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .down)
			default:
				rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .left)
		}
		return rotatedImage
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
	
	// remove
	func fetchLocationCodes() {
		
		remoteConfig.fetch(withExpirationDuration: 0) { [unowned self] (status, error) in
			guard error == nil else {
				
				return }
			remoteConfig.activate()
			let locationCodes = remoteConfig.configValue(forKey: "manheim_locations_code").jsonValue as? AnyObject
			if let arrayObject = locationCodes, arrayObject.count > 0 {
				let array = arrayObject.value(forKey: "locations") as? NSArray
				guard let locationCodeModel = array, locationCodeModel.count > 0 else {
				
					return
				}
				locations = locationCodeModel as! [[String : Any]]
			}
				var names = [String]()
				for item in locations {
					let name: String = item["name"] as? String ?? ""
					names.append(name)
				}
				self.dataSource = names
				tableView.reloadData()
			
			
		}
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationItem.setHidesBackButton(true, animated:true)
		
		let menuBarButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.menuButtonAction(_ :)))
		menuBarButton.tintColor = UIColor.appPrimaryColor()
		self.navigationItem.leftBarButtonItem  = menuBarButton
		if  NetworkManager.sharedInstance.reachability.connection == .unavailable {
			self.showAndHideOffline(isShowOfflineView: true)
		}
		networkStatus.addObserver(self, selector: #selector(self.showOffileViews(_:)), name: natificationName, object: nil)
		addTableView(frames: locationCodeTextFiled.frame)

		
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
	
	@IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
	let vc = MainViewController()
		sender.target = vc
		sender.action = #selector(vc.revealSideMenu)
	}
	
	@IBAction func barcodeButtonAction(_ sender: UIButton) {
		let storyBaord = UIStoryboard.init(name: "Main", bundle: nil)
		let vc = storyBaord.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
		vc.delegate = self
		self.barCodeTextField.resignFirstResponder()
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
	}
		
	@IBAction func quickTestButtonAction(_ sender: UIButton) {
		self.viewModel?.isShortProfile = true
		
		
		
	}
	
	@IBAction func nextButtonAction(_ sender: UIButton) {
		//let combinedResult = dataSource.contains(where: locationCodeTextFiled.text)
		if let location = self.locationCodeTextFiled.text, location.count > 1, location.contains(dataSource) {
			guard let workOrder = self.barCodeTextField.text, workOrder.count > 1 else {
				self.showAlertMessage(message: "Please enter valid Work order number.")
				return
			}
			
			let paramDictionary = [
				Parameters.workOrder: self.barCodeTextField?.text?.description ?? "N/A"
			]
			FirebaseLogging.instance.logEvent(eventName: WorkOrderScreenEvents.workOrderInput, parameters: paramDictionary)
			if let viewModel = self.viewModel {
				let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
				let vehicalInformation = storyBoard.instantiateViewController(withIdentifier: "VehicalInformationViewController") as! VehicalInformationViewController
				vehicalInformation.interfaceType = self.interfaceType
				vehicalInformation.viewModel = VehicleInformationViewModel(vinNumber: viewModel.vehicleInfo.vin, vehicleInformation: viewModel.vehicleInfo, isShortProfile: viewModel.isShortProfile ?? false, workOrder: workOrder, locationCode: previousLocationCode)
			
				self.navigationController?.pushViewController(vehicalInformation, animated: true)
			}
		}
		else {
			self.showAlertMessage(message: "Please select your Location from the List.")
		}
	}
	
	private func addDropDownValues() {
		print("locationCodes size: \(locations.count)")
		viewModel?.delegate = self

		let previousLocation = UserDefaults.standard.string(forKey: "selectedLocation")
		if previousLocation != nil {
			locationCodeTextFiled.text = "\(previousLocation ?? "")"
		}
	}
}
extension String {
	func contains(_ strings: [String]) -> Bool {
		strings.contains { contains($0) }
	}
}

extension WorkOrderViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if let location = self.locationCodeTextFiled.text, location.count > 1, location.contains(dataSource) {
			guard let vinNumber = textField.text, vinNumber.count > 0 else {
				self.showAlertMessage(message: "Please enter valid Work order number.")
				return true
			}
			textField.resignFirstResponder()
			return true
		} else {
			self.showAlertMessage(message: "Please select your Location from the List.")
			return true
		}
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField == locationCodeTextFiled {
			let finalImage =  UIImage(cgImage: (iconImage.image?.cgImage)!, scale: 1.0, orientation: .down)
			locationCodeTextFiled.rightView = UIImageView.init(image: finalImage)
			showTableView(frames: dropDownView.frame)
		}
	}
	
	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if textField == locationCodeTextFiled {
			var searchText  = textField.text! + string
			
			if string  == "" {
				searchText = (searchText as String).substring(to: searchText.index(before: searchText.endIndex))
			}
			
			if searchText == "" {
				searching = false
				self.tableView.reloadData()
			}
			else {
				getSearchArrayContains(searchText)
			}
		}
		return true
	}
	
	
	// Predicate to filter data
	func getSearchArrayContains(_ text : String) {
		var predicate : NSPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", text)
		searchedCountry = (dataSource as NSArray).filtered(using: predicate) as! [String]
		searching = true
		self.tableView.reloadData()
	}
	
	func filterContentForSearchText(searchText: String) {
		searchedCountry = dataSource.filter { item in
			return item.lowercased().contains(searchText.lowercased())
		}
	}
	
	func searchAutocompleteEntriesWithSubstring(substring: String) {
		searchedCountry.removeAll(keepingCapacity: false)
		
		for curString in dataSource {
			let myString: NSString! = curString.lowercased()  as NSString
			let substringRange: NSRange! = myString.range(of: substring.lowercased())
			if (substringRange.location == 0) {
				searchedCountry.append(curString)
			}
		}
		searching = true
		tableView.reloadData()
	}
	
	
	private func showAlertMessage(message: String) {
		
		let dialogMessage = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
		// Create OK button with action handler
		let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
			
		})
		dialogMessage.addAction(ok)
		// Present Alert to
		self.present(dialogMessage, animated: true, completion: nil)
	}
}

extension WorkOrderViewController: ScannerViewDelegate {
	func didFindScannedText(text: String) {
			self.barCodeTextField?.text = text
			self.nextButton.isUserInteractionEnabled = true
			self.nextButton.isEnabled = true
	}
	
}

extension WorkOrderViewController: WorkOrderViewModelDelegate {
	func downloadLocations() {
		if let locationsData = viewModel?.locations {
			locations = locationsData
			var names = [String]()
			for item in locationsData {
				let name: String = item["name"] as? String ?? ""
				names.append(name)
			}
			
		}
		
	}
}

extension WorkOrderViewController: UITableViewDelegate, UITableViewDataSource {
	func addTableView(frames: CGRect) {
		transparentView.backgroundColor = UIColor.clear
		transparentView.frame = self.view.frame
		//locationView
		self.view.addSubview(transparentView)
		
		tableView.rowHeight = 40
		let tableVeiwHeight = (dataSource.count > 3) ? 120.0 : CGFloat(dataSource.count) * tableView.rowHeight
		tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: tableVeiwHeight)
		tableView.delegate = self
		tableView.dataSource = self
		
		self.view.addSubview(tableView)
		tableView.layer.cornerRadius = 5
		tableView.separatorStyle = .none
		tableView.layer.borderColor = UIColor.systemGray5.cgColor
		tableView.layer.borderWidth = 1.0
		
		tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		
		let tapgesture = UITapGestureRecognizer(target: self, action: #selector(self.hideTableView))
		transparentView.addGestureRecognizer(tapgesture)
		
		tableView.isHidden = true
		transparentView.isHidden = true
		
		self.view.bringSubviewToFront(tableView)
	}
	
	private func showTableView(frames: CGRect) {
		
		tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 160)
		tableView.isHidden = false
		transparentView.isHidden = false
		tableView.delegate = self
		tableView.dataSource = self
		tableView.reloadData()
	}
	
	
	@objc private func hideTableView() {
		locationCodeTextFiled.resignFirstResponder()
		tableView.isHidden = true
		transparentView.isHidden = true
		
		let finalImage =  UIImage(cgImage: (iconImage.image?.cgImage)!, scale: 1.0, orientation: .up)
		locationCodeTextFiled.rightView = UIImageView.init(image: finalImage)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searching {
			return searchedCountry.count
		} else {
			return dataSource.count
			
		}
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		
		if searching {
			cell.textLabel?.text = searchedCountry[indexPath.row]
		} else {
			cell.textLabel?.text = dataSource[indexPath.row]
		}
		
		return cell
		
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 40
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		var selectedLocation = ""
		if searching {
			selectedLocation = searchedCountry[indexPath.row]
			locationCodeTextFiled.text = selectedLocation
			
		} else {
			selectedLocation = dataSource[indexPath.row]
			print(selectedLocation)
			//tableViewButton.setTitle(dataSource[indexPath.row], for: .normal)
			locationCodeTextFiled.text = selectedLocation
		}
		
		for item in self.locations {
			let name: String = item["name"] as? String ?? ""
			if name.elementsEqual(selectedLocation) {
				let lCode: String = item["code"] as? String ?? ""
				UserDefaults.standard.set(lCode, forKey: "locationCode")
				self.previousLocationCode = lCode
			}
		}
		UserDefaults.standard.set(locationCodeTextFiled.text, forKey: "selectedLocation")
		
		hideTableView()
		locationCodeTextFiled.resignFirstResponder()
		searching = false
		
		let finalImage =  UIImage(cgImage: (iconImage.image?.cgImage)!, scale: 1.0, orientation: .up)
		locationCodeTextFiled.rightView = UIImageView.init(image: finalImage)
		
	}
	
}
