//
//  BluetoothServices.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 1/18/23.
//

import Foundation
import CoreBluetooth
import UIKit


//protocol BleWriteReadProtocal: AnyObject {
//	func blewriteResponse(data: Data, commandType: CommandType)
//	func bleReonse(data: Data)
//
//}
enum FlowControlInstructionType {
	case FLOW_CONTROL_HEADER
	case FLOW_CONTROL_DATA
	case FLOW_CONTROL_NORMAL_COMMAND
	case HEADER
	case FLOW_PID
	case NONE
}

protocol BLEPermissionDelegate: AnyObject {
	func blePermissionDelegate()
	func handleBleCommandError()
}

class BluetoothServices: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate {
	private var bleDevicesArray = [CBPeripheral]()
	public var centralManager: CBCentralManager!
	var myPeripheral: CBPeripheral!
	var blePeripheralDevice = [DeviceModel]()
	let bluetoothServiceUUID = CBUUID(string: "FFF0")
	let rxCharacteristicUUID = CBUUID(string: "FFF1")
	let txCharacteristicUUID = CBUUID(string: "FFF2")
	var bluetoothPeripheral: CBPeripheral? = nil
	var bluetoothService: CBService? = nil
	var txCharacteristic: CBCharacteristic? = nil
	var rxCharacteristic: CBCharacteristic? = nil
	var callBack: (([DeviceModel]) -> Void)?
//	var delegate: BleWriteReadProtocal? = nil
	var commandType: CommandType = .Other
	var flowControlType: FlowControlInstructionType = .NONE
	
	//	 var commandCallBack: (((Data, BLECommand))->Void)?
	//	var commandType: BLECommand = .NONE

	private var bluetoothWriteCallback: AceLiteBleWriteCallback? = nil
	private var bluetoothNotifyCallback: AceLiteBleNotifyCallback? = nil
	var completionHandler: ((String)->())?
	public var isPeripheralIdentified = false
	//var emptyArray : Int[] = []
	private var fromDate = Date()
	weak var delegate: BLEPermissionDelegate?
	override init() {
		super.init()
		self.centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
		////print("delegate:::::", self.delegate)
	
		
	}
		
	
	
//	func setDelegateChange(delegate: BleWriteReadProtocal?) {
//		self.delegate = delegate
//	}
	
//	public func writeBytesDatas(data: String, completionHandler: ((String)->())?, delegate: BleWriteReadProtocal?, commandType: CommandType ) {
////		self.delegate = delegate
//		self.commandType = commandType
//		self.completionHandler = completionHandler
//		guard let characterstics = txCharacteristic else {
//			return
//		}
//		print("request data:::::", data)
//		let dataToSend: Data = data.data(using: .utf8)!
//		bluetoothPeripheral!.writeValue(dataToSend, for: characterstics, type: .withResponse)
//		bluetoothPeripheral?.setNotifyValue(true, for: rxCharacteristic!)
//	}
	
	public func writeBytesData(flowControl: FlowControlInstructionType, commandType: CommandType, data: String, completionHandler: ((String)->())?) {
		// self.commandType = .Other
		self.completionHandler = completionHandler
		guard let characterstics = txCharacteristic else {
			return
		}
		//print("request data:::::", data)
		let dataToSend: Data = data.data(using: .utf8)!
		print(Date(), "About to write: \(data)", to: &Log.log)
		self.fromDate = Date()
		self.commandType = commandType
		self.flowControlType = flowControl
		bluetoothPeripheral?.writeValue(dataToSend, for: characterstics, type: .withResponse)
		bluetoothPeripheral?.setNotifyValue(true, for: rxCharacteristic!)
	}
	
	public func connectDevices(peripheral: CBPeripheral) {
		self.centralManager.connect(peripheral, options: nil)
		myPeripheral = peripheral
		//print("::::::: myperipheral name", peripheral.name ?? "")
		self.myPeripheral.delegate = self
	}
	
