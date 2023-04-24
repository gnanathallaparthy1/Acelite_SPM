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
	public var numberofCells: Int?
	public var multiCellVoltageData = [[Double]]()
	public var bmsCapacity: Double?
	private var odometer: Double?
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
		navigationItem.hidesBackButton = true
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 21))
		label.center = CGPoint(x: 220, y: 150)
		label.textAlignment = .center
		//label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "UPLOADING DATA..."
		label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
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
		self.notificationCenter.addObserver(self, selector: #selector(navigateToHealthS), name: NSNotification.Name.init(rawValue: "GotAllData"), object: nil)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.animate()
		
	}
	@objc func navigateToHealthS() {
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
						print("Unexpected error: \(error).")
					}
					
					do {
						let decoder = JSONDecoder()
						let preSignedResponse = try decoder.decode(GetS3PreSingedURL.self, from: preSignedData!)
						self.transactionId = preSignedResponse.transactionID
						self.preSignedData = preSignedResponse
						self.preparingLogicForCSVFileGeration()
					} catch DecodingError.dataCorrupted(let context) {
						print(context)
					} catch DecodingError.keyNotFound(let key, let context) {
						print("Key '\(key)' not found:", context.debugDescription)
						print("codingPath:", context.codingPath)
					} catch DecodingError.valueNotFound(let value, let context) {
						print("Value '\(value)' not found:", context.debugDescription)
						print("codingPath:", context.codingPath)
					} catch DecodingError.typeMismatch(let type, let context) {
						print("Type '\(type)' mismatch:", context.debugDescription)
						print("codingPath:", context.codingPath)
					} catch {
						print("error: ", error)
					}
				}
				
			case .failure(let error):
				// 5
				//self.preSignedDelegate?.handleErrorTransactionID()
				print("Error loading data \(error)")
			}
		}
	}
	
	func preparingLogicForCSVFileGeration() {
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
				print("after process result count", result.count)
			}
			let listCount: [Int] = [result.count,  self.packCurrentData.count, self.packVoltageData.count]
			 minVlaue = listCount.min() ?? 0
			print("min value from count array", minVlaue)
			let finalCellVoltage = result[0...minVlaue - 1]
			self.createCellVoltageCSV(data: Array(finalCellVoltage))
		} else {
			let listCount: [Int] = [multiCellVoltageData.count,  self.packCurrentData.count, self.packVoltageData.count]
			 minVlaue = listCount.min() ?? 0
			let finalCellVoltage = multiCellVoltageData[0...minVlaue - 1]
			self.createCellVoltageCSV(data: Array(finalCellVoltage))
		}
		//TO-DO handle zero size
		let finalPackCurrent = packCurrentData[0...minVlaue - 1]
		self.createPackCurrentCSVFile(data: Array(finalPackCurrent))
		let finalPackVoltage = packVoltageData[0...minVlaue - 1]
		createPackVoltageCSV(data: Array(finalPackVoltage))
	}
	
	//MARK: Create pack current CSV
	func createPackCurrentCSVFile(data: [Double] ) {
		
		
		let pack_Current = CSVFile(fileName: "Pack_Current_\(self.vehicleInfo?.vin ?? "")")
		let pack_CurrentFilePath = pack_Current.creatCSVForArray(data: data)
		csvDispatchGroup.enter()
		
		csvFileUploadingIntoS3Bucket(fileName: pack_CurrentFilePath.absoluteString)
	}
	
	// MARK: Create pack voltage CSV
	func createPackVoltageCSV(data: [Double]) {
		
		let pack_Voltage = CSVFile(fileName: "Pack_Voltage_\(self.vehicleInfo?.vin ?? "")")
		
		csvDispatchGroup.enter()
		let pack_VoltageFilePath = pack_Voltage.creatCSVForArray(data: data)
		csvFileUploadingIntoS3Bucket(fileName: pack_VoltageFilePath.absoluteString)
	}
	
	// MARK: Create Cell Voltage CSV
	func createCellVoltageCSV(data: [[Double]]) {
		print("cell-Voltage", data)
		//let fileName = self.creatCSV(data: data)
		let cell_voltage = CSVFile(fileName: "Cell_Volt_\(self.vehicleInfo?.vin ?? "")")
		csvDispatchGroup.enter()
		let cellVoltageFilePath = cell_voltage.createMultiframeCSV(data: data)
		csvFileUploadingIntoS3Bucket(fileName: cellVoltageFilePath.absoluteString)
	}
	

	
	func csvFileUploadingIntoS3Bucket(fileName: String) {
		
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
		print("Data::>", data)
		multipart.add(
			key: "file",
			fileName: "\(fileName)",
			fileMimeType: "text/csv",
			fileData: data
		)
		
		print("**************************************")
		print("file name", fileName)
		let dataOfThefile = String(data: data, encoding: .utf8)
		print("dataOfThefile", dataOfThefile as Any)
		print("**************************************")
		
		
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
				print("json data response Error")
				return
			}
			
			self.csvDispatchGroup.notify(queue: .main) {
				if fileName.contains("Cell_Volt") {
					print("file uploaded succesfully...")
					guard let testCommand = self.vehicleInfo?.getBatteryTestInstructions, testCommand.count > 0 else {
						return
					}
					for command in testCommand {
						let stateOfCharge = command.testCommands?.stateOfHealthCommands?.stateOfCharge
						if stateOfCharge != nil {
							self.submitBatteryDataFileWithSOCGraphRequest()
						} else {
							self.submitBatteryDataFileWithBMSGraphRequest()
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
			print("file path:::", file)
			try? text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
			// alert
			//
			// generated file stored in your phone file folder with app name.
			print("file path:::", file)
			return file.absoluteString
		} else {
			// alert logs not generated
			print("logs not generated")
			return ""
		}
	}
	
	private func submitBatteryDataFileWithSOCGraphRequest() {
		guard let vinInfo = vehicleInfo?.vin else { return  }
		guard let vinMake = vehicleInfo?.make else { return  }
		guard let vinYear = vehicleInfo?.year else {return}
		guard let vinModels = vehicleInfo?.modelName else {return}
		let years: Int = Int(vinYear)
		
		
		let vehicalBatteryDataFile = SubmitBatteryDataFilesVehicleInput.init(vin: vinInfo, make: vinMake, model: vinModels, year: years)
		let batteryInstr = vehicleInfo?.getBatteryTestInstructions
		
		guard let vehicleProfile = batteryInstr?[0].testCommands?.vehicleProfile else {return}
		guard let stateOfHealth = batteryInstr?[0].testCommands?.stateOfHealthCommands else {return}
		guard let nominalVoltage: Double = vehicleProfile.nominalVoltage else { return  }
		guard let energyAtBirth: Double = vehicleProfile.energyAtBirth else { return  }
		guard let capacityAtBirth: Double = vehicleProfile.capacityAtBirth else {return}
		let submitBatteryDataVehicleProfileInput = SubmitBatteryDataVehicleProfileInput(nominalVoltage: 245, energyAtBirth: 1.6, batteryType: BatteryType.lithium, capacityAtBirth: 6.5)
		
		let stateOfChargePropsInput = StateOfChargePropsInput(stateOfCharge: self.stateOfCharge ?? 3, currentEnergy: energyAtBirth)
		//"Cell_Volt_\(self.vehicleInfo?.vin ?? "")"
		//"Pack_Voltage_\(self.vehicleInfo?.vin ?? "")"
		print("State of charge", stateOfChargePropsInput)
		let submitBatteryDataFilesPropsInput = SubmitBatteryDataFilesPropsInput(locationCode: LocationCode(rawValue: "AAA"), odometer: Int(self.odometer ?? 5000), totalNumberOfCharges: 5, lifetimeCharge: 20.5, lifetimeDischarge: 10.5, packVoltageFilename: "Pack_Voltage_\(vinInfo).csv", packCurrentFilename: "Pack_Current_\(vinInfo).csv", cellVoltagesFilename: "Cell_Volt_\(vinInfo).csv", transactionId: self.preSignedData!.transactionID, vehicleProfile: submitBatteryDataVehicleProfileInput)
		print("sunmit battery data file props input :", submitBatteryDataFilesPropsInput)
		print("Transection: ID", self.preSignedData!.transactionID)
		
		let mutation = SubmitBatteryFilesWithStateOfChargeMutation(Vehicle:vehicalBatteryDataFile, submitBatteryDataFilesProps: submitBatteryDataFilesPropsInput, stateOfChargeProps: stateOfChargePropsInput)
		
		
		
		Network.shared.apollo.perform(mutation: mutation) { result in
			
			switch result {
			case .success(let graphQLResults):
				guard let data = try? result.get().data else { return }
				print("data ::", data)
				if graphQLResults.data != nil {
					if graphQLResults.errors?.count ?? 0 > 0 {
						print("Error::", graphQLResults.errors!)
						//TODO Stop Animation and show alert
						return
					}
					let submitData =  graphQLResults.data?.resultMap["submitBatteryDataFilesWithStateOfCharge"]
					if submitData == nil {
						return
					} else {
						let jsonObject = submitData.jsonValue
						do {
							let  preSignedData = try JSONSerialization.data(withJSONObject: jsonObject)
							do {
								let decoder = JSONDecoder()
								let submitBatteryData = try decoder.decode(SubmitBatteryDataFilesWithStateOfCharge.self, from: preSignedData)
								//print("submit battery data::",submitBatteryData)
								let storyBaord = UIStoryboard.init(name: "Main", bundle: nil)
								let vc = storyBaord.instantiateViewController(withIdentifier: "BatteryHealthViewController") as! BatteryHealthViewController
								if let vInfo = self.vehicleInfo,let grade = submitBatteryData.batteryScore?.grade,let health = submitBatteryData.batteryScore?.health  {
									let vm = BatteryHealthViewModel(vehicleInfo: vInfo, transactionID: self.transactionId ?? "", healthScore: health, grade: VehicleGrade(rawValue: VehicleGrade(rawValue: grade)?.title ??  "N/A") ?? .A)
									vc.viewModel = vm
								}
								self.navigationController?.pushViewController(vc, animated: true)
								
							} catch DecodingError.dataCorrupted(let context) {
								print(context)
								return
							}
						} catch {
							print("Unexpected error: \(error).")
						}
						
					}
				} else {
					
				}
				break
			case .failure(let error):
				break
			}
			
		}
		
	}
	
	private func submitBatteryDataFileWithBMSGraphRequest() {
		guard let vinInfo = vehicleInfo?.vin else { return  }
		guard let vinMake = vehicleInfo?.make else { return  }
		guard let vinYear = vehicleInfo?.year else {return}
		guard let vinModels = vehicleInfo?.modelName else {return}
		let years: Int = Int(vinYear)
		
		
		let vehicalBatteryDataFile = SubmitBatteryDataFilesVehicleInput.init(vin: vinInfo, make: vinMake, model: vinModels, year: years)
		let batteryInstr = vehicleInfo?.getBatteryTestInstructions
		
		guard let vehicleProfile = batteryInstr?[0].testCommands?.vehicleProfile else {return}
		guard let stateOfHealth = batteryInstr?[0].testCommands?.stateOfHealthCommands else {return}
		guard let nominalVoltage: Double = vehicleProfile.nominalVoltage else { return  }
		guard let energyAtBirth: Double = vehicleProfile.energyAtBirth else { return  }
		guard let capacityAtBirth: Double = vehicleProfile.capacityAtBirth else {return}
		guard let bmsCapacity: Double = self.bmsCapacity else {return}
		let submitBatteryDataVehicleProfileInput = SubmitBatteryDataVehicleProfileInput(nominalVoltage: nominalVoltage, energyAtBirth: energyAtBirth, batteryType: BatteryType.lithium, capacityAtBirth: capacityAtBirth)
		
		let bmsCapacityPropsInput = BMSCapacityPropsInput(bmsCapacity: bmsCapacity)
		let submitBatteryDataFilesPropsInput = SubmitBatteryDataFilesPropsInput(locationCode: LocationCode.aaa, odometer: 5000, totalNumberOfCharges: nil, lifetimeCharge: nil, lifetimeDischarge: nil, packVoltageFilename: "Pack_Voltage_\(vinInfo).csv", packCurrentFilename: "Pack_Current_\(vinInfo).csv", cellVoltagesFilename: "Cell_Volt_\(vinInfo).csv", transactionId: self.preSignedData!.transactionID, vehicleProfile: submitBatteryDataVehicleProfileInput)
		print("sunmit battery data file props input :", submitBatteryDataFilesPropsInput)
		print("Transection: ID", self.preSignedData!.transactionID)
		
		let mutation = SubmitBatteryDataFilesWithBmsCapacityMutation(Vehicle: vehicalBatteryDataFile, submitBatteryDataFilesProps: submitBatteryDataFilesPropsInput, bmsCapacityProps: bmsCapacityPropsInput)
		//		SubmitBatteryFilesWithBmsCapacityMutation(Vehicle: vehicalBatteryDataFile, submitBatteryDataFilesProps: submitBatteryDataFilesPropsInput, bmsCapacityProps: bmsCapacityPropsInput)
		
		Network.shared.apollo.perform(mutation: mutation) { result in
			switch result {
			case .success(let graphQLResults):
				guard let data = try? result.get().data else { return }
				print("data ::", data)
				if graphQLResults.data != nil {
					if graphQLResults.errors?.count ?? 0 > 0 {
						print("Error::", graphQLResults.errors!)
						//TODO Stop Animation and show alert
						return
					}
					let submitData =  graphQLResults.data?.resultMap["submitBatteryDataFilesWithBmsCapacity"].jsonValue
					if submitData == nil {
						return
					} else {
						print("Submitted data::::" ,submitData)
						let jsonObject = submitData.jsonValue
						print("submited battery data", jsonObject)
						//getS3PreSingedUrl
						//var preSignedData : Data?
						do {
							let  preSignedData = try JSONSerialization.data(withJSONObject: jsonObject)
							do {
								let decoder = JSONDecoder()
								let submitBatteryData = try decoder.decode(SubmitBatteryDataFilesWithStateOfCharge.self, from: preSignedData)
								print("submit battery data::",submitBatteryData)
								let storyBaord = UIStoryboard.init(name: "Main", bundle: nil)
								let vc = storyBaord.instantiateViewController(withIdentifier: "BatteryHealthViewController") as! BatteryHealthViewController
//								if let vInfo = self.vehicleInfo,let grade = submitBatteryData.batteryScore?.grade,let health = submitBatteryData.batteryScore?.health  {
//									vc.viewModel = BatteryHealthViewModel(vehicleInfo: vInfo, transactionID: self.transactionId ?? "", healthScore: health , grade: VehicleGrade(rawValue: grade) ?? .A)
//								}
								self.navigationController?.pushViewController(vc, animated: true)
								
							} catch DecodingError.dataCorrupted(let context) {
								print(context)
								return
							}
						} catch {
							print("Unexpected error: \(error).")
						}
						
					}
				} else {
					
				}
				break
			case .failure(let error):
				break
			}
			
		}
		
	}
}

