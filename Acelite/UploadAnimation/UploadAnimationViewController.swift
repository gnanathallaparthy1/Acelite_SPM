//
//  UploadAnimationViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/6/23.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase
import CoreData
import Apollo
import ExternalAccessory

class UploadAnimationViewController: BaseViewController {
	private let stackView: UIStackView = {
		$0.distribution = .fill
		$0.axis = .horizontal
		$0.alignment = .center
		$0.spacing = 10
		return $0
	}(UIStackView())
	
	private let circleA = UIView()
	private let circleB = UIView()
	private let circleC = UIView()
	private lazy var circles = [circleA, circleB, circleC]
	public var vehicleInfo: Vehicle?
	private let notificationCenter = NotificationCenter.default
	public var packVoltageData = [Double]()
	public var packCurrentData = [Double]()
	public var packTemperatureData = [Double]()
	public var cellVoltageData = [Double]()
	public var stateOfCharge: Double? = 0.0
	public var odometer: Double? = 0.0
	public var currentEnerygy: Double? = 0.0
	public var numberofCells: Int? = 0
	public var multiCellVoltageData = [[Double]]()
	public var bmsCapacity: Double? = 0.0
	private var calculateddCapacityAtBirth: Double = 0.0
	public var testInstructionsId: String?
	public var workOrder: String? = ""
	private var transactionId: String?
	private var healthScore: String?
	var csvDispatchGroup = DispatchGroup()
	var preSignedData: GetS3PreSingedURL?
	var textCommands = ""
	var remoteConfig = RemoteConfig.remoteConfig()
	var isJsonEnabled : Bool = true
	public var sampledCommandsList = [TestCommandExecution]()
	var finalJsonString: String = ""
	private var jsonFilePath: String = ""
	private var uploadFileName: String = ""
	var networkStatus = NotificationCenter.default
	let notificationName = NSNotification.Name(rawValue:"InternetObserver")
	var errorSheetSource = ErrorSheetSource.INSTRUCTION_FLOW
	var viewModel: UploadAnimationViewModel?
	var delegate:ShortProfileCommandsRunDelegate?
	
	var sessionController: SessionController!
	var accessory: EAAccessory?
	
	init(viewModel: UploadAnimationViewModel) {
		super.init(nibName: nil, bundle: nil)
		self.viewModel?.delegate = self
		self.viewModel = viewModel
		if self.viewModel?.interfaceType == .BLUETOOTH_CLASSIC {
			sessionController = SessionController.sharedController
			
			accessory = sessionController._accessory
			_ = sessionController.openSession()
		}
	
		self.viewModel?.sessionController = sessionController
		self.viewModel?.selectedAccessory = accessory
		//super.init()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	func animate() {
		
		let jumpDuration: Double = 0.30
		let delayDuration: Double = 1.25
		let totalDuration: Double = delayDuration + jumpDuration*2
		let jumpRelativeDuration: Double = jumpDuration / totalDuration
		let jumpRelativeTime: Double = delayDuration / totalDuration
		let fallRelativeTime: Double = (delayDuration + jumpDuration) / totalDuration
		for (index, circle) in circles.enumerated() {
			let delay = jumpDuration*2 * TimeInterval(index) / TimeInterval(circles.count)
			UIView.animateKeyframes(withDuration: totalDuration, delay: delay, options: [.repeat], animations: {
				UIView.addKeyframe(withRelativeStartTime: jumpRelativeTime, relativeDuration: jumpRelativeDuration) {
					circle.frame.origin.y -= 30
				}
				UIView.addKeyframe(withRelativeStartTime: fallRelativeTime, relativeDuration: jumpRelativeDuration) {
					circle.frame.origin.y += 30
				}
			})
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		FirebaseLogging.instance.logScreen(screenName: ClassNames.upload)
		viewModel?.delegate = self
		Network.shared.bluetoothService?.bleNonResponseDelegate = self
		print(Date(), "upload animation VC", to: &Log.log)
		navigationItem.hidesBackButton = true
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 21))
		label.center = CGPoint(x: 220, y: 150)
		label.textAlignment = .center
		label.text = "UPLOADING DATA..."
		label.font = UIFont(name: "Arial-BoldMT", size: 25)
		view.addSubview(label)
		view.backgroundColor = .white
		view.addSubview(stackView)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		circles.forEach {
			$0.layer.cornerRadius = 20/2
			$0.layer.masksToBounds = true
			$0.backgroundColor = .black
			stackView.addArrangedSubview($0)
			$0.widthAnchor.constraint(equalToConstant: 20).isActive = true
			$0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
		}
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		if self.viewModel?.interfaceType == .BLUETOOTH_CLASSIC {
			NotificationCenter.default.addObserver(self, selector: #selector(sessionDataReceived), name: NSNotification.Name(rawValue: "BESessionDataReceivedNotification"), object: nil)
			NotificationCenter.default.addObserver(self, selector: #selector(accessoryDidDisconnect), name: NSNotification.Name.EAAccessoryDidDisconnect, object: nil)
		}
		if viewModel?.isShortProfile == true {
			if errorSheetSource == .OFFLINE_LIST {
				self.viewModel?.submitBatteryDataForShortProfile()
			} else {
				self.viewModel?.initialCommand()
			}
			
			//submitBatteryDataJsonFileWithSOCAndBMSGraphRequest(fileName: "")
		} else {
			messageObserver()
			networkStatus.addObserver(self, selector: #selector(self.handleNetworkUpdate(_:)), name: notificationName, object: nil)
		}
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		if self.viewModel?.interfaceType == .BLUETOOTH_CLASSIC {
			NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "BESessionDataReceivedNotification"), object: nil)
			NotificationCenter.default.removeObserver(self, name: NSNotification.Name.EAAccessoryDidDisconnect, object: nil)
			
			sessionController.closeSession()
		}
		super.viewWillDisappear(animated)
	}
	
	
	// MARK: - Session Updates
	
	@objc func sessionDataReceived(notification: NSNotification) {
		
		if sessionController._dataAsString != nil {
			if let data = sessionController._dataAsString {
				//let responseString = String.init(data: data, encoding: .utf8)
				print("response STRING:", data)
			}
		}
	}
	