	public func disconnectDevice(peripheral: CBPeripheral) {
		self.centralManager.cancelPeripheralConnection(peripheral)
	}
	
	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		if central.state == .poweredOn {
			central.scanForPeripherals(withServices: nil, options: nil)
			
			NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "Scanning..."], userInfo: nil)
		}
		if central.state == CBManagerState.poweredOn {
			
			NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "BLE powered on"], userInfo: nil)
			// Turned on
			central.scanForPeripherals(withServices: nil, options: nil)
		}
		if central.state == .unauthorized {
			print("show unauthorized")
			delegate?.blePermissionDelegate()
   }
		else {
			//print("Something wrong with BLE")
			NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "Something wrong with BLE"], userInfo: nil)
			// Not on, but can have different issues
		}
	}
	
	func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		//print("peripheral data", central)
		if let pname =  peripheral.name {
			//print("pName::::", pname)
			if pname.contains("cox") || pname.contains("CAM") || pname.contains("COX")  {
				//, pname ==  "CAM101" || pname ==  "CAM144" {
				//bluetoothPeripheral = peripheral
				//centralManager.connect(bluetoothPeripheral!)
				//bluetoothPeripheral!.delegate = self
				//centralManager.stopScan()
				//self.isPeripheralIdentified = true
				//KM8KM4AE5NU109919
				let deviceModel = DeviceModel(id:  pname, peripheral: peripheral)
				self.blePeripheralDevice.append(deviceModel)
				filterPeripharalNames()
			}
		} else {
		
		}
	}
	
	func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		bluetoothPeripheral?.discoverServices([bluetoothServiceUUID])
	}
	
	func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		
		if peripheral.services?.count ?? 0 > 0 {
			print(peripheral.services![0])
			peripheral.discoverCharacteristics(nil, for: peripheral.services![0])
		}
	}
	
	func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
		for characteristic in service.characteristics! {
			print(characteristic)
			if characteristic.uuid == rxCharacteristicUUID {
				print("uuid- rx", characteristic.uuid.uuidString)
				rxCharacteristic = characteristic
				peripheral.setNotifyValue(true, for: rxCharacteristic!)
				peripheral.readValue(for: rxCharacteristic!)
				
				
			} else if (characteristic.uuid == txCharacteristicUUID) {
				txCharacteristic = characteristic
				print("UUID-tx", characteristic.uuid.uuidString)
				
			}
			
		}
	}
	
	func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
		if let value = characteristic.value {
			//print("value::::", value)
			//DispatchQueue.global(qos: .background).async {
			let parseData: String = String.init(data: value, encoding: .utf8) ?? ""

			let byteArray: [UInt8] = Array(value)
			print(Date(), "notify obtained bytes : \(byteArray)", to: &Log.log)
			//print(Date(), "string value of bytes is  : \(parseData)", to: &Log.log)
			if  parseData.contains(":") {
				let removeSpaces = parseData.trimmingCharacters(in: .whitespacesAndNewlines)
				let splitString = removeSpaces.components(separatedBy: "\r")
				for item in splitString {
					let newitem = item.trimmingCharacters(in: .whitespacesAndNewlines)
					let sliptWithColen = newitem.components(separatedBy: ":")
					//print("sliptWithColen", sliptWithColen)
					//print(Date(), "Data Split With Colon\(sliptWithColen)", to: &Log.log)
					if sliptWithColen.count == 2 {
						//print("adding space between two chars", sliptWithColen[1])
						Network.shared.arrayOfBytesData.append(sliptWithColen[1])
						//print("total string", Network.shared.arrayOfBytesData)
						//print(Date(), "Total String\(Network.shared.arrayOfBytesData)", to: &Log.log)
						
					} else {
						
						//print("::::::::::::", newitem)
						//print(Date(), "Single Frame", to: &Log.log)
					}
				}
			
			} else {
				let removeSpaces = parseData.trimmingCharacters(in: .whitespacesAndNewlines)
				Network.shared.arrayOfBytesData.append(removeSpaces)
				
			}
			
			if  parseData.count != 0 {
				if  parseData.contains(Constants.CARET) {
					//print(Date(), "Caret)", to: &Log.log)
					self.calculateCommandRequestAndResponseTimeDuration(startDate: self.fromDate, endDate: Date())
					self.completionHandler?(Network.shared.arrayOfBytesData)
					Network.shared.arrayOfBytesData.removeAll()
				
				} else if parseData.contains(Constants.QUESTION_MARK) || parseData.contains(Constants.NODATA) || parseData.contains(Constants.NO_DATA) || parseData.contains(Constants.ERROR)   {
					//self.calculateCommandRequestAndResponseTimeDuration(startDate: self.fromDate, endDate: Date())
					print(Date(), "Write Data Error)", to: &Log.log)
				} else if parseData.contains(Constants.OK) {
					//self.calculateCommandRequestAndResponseTimeDuration(startDate: self.fromDate, endDate: Date())
					self.completionHandler?(Network.shared.arrayOfBytesData)
					Network.shared.arrayOfBytesData.removeAll()
					
				} else {
					//print(Date(), "Something Else)", to: &Log.log)
				}
			}
			//}
			}
	}
	private func typeCastingByteToString(testCommand: String) -> String {

		let splitString = testCommand.pairs.joined(separator: " ")
			return splitString + " "
		
	}
	
	func getDateDiff(start: Date, end: Date) -> Int  {
		let calendar = Calendar.current
		let dateComponents = calendar.dateComponents([Calendar.Component.second], from: start, to: end)

		let seconds = dateComponents.second
		return Int(seconds!)
	}
	
