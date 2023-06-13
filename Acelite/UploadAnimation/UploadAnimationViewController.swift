//
//  UploadAnimationViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/6/23.
//

import Foundation
import UIKit
import FirebaseDatabase

class UploadAnimationViewController: UIViewController {
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
	public var viewModel: UploadAnimationViewModel?
	public var vehicleInfo: Vehicle?
	
	private let notificationCenter = NotificationCenter.default
	//==========================
	public var packVoltageData = [Double]()
	public var packCurrentData = [Double]()
	public var packTemperatureData = [Double]()
	public var cellVoltageData = [Double]()
	public var stateOfCharge: Double?
	public var odometer: Double?
	public var currentEnerygy: Double?
	public var numberofCells: Int?
	public var multiCellVoltageData = [[Double]]()
	public var bmsCapacity: Double?
	public var testInstructionsId: String?
	public var workOrder: String?
	private var transactionId: String?
	private var healthScore: String?
	var csvDispatchGroup = DispatchGroup()
	var preSignedData: GetS3PreSingedURL?
	var textCommands = ""
	//var gradeTest:VehicleGrade = .C
	public var sampledCommandsList = [TestCommandExecution]()
	//========================
	
	
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
		print("upload animation VC")
		print(Date(), "upload animation VC", to: &Log.log)
		navigationItem.hidesBackButton = true
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 21))
		label.center = CGPoint(x: 220, y: 150)
		label.textAlignment = .center
		//label.translatesAutoresizingMaskIntoConstraints = false
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
		self.getTransectionId()
		//self.notificationCenter.addObserver(self, selector: #selector(navigateToHealthS), name: NSNotification.Name.init(rawValue: "GotAllData"), object: nil)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.animate()
		
	}
	@objc func navigateToHealthS() {
		print(Date(), "upload animation VC", to: &Log.log)
		Network.shared.bluetoothService?.disconnectDevice(peripheral: Network.shared.myPeripheral)
		self.getTransectionId()
	}
	
	func getTransectionId()  {
		
		//TO-DO guard
		
		Network.shared.apollo.fetch(query: GetS3PreSingedUrlQuery(vin: vehicleInfo?.vin ?? "")) { result in
			// 3
			switch result {
				
			case .success(let graphQLResult):
				guard let _ = try? result.get().data else { return }
				if graphQLResult.data != nil {
					
					let getS3PreSingedData = graphQLResult.data?.resultMap["getS3PreSingedURL"]?.jsonValue//getS3PreSingedUrl
					var preSignedData : Data?
					do {
						preSignedData = try JSONSerialization.data(withJSONObject: getS3PreSingedData as Any)
					} catch {
						//print("Unexpected error: \(error).")
						print(Date(), "Unexpected error: \(error).", to: &Log.log)
						FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.s3PreSignedUrlError, parameters: nil)
					}
					
					do {
						let decoder = JSONDecoder()
						let preSignedResponse = try decoder.decode(GetS3PreSingedURL.self, from: preSignedData!)
						self.transactionId = preSignedResponse.transactionID
						self.preSignedData = preSignedResponse
						print(Date(), "preSignedResponse.", to: &Log.log)
						self.preparingLogicForCSVFileGeration()
						FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.s3PreSignedUrlSuccess, parameters: nil)
					} catch DecodingError.dataCorrupted(let context) {
						//print(context)
						print(Date(), "preSignedResponse Error", to: &Log.log)
						FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.s3PreSignedUrlError, parameters: nil)
					} catch DecodingError.keyNotFound(let key, let context) {
						print("Key '\(key)' not found:", context.debugDescription)
						print("codingPath:", context.codingPath)
						print(Date(), "preSignedResponse Error", to: &Log.log)
						FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.s3PreSignedUrlError, parameters: nil)
					} catch DecodingError.valueNotFound(let value, let context) {
						//print("Value '\(value)' not found:", context.debugDescription)
						print("codingPath:", context.codingPath)
						print(Date(), "preSignedResponse Error", to: &Log.log)
						FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.s3PreSignedUrlError, parameters: nil)
					} catch DecodingError.typeMismatch(let type, let context) {
						print("Type '\(type)' mismatch:", context.debugDescription)
						print("codingPath:", context.codingPath)
						print(Date(), "preSignedResponse Error", to: &Log.log)
						FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.s3PreSignedUrlError, parameters: nil)
					} catch {
						print("error: ", error)
						print(Date(), "preSignedResponse Error", to: &Log.log)
						FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.s3PreSignedUrlError, parameters: nil)
					}
				}
				
			case .failure(let error):
				// 5
				//self.preSignedDelegate?.handleErrorTransactionID()
				print("Error loading data \(error)")
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
				//print("after process result count", result.count)
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
		
		csvFileUploadingIntoS3Bucket(fileName: pack_CurrentFilePath.absoluteString)
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
		csvFileUploadingIntoS3Bucket(fileName: pack_VoltageFilePath.absoluteString)
		let paramDictionary = [
		   "file_type": "PACK_VOLTAGE"
		  ]
		FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.uploadFileSuccess, parameters: paramDictionary)
	}
	
	// MARK: Create Cell Voltage CSV
	func createCellVoltageCSV(data: [[Double]]) {
		//print("cell-Voltage", data)
		print(Date(), "Uploading CellVoltageCSV", to: &Log.log)
		//let fileName = self.creatCSV(data: data)
		let cell_voltage = CSVFile(fileName: "Cell_Volt_\(self.vehicleInfo?.vin ?? "")")
		csvDispatchGroup.enter()
		let cellVoltageFilePath = cell_voltage.createMultiframeCSV(data: data)
		csvFileUploadingIntoS3Bucket(fileName: cellVoltageFilePath.absoluteString)
		let paramDictionary = [
		   "file_type": "CELL_VOLTAGE"
		  ]
		FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.uploadFileSuccess, parameters: paramDictionary)
	}
	
	
	
	func csvFileUploadingIntoS3Bucket(fileName: String) {
		print(Date(), "Uploading csvFileUploadingIntoS3Bucket", to: &Log.log)
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
		//print("Data::>", data)
		multipart.add(
			key: "file",
			fileName: "\(fileName)",
			fileMimeType: "text/csv",
			fileData: data
		)
		
		//print("**************************************")
		//print("file name", fileName)
		let dataOfThefile = String(data: data, encoding: .utf8)
		//print("dataOfThefile", dataOfThefile as Any)
		//print("**************************************")
		
		
		/// Create a regular HTTP URL request & use multipart components
		let url = URL(string: "\(presinedData.url)")!
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue(multipart.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
		request.httpBody = multipart.httpBody
		
		/// Fire the request using URL sesson or anything else...
		let session =  URLSession.shared
		let dataTask = session.dataTask(with: request) { data, response, error in
			self.csvDispatchGroup.leave()
			guard let _ = data else {
				print("presinedData json data response Error")
				print(Date(), "presinedData json data response Error", to: &Log.log)
				return
			}
			
			self.csvDispatchGroup.notify(queue: .main) {
				if fileName.contains("Cell_Volt") {
					print(Date(), "file uploaded succesfully...", to: &Log.log)
					print("file uploaded succesfully...")
					guard let testCommand = self.vehicleInfo?.getBatteryTestInstructions, testCommand.count > 0 else {
						return
					}
					for command in testCommand {
						let stateOfCharge = command.testCommands?.stateOfHealthCommands?.stateOfCharge
						if self.currentReachabilityStatus != .notReachable {
							if stateOfCharge != nil {
								self.submitBatteryDataFileWithSOCGraphRequest()
							} else {
								self.submitBatteryDataFileWithBMSGraphRequest()
							}
						} else {
							self.stackView.removeFromSuperview()
							let alertViewController = UIAlertController.init(title: "Oops!", message: "Please check your network connection", preferredStyle: .alert)
							let ok = UIAlertAction(title: "Retry", style: .default, handler: { (action) -> Void in
								self.view.addSubview(self.stackView)
								if stateOfCharge != nil {
									self.submitBatteryDataFileWithSOCGraphRequest()
								} else {
									self.submitBatteryDataFileWithBMSGraphRequest()
								}

							})
							alertViewController.addAction(ok)
							self.present(alertViewController, animated: true, completion: nil)
						}
					}
				}
				
			}
		}
		dataTask.resume()
	}
	
	func saveLogsIntoTxtFile() -> String {
		print("Logs::::", self.textCommands)
		if self.textCommands.count > 2 {
			let text = self.textCommands
			let folder = "Acelite"
			let timeStamp = Date.currentTimeStamp
			let fileNamed = "\(timeStamp)"
			guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return  ""}
			guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else { return ""}
			try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
			let file = writePath.appendingPathComponent(fileNamed + ".txt")
			//print("file path:::", file)
			try? text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
			// alert
			//
			// generated file stored in your phone file folder with app name.
			//print("file path:::", file)
			return file.absoluteString
		} else {
			// alert logs not generated
			//print("logs not generated")
			return ""
		}
	}
	
	private func submitBatteryDataFileWithSOCGraphRequest() {
		print(Date(), "submitBatteryDataFileWithSOCGraphRequest", to: &Log.log)
		guard let veh = vehicleInfo else {return}
		guard let vinInfo = vehicleInfo?.vin else { return  }
		guard let vinMake = vehicleInfo?.make else { return  }
		guard let vinYear = vehicleInfo?.year else {return}
		guard let vinModels = vehicleInfo?.modelName else {return}
		let years: Int = Int(vinYear)
		
		
		let vehicalBatteryDataFile = SubmitBatteryDataFilesVehicleInput.init(vin: vinInfo, make: vinMake, model: vinModels, year: years)
		let batteryInstr = vehicleInfo?.getBatteryTestInstructions
		//Vehicle Profile
		guard let vehicleProfile = batteryInstr?[0].testCommands?.vehicleProfile else {
			print(Date(), "SOC:Submit API failed due to Vehicle Profile", to: &Log.log)
			self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:Submit API failed due to Vehicle Profile", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinModels, year: years)
			return}
		print(Date(), "SOC:Vehicle Profile\(vehicleProfile)", to: &Log.log)
		
		//State of Health
		guard let stateOfHealth = batteryInstr?[0].testCommands?.stateOfHealthCommands else {
			print(Date(), "SOC:Submit API failed due to state Of Health", to: &Log.log)
			self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:Submit API failed due to state Of Health", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinModels, year: years)
			return}
		print(Date(), "SOC:State of Health\(stateOfHealth)", to: &Log.log)
		
		//Nominal Volatage
		guard let nominalVoltage: Double = vehicleProfile.nominalVoltage else {
			print(Date(), "SOC:Submit API failed due to Nominal Volatge", to: &Log.log)
			self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:Submit API failed due to Nominal Volatge", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinModels, year: years)
			return  }
		print(Date(), "SOC:Nominal Voltage\(nominalVoltage)", to: &Log.log)
		
		//EnergyAtBirth
		guard let energyAtBirth: Double = vehicleProfile.energyAtBirth else {
			print(Date(), "SOC:Submit API failed due to state Of energyAtBirth", to: &Log.log)
			self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:Submit API failed due to state Of energyAtBirth", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinModels, year: years)
			return  }
		print(Date(), "SOC:energyAtBirth\(energyAtBirth)", to: &Log.log)
		
		//CapacityAtBirth
		guard let capacityAtBirth: Double = vehicleProfile.capacityAtBirth else {
			print(Date(), "SOC:Submit API failed due to state Of capacityAtBirth", to: &Log.log)
			self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:Submit API failed due to state Of capacityAtBirth", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinModels, year: years)
			return}
		print(Date(), "SOC:capacityAtBirth\(capacityAtBirth)", to: &Log.log)
		
		//Battery
		guard let batteryType: String = vehicleProfile.batteryType else {
			print(Date(), "SOC:Submit API failed due to BatteryType", to: &Log.log)
			self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:Submit API failed due to state Of capacityAtBirth", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinModels, year: years)
			return}
		print(Date(), "SOC:BatteryType\(batteryType)", to: &Log.log)
		
		//pass the battery from vehicle
		let submitBatteryDataVehicleProfileInput = SubmitBatteryDataVehicleProfileInput(nominalVoltage: nominalVoltage, energyAtBirth: energyAtBirth, batteryType: BatteryType(rawValue: batteryType) ?? .lithium, capacityAtBirth: capacityAtBirth)
		
		//VV imp piece
		let stateOfChargePropsInput = StateOfChargePropsInput(stateOfCharge: self.stateOfCharge ?? 0, currentEnergy: self.currentEnerygy ?? 0)
		print(Date(), "SOC:stateOfCharge\(self.stateOfCharge ?? 0)", to: &Log.log)
		print(Date(), "SOC:currentEnergy\(self.currentEnerygy ?? 0)", to: &Log.log)
		
		let submitBatteryDataFilesPropsInput = SubmitBatteryDataFilesPropsInput(locationCode: LocationCode(rawValue: "AAA"), odometer: Int(self.odometer ?? 0), packVoltageFilename: "Pack_Voltage_\(vinInfo).csv", packCurrentFilename: "Pack_Current_\(vinInfo).csv", cellVoltagesFilename: "Cell_Volt_\(vinInfo).csv", transactionId: self.preSignedData!.transactionID, vehicleProfile: submitBatteryDataVehicleProfileInput)
		print(Date(), "SOC:submit battery data file props input: odometer \(Int(self.odometer ?? 0))", to: &Log.log)
		print(Date(), "SOC:Transaction ID\(self.preSignedData!.transactionID)", to: &Log.log)

		let mutation = SubmitBatteryFilesWithStateOfChargeMutation(Vehicle:vehicalBatteryDataFile, submitBatteryDataFilesProps: submitBatteryDataFilesPropsInput, stateOfChargeProps: stateOfChargePropsInput)

		Network.shared.apollo.perform(mutation: mutation) { result in
			
			switch result {
			case .success(let graphQLResults):
				guard let data = try? result.get().data else { return }
				//print("data ::", data)
				if graphQLResults.data != nil {
					if graphQLResults.errors?.count ?? 0 > 0 {
						//print("Error::", graphQLResults.errors!)
						print(Date(), "SOC:submit API Error :\(String(describing: graphQLResults.errors))", to: &Log.log)
						self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:submit API Error :\(String(describing: graphQLResults.errors))", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinModels, year: years)
						return
					}
					let submitData =  graphQLResults.data?.resultMap["submitBatteryDataFilesWithStateOfCharge"]
					if submitData == nil {
						print(Date(), "SOC:submit API result Map Error :\(String(describing: graphQLResults.errors))", to: &Log.log)
						self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "\(String(describing: graphQLResults.errors))", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinModels, year: years)
						let paramDictionary = [
						   "submit_type": "STATE_OF_CHARGE",
						   "batter_test_instructions_id": "\(String(describing: self.testInstructionsId))",
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
								let submitBatteryData = try decoder.decode(SubmitBatteryDataFilesWithStateOfCharge.self, from: preSignedData)
								print(Date(), "SOC:submit API Decode Sucessful :\(String(describing: submitBatteryData))", to: &Log.log)
								if submitBatteryData.batteryScore == nil {
									print(Date(), "SOC:battery Score is Null :\(String(describing: graphQLResults.errors))", to: &Log.log)
									self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "Battery Score is Null", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinModels, year: years)
									return
								} else {
									let storyBaord = UIStoryboard.init(name: "Main", bundle: nil)
									let vc = storyBaord.instantiateViewController(withIdentifier: "BatteryHealthViewController") as! BatteryHealthViewController
									self.submitSuccessForSubmitAPI(transactionID: self.transactionId ?? "", vinMake: vinMake, score: "\(submitBatteryData.batteryScore?.score ?? 0)", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinInfo, year: vinYear)
									let vm = BatteryHealthViewModel(vehicleInfo: veh, transactionID: self.transactionId ?? "", testIntructionsId: self.testInstructionsId ?? "", healthScore: submitBatteryData.batteryScore?.score ?? 0.0, grade: VehicleGrade(rawValue: VehicleGrade(rawValue: submitBatteryData.batteryScore?.grade ?? "N/A")?.title ??  "N/A") ?? .A, health: submitBatteryData.batteryScore?.health ?? "N/A")
									
									vc.viewModel = vm
									self.navigationController?.pushViewController(vc, animated: true)
								}
							
								
							} catch DecodingError.dataCorrupted(let context) {
								//print(context)
								print(Date(), "SOC:submit API Error :\(context)", to: &Log.log)
								self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:submit API Error :\(context)", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinModels, year: years)
								return
							}
						} catch {
							self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:submit API Error :\(error)", vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinModels, year: years)
							print(Date(), "SOC:submit API Error :\(error)", to: &Log.log)
							//print("Unexpected error: \(error).")
						}
						
					}
				} else {
					
				}
				break
			case .failure(let error):
				if let transactionId = self.preSignedData?.transactionID {
					self.showSubmitAPIError(transactionID: transactionId , vinMake: vinMake, message: error.localizedDescription, vinModels: vinModels, submitType: "STATE_OF_CHARGE", vinNumber: vinModels, year: years)
				}
				print(Date(), "SOC:submit API Error :\(error)", to: &Log.log)
				break
			}
			
		}
		
	}
	
	private func submitBatteryDataFileWithBMSGraphRequest() {
		print(Date(), "submitBatteryDataFileWithBMSGraphRequest", to: &Log.log)
		guard let veh = vehicleInfo else {return}
		guard let vinInfo = vehicleInfo?.vin else { return  }
		guard let vinMake = vehicleInfo?.make else { return  }
		guard let vinYear = vehicleInfo?.year else {return}
		guard let vinModels = vehicleInfo?.modelName else {return}
		let years: Int = Int(vinYear)
		
		
		let vehicalBatteryDataFile = SubmitBatteryDataFilesVehicleInput.init(vin: vinInfo, make: vinMake, model: vinModels, year: years)
		let batteryInstr = vehicleInfo?.getBatteryTestInstructions
		//vehicle profile
		guard let vehicleProfile = batteryInstr?[0].testCommands?.vehicleProfile else {
			print(Date(), "BMS:Submit API failed due to Vehicle Profile", to: &Log.log)
			self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "BMS:Submit API failed due to Vehicle Profile", vinModels: vinModels, submitType: "BMS_CAPACITY", vinNumber: vinModels, year: years)
			return }
		print(Date(), "Vehicle Profile\(vehicleProfile)", to: &Log.log)
		
		//stateOfHealth
		guard let stateOfHealth = batteryInstr?[0].testCommands?.stateOfHealthCommands else {
			print(Date(), "BMS:Submit API failed due to stateOfHealth", to: &Log.log)
			self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "BMS:Submit API failed due to stateOfHealth", vinModels: vinModels, submitType: "BMS_CAPACITY", vinNumber: vinModels, year: years)
			return
		}
		print(Date(), "BMS:stateOfHealth\(stateOfHealth)", to: &Log.log)
		
		//NominalVoltage
		guard let nominalVoltage: Double = vehicleProfile.nominalVoltage else {
			print(Date(), "BMS:Submit API failed due to Nominal Voltage", to: &Log.log)
			self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "BMS:Submit API failed due to Nominal Voltage", vinModels: vinModels, submitType: "BMS_CAPACITY", vinNumber: vinModels, year: years)
			return
		}
		print(Date(), "BMS:Nominal Voltage\(nominalVoltage)", to: &Log.log)
		
		//Energy AT Birth
		guard let energyAtBirth: Double = vehicleProfile.energyAtBirth else {
			print(Date(), "BMS: Submit API failed due to Energy At Birth", to: &Log.log)
			self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "BMS: Submit API failed due to Energy At Birth", vinModels: vinModels, submitType: "BMS_CAPACITY", vinNumber: vinModels, year: years)
			return
		}
		print(Date(), " Energy At Birth\(energyAtBirth)", to: &Log.log)
		
		//Capacity At Birth
		guard let capacityAtBirth: Double = vehicleProfile.capacityAtBirth else {
			print(Date(), "BMS: Submit API failed due to Capacity At Birth", to: &Log.log)
			self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "SOC:Submit API failed due to Vehicle Profile", vinModels: vinModels, submitType: "BMS_CAPACITY", vinNumber: vinModels, year: years)
			return
		}
		print(Date(), "BMS:Capacity At Birth\(capacityAtBirth)", to: &Log.log)
		
		//BMS Capacity
		guard let bmsCapacitys: Double = self.bmsCapacity else {
			print(Date(), "BMS:Submit API failed due to BMS", to: &Log.log)
			self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "BMS:Submit API failed due to BMS", vinModels: vinModels, submitType: "BMS_CAPACITY", vinNumber: vinModels, year: years)
			return}
		print(Date(), "BMS Value\(bmsCapacitys)", to: &Log.log)
		
		let submitBatteryDataVehicleProfileInput = SubmitBatteryDataVehicleProfileInput(nominalVoltage: nominalVoltage, energyAtBirth: energyAtBirth, batteryType: BatteryType.lithium, capacityAtBirth: capacityAtBirth)
		
		let bmsCapacityPropsInput = BMSCapacityPropsInput(bmsCapacity: bmsCapacitys)
		
		let submitBatteryDataFilesPropsInput = SubmitBatteryDataFilesPropsInput(locationCode: LocationCode.aaa, odometer: Int(self.odometer ?? 0), packVoltageFilename: "Pack_Voltage_\(vinInfo).csv", packCurrentFilename: "Pack_Current_\(vinInfo).csv", cellVoltagesFilename: "Cell_Volt_\(vinInfo).csv", transactionId: self.preSignedData!.transactionID, vehicleProfile: submitBatteryDataVehicleProfileInput)
		
		print(Date(), "BMS:submit battery data file props input: odometer \(Int(self.odometer ?? 0))", to: &Log.log)
		print(Date(), "BMS:Transaction ID\(self.preSignedData!.transactionID)", to: &Log.log)
		
		let mutation = SubmitBatteryDataFilesWithBmsCapacityMutation(Vehicle: vehicalBatteryDataFile, submitBatteryDataFilesProps: submitBatteryDataFilesPropsInput, bmsCapacityProps: bmsCapacityPropsInput)
		
		
		Network.shared.apollo.perform(mutation: mutation) { result in
			switch result {
			case .success(let graphQLResults):
				guard let data = try? result.get().data else { return }
				//print("data ::", data)
				if graphQLResults.data != nil {
					if graphQLResults.errors?.count ?? 0 > 0 {
						//print("Error::", graphQLResults.errors!)
						print(Date(), "BMS:submit API Error :\(String(describing: graphQLResults.errors))", to: &Log.log)
						//TODO Stop Animation and show alert
						self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "BMS:submit API Error :\(String(describing: graphQLResults.errors))", vinModels: vinModels, submitType: "BMS_CAPACITY", vinNumber: vinModels, year: years)
						let paramDictionary = [
						   "submit_type": "BMS_CAPACITY",
						   "batter_test_instructions_id": "\(String(describing: self.testInstructionsId))",
						   "errorCode": "\(String(describing: graphQLResults.errors))",
						   "work_order": "\(String(describing: self.workOrder))"]
						FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.submitBatteryFilesError, parameters: paramDictionary)
						return
					}
					let submitData =  graphQLResults.data?.resultMap["submitBatteryDataFilesWithBmsCapacity"].jsonValue
					if submitData == nil {
						self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "BMS:submit API Result Map error :\(String(describing: submitData))", vinModels: vinModels, submitType: "BMS_CAPACITY", vinNumber: vinModels, year: years)
						print(Date(), "BMS:submit API Result Map error :\(String(describing: submitData))", to: &Log.log)
						return
					} else {
						let jsonObject = submitData.jsonValue
						print("submited battery data", jsonObject)
						print(Date(), "BMS:submit Battery Data succesfully :\(String(describing: jsonObject))", to: &Log.log)
						//getS3PreSingedUrl
						//var preSignedData : Data?
						do {
							let  preSignedData = try JSONSerialization.data(withJSONObject: jsonObject)
							do {
								let decoder = JSONDecoder()
								let submitBatteryData = try decoder.decode(SubmitBatteryDataFilesWithStateOfCharge.self, from: preSignedData)
								print("submit battery data::",submitBatteryData)
								print(Date(), "BMS:submit API Decode Sucessful :\(String(describing: submitBatteryData))", to: &Log.log)
								if submitBatteryData.batteryScore != nil {
									let storyBaord = UIStoryboard.init(name: "Main", bundle: nil)
									let vc = storyBaord.instantiateViewController(withIdentifier: "BatteryHealthViewController") as! BatteryHealthViewController
									self.submitSuccessForSubmitAPI(transactionID: self.transactionId ?? "", vinMake: vinMake, score: "\(submitBatteryData.batteryScore?.score ?? 0)", vinModels: vinModels, submitType: "BMS_Capacity", vinNumber: vinInfo, year: vinYear)
									let vm = BatteryHealthViewModel(vehicleInfo: veh, transactionID: self.transactionId ?? "", testIntructionsId: self.testInstructionsId ?? "", healthScore: submitBatteryData.batteryScore?.score ?? 0, grade: VehicleGrade(rawValue: VehicleGrade(rawValue: submitBatteryData.batteryScore?.grade ?? "N/A")?.title ??  "N/A") ?? .A, health: submitBatteryData.batteryScore?.health ?? "N/A")
									
									vc.viewModel = vm
									self.navigationController?.pushViewController(vc, animated: true)
								} else {
									self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "BMS:submit API Result Battery Score is Null", vinModels: vinModels, submitType: "BMS_CAPACITY", vinNumber: vinModels, year: years)
									print(Date(), "BMS:BMS:submit API Result Battery Score is Null", to: &Log.log)
									return
									
								}
							
							} catch DecodingError.dataCorrupted(let context) {
								self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "BMS:submit API error :\(context)", vinModels: vinModels, submitType: "BMS_CAPACITY", vinNumber: vinModels, year: years)
								print(Date(), "BMS:submit API error :\(context)", to: &Log.log)
								print(context)
								return
							}
						} catch {
							self.showSubmitAPIError(transactionID: self.transactionId ?? "N/A", vinMake: vinMake, message: "BMS:submit API error :\(error)", vinModels: vinModels, submitType: "BMS_CAPACITY", vinNumber: vinModels, year: years)
							print(Date(), "BMS:submit API error :\(error)", to: &Log.log)
							print("Unexpected error: \(error).")
						}
						
					}
				} else {
					
				}
				break
			case .failure(let error):
				if let transactionId = self.preSignedData?.transactionID {
					print(Date(), "BMS:submit API error :\(error)", to: &Log.log)
					self.showSubmitAPIError(transactionID: transactionId, vinMake: vinMake, message: "BMS:submit API error :\(error)", vinModels: vinModels, submitType: "BMS_CAPACITY", vinNumber: vinModels, year: years)
				}
				break
			}
			
		}
		
	}
	
	func submitSuccessForSubmitAPI(transactionID: String, vinMake: String, score: String, vinModels: String, submitType: String, vinNumber: String, year: Int) {
		let paramDictionary = [
		   "submit_type": submitType,
		   "batter_test_instructions_id": "\(String(describing: self.testInstructionsId))",
		   "work_order": "\(String(describing: self.workOrder))"]
		FirebaseLogging.instance.logEvent(eventName:TestInstructionsScreenEvents.submitBatteryFilesSuccess, parameters: paramDictionary)
		let rootRef = Database.database().reference()
		let ref = rootRef.child("successful_transaction_ids").childByAutoId()
		//if let batteryInstr =
		let vinBatteryInfo: [String: String?] = ["battery_test_instructions_id": self.testInstructionsId,"make": vinMake, "score": score, "model": vinModels, "platform": "iOS", "submit_type": submitType, "time_stamp": Constants().currentDateTime(), "transaction_id": transactionID, "vin_number": vinNumber, "year": String(year), "work_order": "\(String(describing: self.workOrder))"]
		ref.setValue(vinBatteryInfo) {
			(error:Error?, ref:DatabaseReference) in
			if let error = error {
				//print("Data could not be saved: \(error).")
			} else {
				//print("Fail data saved successfully!")
			}
		}
	}
	
	func showSubmitAPIError(transactionID: String, vinMake: String, message: String, vinModels: String, submitType: String, vinNumber: String, year: Int) {
		let rootRef = Database.database().reference()
		let ref = rootRef.child("submit_error_details").childByAutoId()
		//if let batteryInstr =
		let vinBatteryInfo: [String: String?] = ["battery_test_instructions_id": self.testInstructionsId,"make": vinMake, "message": message, "model": vinModels, "platform": "iOS", "submit_type": submitType, "time_stamp": Constants().currentDateTime(), "transaction_id": transactionID, "vin_number": vinNumber, "year": String(year), "work_order": "\(String(describing: self.workOrder))"]
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
		// Create OK button with action handler
		let ok = UIAlertAction(title: "GOT IT", style: .default, handler: { (action) -> Void in
			guard let viewControllers = self.navigationController?.viewControllers else {
				return
			}
			for workOrderVc in viewControllers {
				if workOrderVc is WorkOrderViewController {
					self.navigationController?.popToViewController(workOrderVc, animated: true)
					break
				}
			}
		})
		//Add OK button to a dialog message
		dialogMessage.addAction(ok)
		// Present Alert to
		self.present(dialogMessage, animated: true, completion: nil)
	}
	
	func showDataInsufficientError() {
		let rootRef = Database.database().reference()
		let ref = rootRef.child("submit_error_details").childByAutoId()
		//if let batteryInstr =
		let vinBatteryInfo: [String: String?] = ["battery_test_instructions_id": self.testInstructionsId,"make": "", "message": "Min Count of the Data Files Not Fullfilled", "model": "", "platform": "iOS", "submit_type": "", "time_stamp": Constants().currentDateTime(), "transaction_id": self.transactionId, "vin_number": "", "year": "","work_order": "\(String(describing: self.workOrder))"]
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
		// Create OK button with action handler
		let ok = UIAlertAction(title: "GOT IT", style: .default, handler: { (action) -> Void in
			guard let viewControllers = self.navigationController?.viewControllers else {
				return
			}
			for workOrderVc in viewControllers {
				if workOrderVc is WorkOrderViewController {
					self.navigationController?.popToViewController(workOrderVc, animated: true)
					break
				}
			}
		})
		//Add OK button to a dialog message
		dialogMessage.addAction(ok)
		// Present Alert to
		self.present(dialogMessage, animated: true, completion: nil)
		
	}
}