	// MARK: - EAAccessory Disconnection
	
	@objc func accessoryDidDisconnect(notification: NSNotification) {
		
		if navigationController?.topViewController == self {
			let disconnectedAccessory = notification.userInfo![EAAccessoryKey]
			if (disconnectedAccessory as! EAAccessory).connectionID == accessory?.connectionID {
				dismiss(animated: true, completion: nil)
			}
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.animate()
	}
	
	@objc func handleNetworkUpdate(_ notification: Notification) {
		
		let notificationobject = notification.object as? [String: Any] ?? [:]
		guard let isShowOfflineView: Bool = notificationobject["isConected"] as? Bool else {
			return
		}
		
		if !isShowOfflineView  {
			createJsonDataFile()
		}
	}
	
	deinit {
		notificationCenter.removeObserver(self)
	}
	
	private func messageObserver()  {
		remoteConfig.fetch(withExpirationDuration: 0) { [unowned self] (status, error) in
			guard error == nil else {print("FBase network fail")
				createJsonDataFile()
				return
				
			}
			remoteConfig.activate()
			//self.isJsonEnabled = remoteConfig.configValue(forKey: "submit_json_version_enabled").boolValue
			createJsonDataFile()
		}
	}
	
	private func saveOfflineData() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
		let managedContext = appDelegate.persistentContainer.viewContext
		let userEntity = NSEntityDescription.entity(forEntityName: "BatteryInstructionsData", in: managedContext)!
		
		let workOrder = self.workOrder ?? ""
		
		// Encode
		let jsonEncoder = JSONEncoder()
		let jsonData = try! jsonEncoder.encode(self.vehicleInfo)
		let vehicalInformation = String(data: jsonData, encoding: String.Encoding.utf8)
		//print(json)
		let vidata = NSManagedObject(entity: userEntity, insertInto: managedContext)
		vidata.setValue(self.getDateAndTime(), forKey: Constants.DATE_TIME)
		//vidata.setValue("2023-10-20 13:25:22", forKey: Constants.DATE_TIME)
		vidata.setValue(self.finalJsonString, forKey: Constants.FINAL_JSON_DATA)
		vidata.setValue(vehicalInformation, forKey: Constants.VEHICAL)
		vidata.setValue(workOrder, forKey: Constants.WORK_ORDER)
		vidata.setValue(bmsCapacity, forKey: Constants.BMS)
		vidata.setValue(numberofCells, forKey: Constants.NUMBER_OF_CELL)
		vidata.setValue(stateOfCharge, forKey: Constants.STATE_OF_CHARGE)
		vidata.setValue(odometer, forKey: Constants.ODOMETER)
		vidata.setValue(currentEnerygy, forKey: Constants.CURRENT_ENERGY)
		vidata.setValue(self.viewModel?.locationCode, forKey: Constants.LOCATION_CODE)
		
		//Now we have set all the values. The next step is to save them inside the Core Data
		do {
			try managedContext.save()
			self.navigationController?.popToRootViewController(animated: true)
		} catch let error as NSError {
			print("Could not save. \(error), \(error.userInfo)")
		}
	}
	private func saveOfflineDataForShortProfile() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
		let managedContext = appDelegate.persistentContainer.viewContext
		let userEntity = NSEntityDescription.entity(forEntityName: "BatteryInstructionsData", in: managedContext)!
		
		let workOrder = self.viewModel?.workOrder
		
		// Encode
		let jsonEncoder = JSONEncoder()
		let jsonData = try! jsonEncoder.encode(self.viewModel?.vehicleInfo)
		let vehicalInformation = String(data: jsonData, encoding: String.Encoding.utf8)
		//print(json)
		let vidata = NSManagedObject(entity: userEntity, insertInto: managedContext)
		vidata.setValue(self.getDateAndTime(), forKey: Constants.DATE_TIME)
		//vidata.setValue("2023-10-20 13:25:22", forKey: Constants.DATE_TIME)
		//vidata.setValue(self.finalJsonString, forKey: Constants.FINAL_JSON_DATA)
		vidata.setValue(vehicalInformation, forKey: Constants.VEHICAL)
		vidata.setValue(workOrder, forKey: Constants.WORK_ORDER)
		vidata.setValue(self.viewModel?.bms, forKey: Constants.BMS)
		//vidata.setValue(self.viewMode, forKey: Constants.NUMBER_OF_CELL)
		vidata.setValue(self.viewModel?.stateOfCharge, forKey: Constants.STATE_OF_CHARGE)
		vidata.setValue(self.viewModel?.odometer, forKey: Constants.ODOMETER)
		vidata.setValue(self.viewModel?.currentEnergy, forKey: Constants.CURRENT_ENERGY)
		