//	public func writeBytesData(data: String) {
//		guard let characterstics = txCharacteristic else {
//			return
//		}
//		let dataToSend: Data = data.data(using: .utf8)!
//		bluetoothPeripheral!.writeValue(dataToSend, for: characterstics, type: .withResponse)
//		bluetoothPeripheral?.setNotifyValue(true, for: rxCharacteristic!)
//	}
	
	func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
		//print(characteristic)
		if error == nil {
			//bluetoothNotifyCallback?.onCharacteristicChanged(byteArray: characteristic.value)
		} else {
			// handle error in communication
			delegate?.handleBleCommandError()
		}
	}
	
	func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
		if error == nil {
			//bluetoothNotifyCallback?.onCharacteristicChanged(byteArray: characteristic.value)
		} else {
			// handle error in communication
			delegate?.handleBleCommandError()
			
		}
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
		self.callBack?(uniquePosts)
	}
	
	private func calculateCommandRequestAndResponseTimeDuration(startDate: Date, endDate: Date)  {
			let seconds = Calendar.current.dateComponents([.nanosecond], from: startDate, to: endDate).nanosecond ?? 0
		let milliSec = round(Double(seconds / 1000000))
		print("timeDifference - Command \(self.commandType) - Flow Control \(self.flowControlType) :amount of time taken from start to end is \(milliSec) milli ec.")
			
		print(Date(), "timeDifference -  Command \(self.commandType) - Flow Control \(self.flowControlType) :amount of time taken from start to end is \(milliSec) milli sec.", to: &Log.log)

		}
}

extension Collection {

	func unfoldSubSequences(limitedTo maxLength: Int) -> UnfoldSequence<SubSequence,Index> {
		sequence(state: startIndex) { start in
			guard start < endIndex else { return nil }
			let end = index(start, offsetBy: maxLength, limitedBy: endIndex) ?? endIndex
			defer { start = end }
			return self[start..<end]
		}
	}

	func every(n: Int) -> UnfoldSequence<Element,Index> {
		sequence(state: startIndex) { index in
			guard index < endIndex else { return nil }
			defer { let _ = formIndex(&index, offsetBy: n, limitedBy: endIndex) }
			return self[index]
		}
	}

	var pairs: [SubSequence] { .init(unfoldSubSequences(limitedTo: 2)) }
}

extension Date {
	static func - (lhs: Date, rhs: Date) -> TimeInterval {
		return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
	}
}