		//Now we have set all the values. The next step is to save them inside the Core Data
		do {
			try managedContext.save()
			self.navigationController?.popToRootViewController(animated: true)
		} catch let error as NSError {
			print("Could not save. \(error), \(error.userInfo)")
		}
	}
	private func getDateAndTime() -> String {
		let date = Date()
		let df = DateFormatter()
		df.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let dateString = df.string(from: date)
		return dateString
	}
	
	private func createJsonDataFile() {
		let fileManager = FileManager.default
		do {
			let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
			let vinNumber = self.vehicleInfo?.vin ?? ""
			let make = self.vehicleInfo?.make ?? ""
			let model = self.vehicleInfo?.modelName ?? ""
			let year = self.vehicleInfo?.year ?? 0
			var trim = self.vehicleInfo?.trimName
			trim = trim?.replacingOccurrences(of: " ", with: "_")
			let workOrder = self.workOrder ?? ""
			self.uploadFileName = "\(Constants.ACELITE_TEST)_\(vinNumber)_\(workOrder)_\(make)_\(model)_\(year)_\(trim ?? "")\(Constants.FILE_TYPE)"
			let fileURL =  path.appendingPathComponent("\(Constants.ACELITE_TEST)_\(vinNumber)_\(workOrder)_\(make)_\(model)_\(year)_\(trim ?? "")\(Constants.FILE_TYPE)")
			try self.finalJsonString.write(to: fileURL, atomically: true, encoding: .utf8)
			self.jsonFilePath = fileURL.absoluteString
			if self.currentReachabilityStatus != .notReachable {
				getTransactionId(filePath: self.jsonFilePath)
			} else {
				offlineAlertViewController()
			}
			
		} catch {
			print("error creating file")
		}
	}
	
	private func offlineAlertViewController() {
		let dialogMessage = UIAlertController(title: "Error", message: "Sorry,something went wrong.Please try again", preferredStyle: .alert)
		let saveAndExit = UIAlertAction(title: "Save & Exit", style: .default, handler: { (action) -> Void in
			if self.viewModel?.isShortProfile == true {
				self.saveOfflineDataForShortProfile()
			} else {
				self.saveOfflineData()
			}
			
		})
		let retryButton = UIAlertAction(title: "Retry", style: .default, handler: { (action) -> Void in
			if self.viewModel?.isShortProfile == true {
				self.viewModel?.submitBatteryDataForShortProfile()
			} else {
				self.getTransactionId(filePath: self.jsonFilePath)
			}
		})
		if errorSheetSource == .OFFLINE_LIST {
			dialogMessage.addAction(retryButton)
		} else {
			dialogMessage.addAction(saveAndExit)
			dialogMessage.addAction(retryButton)
		}
		self.present(dialogMessage, animated: true, completion: nil)
	}
	
	func getTransactionId(filePath: String)  {
		Network.shared.apollo.fetch(query: GetS3PreSingedUrlQuery(vin: vehicleInfo?.vin ?? "")) { result in
			switch result {
			case .success(let graphQLResult):
				guard let _ = try? result.get().data else { return }
				if graphQLResult.data != nil {
					
					let getS3PreSingedData = graphQLResult.data?.resultMap["getS3PreSingedURL"]?.jsonValue
					var preSignedData : Data?
					do {
						preSignedData = try JSONSerialization.data(withJSONObject: getS3PreSingedData as Any)
					} catch {
						print(Date(), "Unexpected error: \(error).", to: &Log.log)
						FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.s3PreSignedUrlError, parameters: nil)
					}
					
					do {
						let decoder = JSONDecoder()
						let preSignedResponse = try decoder.decode(GetS3PreSingedURL.self, from: preSignedData!)
						self.transactionId = preSignedResponse.transactionID
						self.preSignedData = preSignedResponse
						print(Date(), "preSignedResponse.", to: &Log.log)
						if self.isJsonEnabled {
							if self.currentReachabilityStatus != .notReachable {
								self.jsonFileUploadingIntoS3Bucket(fileName: filePath)
							} else {
								self.offlineAlertViewController()
							}
						} else {
							self.preparingLogicForCSVFileGeration()
						}
						FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.s3PreSignedUrlSuccess, parameters: nil)
					} catch DecodingError.dataCorrupted(_) {
						self.offlineAlertViewController()
						print(Date(), "preSignedResponse Error", to: &Log.log)
						FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.s3PreSignedUrlError, parameters: nil)
					} catch DecodingError.keyNotFound(let key, let context) {
						print("Key '\(key)' not found:", context.debugDescription)
						print("codingPath:", context.codingPath)
						self.offlineAlertViewController()
						print(Date(), "preSignedResponse Error", to: &Log.log)
						FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.s3PreSignedUrlError, parameters: nil)
					} catch DecodingError.valueNotFound(_, let context) {
						self.offlineAlertViewController()
						print("codingPath:", context.codingPath)
						print(Date(), "preSignedResponse Error", to: &Log.log)
						FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.s3PreSignedUrlError, parameters: nil)
					} catch DecodingError.typeMismatch(let type, let context) {
						print("Type '\(type)' mismatch:", context.debugDescription)
						print("codingPath:", context.codingPath)
						self.offlineAlertViewController()
						print(Date(), "preSignedResponse Error", to: &Log.log)
						FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.s3PreSignedUrlError, parameters: nil)
					} catch {
						self.offlineAlertViewController()
						print("error: ", error)
						print(Date(), "preSignedResponse Error", to: &Log.log)
						FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.s3PreSignedUrlError, parameters: nil)
					}
				}
				
			case .failure( _):
				self.offlineAlertViewController()
				print(Date(), "preSignedResponse Error", to: &Log.log)
				FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.s3PreSignedUrlError, parameters: nil)
			}
		}
	}
	
	func preparingLogicForCSVFileGeration() {
		print(Date(), "preparingLogicForCSVFileGeration", to: &Log.log)
		let cellVoltageList = sampledCommandsList.filter { testCommand in
			return testCommand.type == .CELL_VOLTAGE
		}
		var minVlaue: Int = 0
		if cellVoltageData.count > 0 {
			var result = cellVoltageData.chunked(into: cellVoltageList.count)
			guard let resultLastValue = result.last else { return  }
			if resultLastValue.count < cellVoltageList.count {
				result.removeLast()
			} else {
				print(Date(), "after process result count", to: &Log.log)
			}
			let listCount: [Int] = [result.count,  self.packCurrentData.count, self.packVoltageData.count]
			
			if result.count == 0 {
				let paramDictionary = [
					"file_type": "CELL_VOLTAGE"
				]
				FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.uploadFileError, parameters: paramDictionary)
				print(Date(), "error CELL_VOLTAGE generation", to: &Log.log)
				return
			} else if self.packCurrentData.count == 0 {
				let paramDictionary = [
					"file_type": "PACK_CURRENT"
				]
				FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.uploadFileError, parameters: paramDictionary)
				print(Date(), "error PACK_CURRENT generation", to: &Log.log)
				return
			} else if self.packVoltageData.count == 0 {
				let paramDictionary = [
					"file_type": "PACK_VOLTAGE"
				]
				FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.uploadFileError, parameters: paramDictionary)
				print(Date(), "error PACK_VOLTAGE generation", to: &Log.log)
				return
			}
			minVlaue = listCount.min() ?? 0
			print("min value from count array", minVlaue)
			if minVlaue == 0 {
				print(Date(), "Min Count of the Data Files Not Fullfilled", to: &Log.log)
				showDataInsufficientError()
				return
			}
			let finalCellVoltage = result[0...minVlaue - 1]
			self.createCellVoltageCSV(data: Array(finalCellVoltage))
		} else {
			let listCount: [Int] = [multiCellVoltageData.count,  self.packCurrentData.count, self.packVoltageData.count]
			minVlaue = listCount.min() ?? 0
			if minVlaue == 0 {
				print(Date(), "Min Count of the Data Files Not Fullfilled", to: &Log.log)
				showDataInsufficientError()
				return
			}
			let finalCellVoltage = multiCellVoltageData[0...minVlaue - 1]
			self.createCellVoltageCSV(data: Array(finalCellVoltage))
		}
		//TO-DO handle zero size
		if minVlaue == 0 {
			print(Date(), "Min Count of the Data Files Not Fullfilled", to: &Log.log)
			showDataInsufficientError()
			return
		}
		let finalPackCurrent = packCurrentData[0...minVlaue - 1]
		self.createPackCurrentCSVFile(data: Array(finalPackCurrent))
		let finalPackVoltage = packVoltageData[0...minVlaue - 1]
		createPackVoltageCSV(data: Array(finalPackVoltage))
	}
	
	//MARK: Create pack current CSV
	func createPackCurrentCSVFile(data: [Double] ) {
		print(Date(), "Uploading PackCurrentCSVFile", to: &Log.log)
		let pack_Current = CSVFile(fileName: "Pack_Current_\(self.vehicleInfo?.vin ?? "")")
		let pack_CurrentFilePath = pack_Current.creatCSVForArray(data: data)
		csvDispatchGroup.enter()
		//csvFileUploadingIntoS3Bucket(fileName: pack_CurrentFilePath.absoluteString)
		let paramDictionary = [
			"file_type": "PACK_CURRENT"
		]
		FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.uploadFileSuccess, parameters: paramDictionary)
		
	}
	
	// MARK: Create pack voltage CSV
	func createPackVoltageCSV(data: [Double]) {
		print(Date(), "Uploading PackVoltageCSV", to: &Log.log)
		let pack_Voltage = CSVFile(fileName: "Pack_Voltage_\(self.vehicleInfo?.vin ?? "")")
		csvDispatchGroup.enter()
		let pack_VoltageFilePath = pack_Voltage.creatCSVForArray(data: data)
		//csvFileUploadingIntoS3Bucket(fileName: pack_VoltageFilePath.absoluteString)
		let paramDictionary = [
			"file_type": "PACK_VOLTAGE"
		]
		FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.uploadFileSuccess, parameters: paramDictionary)
	}
	
	// MARK: Create Cell Voltage CSV
	func createCellVoltageCSV(data: [[Double]]) {
		
		print(Date(), "Uploading CellVoltageCSV", to: &Log.log)
		let cell_voltage = CSVFile(fileName: "Cell_Volt_\(self.vehicleInfo?.vin ?? "")")
		csvDispatchGroup.enter()
		let cellVoltageFilePath = cell_voltage.createMultiframeCSV(data: data)
		//csvFileUploadingIntoS3Bucket(fileName: cellVoltageFilePath.absoluteString)
		let paramDictionary = [
			"file_type": "CELL_VOLTAGE"
		]
		FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.uploadFileSuccess, parameters: paramDictionary)
	}
	
	func jsonFileUploadingIntoS3Bucket(fileName: String) {
		print(Date(), "Uploading JSON File Uploading Into S3Bucket", to: &Log.log)
		guard let presinedData = self.preSignedData else { return }
		var multipart = MultipartRequest()
		for field in [
			"key": presinedData.fields.key,
			"AWSAccessKeyId": presinedData.fields.awsAccessKeyID,
			"x-amz-security-token": presinedData.fields.xamzSecurityToken,
			"policy": presinedData.fields.policy,
			"signature": presinedData.fields.signature
		] {
			multipart.add(key: field.key, value: field.value)
		}
		let data = (try? Data(contentsOf: URL(string: fileName) ?? URL(fileURLWithPath: ""))) ?? Data()
		multipart.add(
			key: "file",
			fileName: "\(fileName)",
			fileMimeType: "text/csv",
			fileData: data
		)
		let url = URL(string: "\(presinedData.url)")!
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue(multipart.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
		request.httpBody = multipart.httpBody
		let session =  URLSession.shared
		let dataTask = session.dataTask(with: request) { data, response, error in
			//self.csvDispatchGroup.leave()
			guard let _ = data else {
				print("presinedData json data response Error")
				print(Date(), "presinedData json data response Error", to: &Log.log)
				self.offlineAlertViewController()
				return
			}
			if self.currentReachabilityStatus != .notReachable {
				self.submitBatteryDataJsonFileWithSOCAndBMSGraphRequest(fileName: fileName)
			} else {
				self.offlineAlertViewController()
			}
		}
		dataTask.resume()
	}
	
	// MARK: Submit Battery Data
	private func submitBatteryDataJsonFileWithSOCAndBMSGraphRequest(fileName: String) {
		
		print(Date(), "submitBatteryDataFileWithSOCGraphRequest", to: &Log.log)
		guard let veh = vehicleInfo else {return}
		guard let vinInfo = vehicleInfo?.vin else { return  }
		guard let vinMake = vehicleInfo?.make else { return  }
		guard let vinYear = vehicleInfo?.year else {return}
		guard let vinModels = vehicleInfo?.modelName else {return}
		guard let trim = vehicleInfo?.trimName else {return}
		let years: Int = Int(vinYear)
		let vehicalBatteryDataFile = SubmitBatteryDataFilesVehicleInput.init(vin: vinInfo, make: vinMake, model: vinModels, year: years, trim: trim)
		let batteryInstr = vehicleInfo?.getBatteryTestInstructions
		//Vehicle Profile
		guard let vehicleProfile = batteryInstr?[0].testCommands?.vehicleProfile else {
			print(Date(), "SOC:Submit API failed due to Vehicle Profile", to: &Log.log)
			//let expectedCapacityAtBirth: Double = (vehicalProfile.capacityAtBirth ?? Double(0.0))!
			calculateddCapacityAtBirth = self.bmsCapacity ?? 0.0
			self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:Submit API failed due to Vehicle Profile", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinInfo, year: years, errorCode: "",  bmsCapacity: "\(String(describing: self.bmsCapacity))", expectedBMS: "\(self.calculateddCapacityAtBirth)", workOrder: self.workOrder ?? "")
			return
		}
		print(Date(), "SOC:Vehicle Profile\(vehicleProfile)", to: &Log.log)
		//State of Health
		if let stateOfHealth = batteryInstr?[0].testCommands?.stateOfCharge {
			print(Date(), "SOC:State of Health\(stateOfHealth)", to: &Log.log)
		}
		
		
		//Nominal Volatage
		if let nominalVoltage: Double = vehicleProfile.nominalVoltage {
			print(Date(), "SOC:Nominal Voltage\(nominalVoltage)", to: &Log.log)
		}
		
		//EnergyAtBirth
		if let energyAtBirth: Double = vehicleProfile.energyAtBirth {
			print(Date(), "SOC:energyAtBirth\(energyAtBirth)", to: &Log.log)
		}
		
		//CapacityAtBirth
		if let capacityAtBirth: Double = vehicleProfile.capacityAtBirth  {
			print(Date(), "SOC:capacityAtBirth\(capacityAtBirth)", to: &Log.log)
		}
		
		//Battery
		if let batteryType: String = vehicleProfile.batteryType {
			print(Date(), "SOC:BatteryType\(batteryType)", to: &Log.log)
		}
		
		
		let vehicalProfile = CalculateBatteryHealthVehicleProfileInput.init(nominalVoltage: vehicleProfile.nominalVoltage, energyAtBirth: vehicleProfile.energyAtBirth , batteryType: .lithium, capacityAtBirth: vehicleProfile.capacityAtBirth, rangeAtBirth: vehicleProfile.rangeAtBirth)
		
		
		print("vehical Profile", vehicleProfile)
		print(Date(), "vehicalProfile : \(vehicalProfile)", to: &Log.log)
		var calculatedBetteryHealth : CalculateBatteryHealthInput?
		if let bms = self.bmsCapacity, bms != 0 {
			//With BMS
			let stateOfCharge = self.stateOfCharge
			let dashDataInput = DashDataInput.init(odometer: Int(odometer ?? 0), stateOfCharge: stateOfCharge)
			let expectedCapacityAtBirth: Double = (vehicalProfile.capacityAtBirth ?? Double(0.0))!
			calculateddCapacityAtBirth = self.bmsCapacity ?? 0.0
			//var bmsCapacity: Double = 0.0
			if calculateddCapacityAtBirth > expectedCapacityAtBirth {
				self.bmsCapacity = expectedCapacityAtBirth
			} else {
				self.bmsCapacity = calculateddCapacityAtBirth
			}
			let bmsObdTest = OBD2TestInput.init(filename: self.uploadFileName, transactionId: self.preSignedData!.transactionID, instructionSetId: veh.getBatteryTestInstructions?[0].testCommands?.id, odometer: Int(self.odometer ?? 0) ,  bmsCapacity: self.bmsCapacity)
			calculatedBetteryHealth = CalculateBatteryHealthInput.init(vehicleProfile: vehicalProfile, obd2Test: bmsObdTest, dashData: dashDataInput, locationCode: self.viewModel?.location, workOrderNumber: self.workOrder ?? "", totalNumberOfCharges: 1, lifetimeCharge: 2.0 , lifetimeDischarge: 2.0)
		} else {
			// Without BMS
			let stateOfCharge = self.stateOfCharge
			let currentEnergy = self.currentEnerygy
			let dashDataInput = DashDataInput.init(odometer: Int(odometer ?? 0), stateOfCharge: stateOfCharge)
			let obd2Test = OBD2TestInput.init(filename: self.uploadFileName, transactionId: self.preSignedData!.transactionID, instructionSetId: veh.getBatteryTestInstructions?[0].testCommands?.id, odometer: Int(self.odometer ?? 0) , currentEnergy: currentEnergy, stateOfCharge: stateOfCharge)
			print("OBD2TEST", obd2Test)
			calculatedBetteryHealth = CalculateBatteryHealthInput.init(vehicleProfile: vehicalProfile, obd2Test: obd2Test, dashData: dashDataInput, locationCode: self.viewModel?.location, workOrderNumber: self.workOrder ?? "", totalNumberOfCharges: 1, lifetimeCharge: 2.0 , lifetimeDischarge: 2.0)
		}
		print(Date(), "calculatedBetteryHealth: \(String(describing: calculatedBetteryHealth))", to: &Log.log)
		//
		let submitScoreQuery = CalculateBatteryHealthQuery(calculateBatteryHealthInput: calculatedBetteryHealth ?? CalculateBatteryHealthInput(), vin: vinInfo)
		
		Network.shared.apollo.fetch(query: submitScoreQuery) { result in
			switch result {
			case .success(let graphQLResults):
				guard let _ = try? result.get().data else { return }
				if graphQLResults.data != nil {
					print("JSON query success case")
					if graphQLResults.errors?.count ?? 0 > 0 {
						print(Date(), "SOC:submit API Error 1:\(String(describing: graphQLResults.errors))", to: &Log.log)
						self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "\(String(describing: graphQLResults.errors))", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinInfo, year: years, errorCode: "", bmsCapacity: "\(String(describing: self.bmsCapacity))", expectedBMS: "\(self.calculateddCapacityAtBirth)", workOrder: self.workOrder ?? "")
						let paramDictionary = [
							"submit_type": "STATE_OF_CHARGE",
							"batter_test_instructions_id": "\(String(describing: self.testInstructionsId))",
							"errorCode":"\(String(describing: graphQLResults.errors))",
							"work_order": "\(String(describing: self.workOrder))"]
						FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.submitBatteryFilesError, parameters: paramDictionary)
						return
						
					}
					
					let submitData =  graphQLResults.data?.resultMap["vehicle"]
					if submitData == nil {
						print("CALCULATE BATTERY HEALTH")
						print(Date(), "SOC:submit API result Map Error :\(String(describing: graphQLResults.errors))", to: &Log.log)
						self.delegate?.showShortProfileSubmitError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "\(String(describing: graphQLResults.errors))", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinInfo, year: years, errorCode: "", submittedBms: self.bmsCapacity, expectedBms: self.calculateddCapacityAtBirth)
						let paramDictionary = [
							"submit_type": "STATE_OF_CHARGE",
							"errorCode":"\(String(describing: graphQLResults.errors))",
							"work_order": "\(String(describing: self.workOrder))"]
						FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.submitBatteryFilesError, parameters: paramDictionary)
						return
					} else {
						let jsonObject = submitData.jsonValue
						do {
							let  preSignedData = try JSONSerialization.data(withJSONObject: jsonObject)
							print(Date(), "SOC:submit Battery Data succesfully :\(String(describing: jsonObject))", to: &Log.log)
							do {
								let decoder = JSONDecoder()
								let submitBatteryData = try decoder.decode(Vehicle.self, from: preSignedData)
								print(Date(), "SOC:submit API Decode Sucessful :\(String(describing: submitBatteryData))", to: &Log.log)
								if submitBatteryData.calculateBatteryHealth?.success == false {
									print("JSON IS DATA OBJECT")
									print(Date(), "SOC:battery Score is Null :\(String(describing: graphQLResults.errors))", to: &Log.log)
									self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "Battery Score is Null", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinInfo, year: years, errorCode: submitBatteryData.calculateBatteryHealth?.code ?? "",bmsCapacity: "\(String(describing: self.bmsCapacity))", expectedBMS: "\(self.calculateddCapacityAtBirth)", workOrder: self.workOrder ?? "")
									return
								} else {
									//check
									let bt = submitBatteryData.calculateBatteryHealth?.calculatedBatteryHealth
									let minEstRange = bt?.estimatedRange?.estimatedRangeMin
									let maxEstRange = bt?.estimatedRange?.estimatedRangeMax
									
									self.deleteUploadedRecordInCoreData()
									let batteryHealth = submitBatteryData.calculateBatteryHealth?.calculatedBatteryHealth?.batteryScore
									print("battery health:: SCORE --- \(batteryHealth?.score ?? 0.0)")
									let storyBaord = UIStoryboard.init(name: "Main", bundle: nil)
									let vc = storyBaord.instantiateViewController(withIdentifier: "BatteryHealthViewController") as! BatteryHealthViewController
									let vm = BatteryHealthViewModel(vehicleInfo: veh, transactionID: self.transactionId ?? "", testIntructionsId: self.testInstructionsId ?? "", healthScore: batteryHealth?.score ?? 0.0, grade: VehicleGrade(rawValue: VehicleGrade(rawValue: batteryHealth?.grade ?? "N/A")?.title ??  "N/A") ?? .A, health: batteryHealth?.health ?? "N/A", rangeAtBirth: vehicalProfile.rangeAtBirth ?? 0 , minEstimatedRnge: minEstRange , maxEstimatedRnge: maxEstRange, bmsCapacity: self.bmsCapacity)
									vc.viewModel = vm
									
									self.submitSuccessForSubmitAPI(transactionID: self.transactionId ?? "", vinMake: vinMake, score: "\(batteryHealth?.score ?? 0.0)", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinInfo, year: vinYear, testProfileType: BMSCapacityTest.stressTest, BMSCapacity: self.bmsCapacity ?? 0.0, expectedBms: self.calculateddCapacityAtBirth, workOrder: self.workOrder ?? "" )
									
									self.navigationController?.pushViewController(vc, animated: true)
									
								}
								
							}
						}
						catch {
							self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:submit API Error :\(error)", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinInfo, year: years, errorCode: "", bmsCapacity: "\(self.bmsCapacity ?? 0.0)", expectedBMS: "\(self.calculateddCapacityAtBirth)", workOrder: self.workOrder ?? "")
							print(Date(), "SOC:submit API Error :\(error)", to: &Log.log)
						}
					}
				}
				break
			case .failure(let error):
				if let transactionId = self.preSignedData?.transactionID {
					self.showSubmitAPIError(transactionID: transactionId , vinMake: vinMake, message: error.localizedDescription, vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinInfo, year: years, errorCode:  "", bmsCapacity: "\(self.bmsCapacity ?? 0.0)", expectedBMS: "\(self.calculateddCapacityAtBirth)", workOrder: self.workOrder ?? "")
				}
				print(Date(), "SOC:submit API Error :\(error)", to: &Log.log)
				
				break
			}
		}
	}
	
	private func deleteUploadedRecordInCoreData() {
		guard let managedObject = self.viewModel?.managedObject else {
			print(Date(), "CoreData: ManagedOBject is empty", to: &Log.log)
			return
		}
		//As we know that container is set up in the AppDelegates so we need to refer that container.
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
		//We need to create a context from this container
		let managedContext = appDelegate.persistentContainer.viewContext
		managedContext.delete(managedObject)
		print(Date(), "CoreData: Selected ManagedObject is deleted", to: &Log.log)
		appDelegate.saveContext()
		print(Date(), "CoreData: Updated save context", to: &Log.log)
	}
	
	func showBottomSheet(message: SubmitApiResponse) {
		DispatchQueue.main.async {
			let viewModel = OfflineViewModel(submitApiResponse: message)
			let storyBaord = UIStoryboard.init(name: "BatteryHealthCheck", bundle: nil)
			let vc = storyBaord.instantiateViewController(withIdentifier: "OfflineViewController") as! OfflineViewController
			vc.delegate = self
			vc.viewModel = viewModel
			vc.modalPresentationStyle = .overFullScreen
			self.present(vc, animated: true)
		}
	}
	
	
	func saveLogsIntoTxtFile() -> String {
		
		if self.textCommands.count > 2 {
			let text = self.textCommands
			let folder = "Acelite"
			let timeStamp = Date.currentTimeStamp
			let fileNamed = "\(timeStamp)"
			guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return  ""}
			guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else { return ""}
			try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
			let file = writePath.appendingPathComponent(fileNamed + ".txt")
			try? text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
			return file.absoluteString
		} else {
			return ""
		}
	}
	
	
	func submitSuccessForSubmitAPI(transactionID: String, vinMake: String, score: String, vinModels: String, submitType: String, vinNumber: String, year: Int, testProfileType: String, BMSCapacity: Double, expectedBms: Double, workOrder: String) {
		let paramDictionary = [
			"submit_type": submitType,
			"batter_test_instructions_id": "\(String(describing: self.testInstructionsId))",
			"work_order": "\(String(describing: self.workOrder))", "profile_test_type": testProfileType, "bms_capacity": "\(String(describing: BMSCapacity))", "location_code": self.viewModel?.locationCode ?? "" ] as [String : String]
		FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.submitBatteryFilesSuccess, parameters: paramDictionary)
		let rootRef = Database.database().reference()
		let ref = rootRef.child("successful_transaction_ids").childByAutoId()
		if let transectionId = self.testInstructionsId, transectionId.count > 0 {
			let vinBatteryInfo: [String: String?] = ["battery_test_instructions_id": self.testInstructionsId,"make": vinMake, "score": score, "model": vinModels, "platform": "iOS", "submit_type": submitType, "time_stamp": Constants().currentDateTime(), "transaction_id": transectionId, "vin_number": vinNumber, "year": String(year), "work_order": workOrder, "bms_value_calculated": "\(expectedBms)", "bms_value_submitted": "\(BMSCapacity)", "profile_test_type": testProfileType, "location_code": self.viewModel?.locationCode ?? ""]
			ref.setValue(vinBatteryInfo) {
				(error:Error?, ref:DatabaseReference) in
				if let _ = error {
					//print("Data could not be saved: \(error).")
				} else {
					//print("Fail data saved successfully!")
				}
			}
		} else {
			let vinBatteryInfo: [String: String?] = ["battery_test_instructions_id": self.testInstructionsId, "make": vinMake, "score": score, "model": vinModels, "platform": "iOS", "submit_type": submitType, "time_stamp": Constants().currentDateTime(), "vin_number": vinNumber, "year": String(year), "work_order": workOrder, "bms_value_calculated": "\(expectedBms)", "bms_value_submitted": "\(BMSCapacity)", "profile_test_type": testProfileType, "location_code": self.viewModel?.locationCode ?? ""]
			ref.setValue(vinBatteryInfo) {
				(error:Error?, ref:DatabaseReference) in
				if let _ = error {
					//print("Data could not be saved: \(error).")
				} else {
					//print("Fail data saved successfully!")
				}
			}
		}
		
		
	}
	
	func showSubmitAPIError(transactionID: String, vinMake: String, message: String, vinModels: String, submitType: String, vinNumber: String, year: Int, errorCode: String, bmsCapacity: String, expectedBMS: String, workOrder: String) {
		//BMSCapacity: self.bmsCapacity ?? 0.0, expectedBms: self.calculateddCapacityAtBirth, workOrder: self.workOrder ?? ""
		let rootRef = Database.database().reference()
		let ref = rootRef.child("submit_error_details").childByAutoId()
		let vinBatteryInfo: [String: String?] = ["battery_test_instructions_id": self.testInstructionsId,"make": vinMake, "message": message, "model": vinModels, "platform": "iOS", "submit_type": submitType, "time_stamp": Constants().currentDateTime(), "transaction_id": transactionID, "vin_number": vinNumber, "year": String(year), "work_order": workOrder, "bms_value_calculated": "\(expectedBMS)", "bms_value_submitted": "\(bmsCapacity)", "profile_test_type": BMSCapacityTest.stressTest, "location_code": "\(self.viewModel?.locationCode ?? "")" ]
		
		ref.setValue(vinBatteryInfo) {
			(error:Error?, ref:DatabaseReference) in
			if let _ = error {
				//print("Data could not be saved: \(error).")
			} else {
				//print("Fail data saved successfully!")
			}
		}
		if errorCode != "" {
			for item in SubmitApiResponse.allCases {
				if item.rawValue == errorCode {
					
					let paramDictionary = [
						Parameters.code : item.rawValue,
						Parameters.source : errorSheetSource.rawValue ]
					FirebaseLogging.instance.logEvent(eventName:OfflineEvents.offlineErrorSheet, parameters: paramDictionary)
					
					self.showBottomSheet(message: item)
					return
				}
			}
		} else {
			
			self.stackView.removeFromSuperview()
			
			let dialogMessage = UIAlertController(title: "Error", message: "Sorry,something went wrong.Please try again", preferredStyle: .alert)
			
			//2 buttons - Save and Exit- save to db and Pop to root and 2. retry- gettrasactionID and upload and submit
			let saveAndExit = UIAlertAction(title: "Save & Exit", style: .default, handler: { (action) -> Void in
				if self.viewModel?.isShortProfile == true {
					self.saveOfflineDataForShortProfile()
				} else {
					self.saveOfflineData()
				}
			})
			
			let retryButton = UIAlertAction(title: "Retry", style: .default, handler: { (action) -> Void in
				if self.viewModel?.isShortProfile == true {
					self.viewModel?.submitBatteryDataForShortProfile()
				} else {
					self.getTransactionId(filePath: self.jsonFilePath)
				}
			})
			if errorSheetSource == .OFFLINE_LIST {
				dialogMessage.addAction(retryButton)
			} else {
				dialogMessage.addAction(saveAndExit)
				dialogMessage.addAction(retryButton)
			}
			
			self.present(dialogMessage, animated: true, completion: nil)
		}
	}
	
	func showDataInsufficientError() {
		let rootRef = Database.database().reference()
		let ref = rootRef.child("submit_error_details").childByAutoId()
		let vinBatteryInfo: [String: String?] = ["battery_test_instructions_id": self.testInstructionsId,"make": "", "message": "Min Count of the Data Files Not Fullfilled", "model": "", "platform": "iOS", "submit_type": "", "time_stamp": Constants().currentDateTime(), "transaction_id": self.transactionId, "vin_number": "", "year": "","work_order": "\(String(describing: self.workOrder))","location_code": "\(self.viewModel?.locationCode ?? "")"]
		ref.setValue(vinBatteryInfo) {
			(error:Error?, ref:DatabaseReference) in
			if let error = error {
				print("Data could not be saved: \(error).")
			} else {
				print("Fail data saved successfully!")
			}
		}
		self.stackView.removeFromSuperview()
		let dialogMessage = UIAlertController(title: "Error", message: "Sorry,something went wrong.Please try again", preferredStyle: .alert)
		let ok = UIAlertAction(title: "GOT IT", style: .default, handler: { (action) -> Void in
			guard let viewControllers = self.navigationController?.viewControllers else {
				return
			}
			for workOrderVc in viewControllers {
				if workOrderVc is WorkOrderViewController {
					self.navigationController?.popToViewController(workOrderVc, animated: true)
					break
				} else {
					self.navigationController?.popToRootViewController(animated: true)
					break
				}
			}
		})
		dialogMessage.addAction(ok)
		self.present(dialogMessage, animated: true, completion: nil)
		
	}
	
	override func navigateToRootView() {
		if let pheriPheral = Network.shared.myPeripheral {
			Network.shared.bluetoothService?.disconnectDevice(peripheral: pheriPheral)
		}
		self.deleteUploadedRecordInCoreData()
		self.navigationController?.popToRootViewController(animated: true)
	}
	
}
extension UploadAnimationViewController: ShortProfileCommandsRunDelegate {
	func showShortProfileSubmitError(transactionID: String?, vinMake: String, message: String, vinModels: String, submitType: String, vinNumber: String, year: Int, errorCode: String, submittedBms: Double?, expectedBms: Double?) {
		self.showSubmitAPIError(transactionID: transactionID ?? "", vinMake: vinMake, message: message, vinModels: vinModels, submitType: submitType, vinNumber: vinNumber, year: year, errorCode: errorCode, bmsCapacity: "\(submittedBms ?? 0.0)", expectedBMS: "\(expectedBms ?? 0.0)", workOrder: self.workOrder ?? "")
	}
	
	func shortProfileCommandsCompleted(battteryHealth: BatteryScore?, minRange: Double?, maxRange: Double?, rangeAtBirth: Double?, submittedBms: Double?, expectedBms: Double?, submitedType: String, workOrder: String) {
		DispatchQueue.main.async {
			let storyBaord = UIStoryboard.init(name: "Main", bundle: nil)
			let vc = storyBaord.instantiateViewController(withIdentifier: "BatteryHealthViewController") as! BatteryHealthViewController
			guard let veh = self.viewModel?.vehicleInfo else {return}
			guard let vinInfo = self.viewModel?.vehicleInfo?.vin else { return  }
			guard let vinMake = self.viewModel?.vehicleInfo?.make else { return  }
			guard let vinYear = self.viewModel?.vehicleInfo?.year else {return}
			guard let vinModels = self.viewModel?.vehicleInfo?.modelName else {return}
			self.submitSuccessForSubmitAPI(transactionID: self.transactionId ?? "", vinMake: vinMake, score: "\(battteryHealth?.score ?? 0.0)", vinModels: vinModels, submitType: submitedType, vinNumber: vinInfo, year: vinYear, testProfileType: BMSCapacityTest.quickTest, BMSCapacity: submittedBms ?? 0.0, expectedBms: expectedBms ?? 0.0, workOrder: workOrder )
			self.deleteUploadedRecordInCoreData()
			let vm = BatteryHealthViewModel(vehicleInfo: veh, transactionID: self.transactionId ?? "", testIntructionsId: self.testInstructionsId ?? "", healthScore: battteryHealth?.score ?? 0.0 , grade: VehicleGrade(rawValue: VehicleGrade(rawValue: battteryHealth?.grade ?? "N/A" )?.title ??  "N/A") ?? .A, health: battteryHealth?.health ?? "N/A", rangeAtBirth: rangeAtBirth, minEstimatedRnge: minRange, maxEstimatedRnge: maxRange, bmsCapacity: submittedBms ?? 0.0)
			vc.viewModel = vm
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	func shortProfileCommandExecutionError() {
		print("short profile error")
		showDataInsufficientError()
	}
}

extension UploadAnimationViewController: BLENonResponsiveDelegate {
	func recordFirstNonResponsiveBleAttempt() {
		if let veh = viewModel?.vehicleInfo {
			let paramDictionary = [
				Parameters.year: "\(String(describing: veh.year))", Parameters.make : veh.make ?? "", Parameters.model:  veh.modelName ?? "", Parameters.trim: veh.trimName ?? "", Parameters.vinNumber: veh.vin ?? "", Parameters.locationCode: "\(self.viewModel?.locationCode ?? "")" ]  as [String : String]
			FirebaseLogging.instance.logEvent(eventName:RetryPingEvents.retryDeviceNotResponded, parameters: paramDictionary)
		}
	}
	
	func showBleNonResponsiveError() {
		if let veh = viewModel?.vehicleInfo {
			let paramDictionary = [
				Parameters.year: "\(String(describing: veh.year))", Parameters.make : veh.make ?? "", Parameters.model:  veh.modelName ?? "", Parameters.trim: veh.trimName ?? "", Parameters.vinNumber: veh.vin ?? "", Parameters.locationCode: "\(self.viewModel?.locationCode ?? "")"]  as [String : String]
			FirebaseLogging.instance.logEvent(eventName:RetryPingEvents.maxRetriesDeviceNotResponded, parameters: paramDictionary)
		}
		self.stackView.removeFromSuperview()
		let dialogMessage = UIAlertController(title: "Error", message: "OBD2 device is not responding. Please retry the test.", preferredStyle: .alert)
		let ok = UIAlertAction(title: "GOT IT", style: .default, handler: { (action) -> Void in
			if let pheriPheral = Network.shared.myPeripheral {
				Network.shared.bluetoothService?.disconnectDevice(peripheral: pheriPheral)
			}
			self.navigationController?.popToRootViewController(animated: true)
		})
		dialogMessage.addAction(ok)
		self.present(dialogMessage, animated: true, completion: nil)
	}
	
}
