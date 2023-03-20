//
//  BluetoothServices.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 1/18/23.
//

import Foundation
import CoreBluetooth
import UIKit


protocol BleWriteReadProtocal: AnyObject {
	func blewriteResponse(data: Data, commandType: CommandType)
	func bleReonse(data: Data)

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
	var delegate: BleWriteReadProtocal? = nil
	var commandType: CommandType = .ODOMETER
	//	 var commandCallBack: (((Data, BLECommand))->Void)?
	//	var commandType: BLECommand = .NONE
	var resData = Data()
	private var bluetoothWriteCallback: AceLiteBleWriteCallback? = nil
	private var bluetoothNotifyCallback: AceLiteBleNotifyCallback? = nil
	var completionHandler: ((String)->())?
	public var isPeripheralIdentified = false
	
	
	
	override init() {
		super.init()
		self.centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
		////print("delegate:::::", self.delegate)
	
		
	}
		
	
	
	func setDelegateChange(delegate: BleWriteReadProtocal?) {
		self.delegate = delegate
	}
	
	public func writeBytesDatas(data: String, completionHandler: ((String)->())?, delegate: BleWriteReadProtocal?, commandType: CommandType ) {
		self.delegate = delegate
		self.commandType = commandType
		self.completionHandler = completionHandler
		guard let characterstics = txCharacteristic else {
			return
		}
		let dataToSend: Data = data.data(using: .utf8)!
		bluetoothPeripheral!.writeValue(dataToSend, for: characterstics, type: .withResponse)
		bluetoothPeripheral?.setNotifyValue(true, for: rxCharacteristic!)
	}
	
	public func writeBytesData(data: String, completionHandler: ((String)->())? ) {
		// self.commandType = .Other
		self.completionHandler = completionHandler
		guard let characterstics = txCharacteristic else {
			return
		}
		let dataToSend: Data = data.data(using: .utf8)!
		bluetoothPeripheral!.writeValue(dataToSend, for: characterstics, type: .withResponse)
		// sleep(1)
		bluetoothPeripheral?.setNotifyValue(true, for: rxCharacteristic!)
		
		// .txt file
		// add to string  data
		// add new line  \n
		
	}
	
	public func connectDevices(peripheral: CBPeripheral) {
		self.centralManager.connect(peripheral, options: nil)
		myPeripheral = peripheral
		////print("::::::: myperipheral name", peripheral.name ?? "")
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
		else {
			//print("Something wrong with BLE")
			NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "BLEResponse"), object: ["BLEResponse": "Something wrong with BLE"], userInfo: nil)
			// Not on, but can have different issues
		}
	}
	
	func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		//print(peripheral.name ?? "")
		
		//print(peripheral.ancsAuthorized)
		if let pname =  peripheral.name, pname ==  "CAM101" {
			bluetoothPeripheral = peripheral
			centralManager.connect(bluetoothPeripheral!)
			bluetoothPeripheral!.delegate = self
			centralManager.stopScan()
			self.isPeripheralIdentified = false
			let deviceModel = DeviceModel(id:  pname, peripheral: peripheral)
			self.blePeripheralDevice.append(deviceModel)
			filterPeripharalNames()
		} else {
		
		}
		
	}
	
	func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		bluetoothPeripheral!.discoverServices([bluetoothServiceUUID])
	}
	
	func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		
		if peripheral.services?.count ?? 0 > 0 {
			//print(peripheral.services![0])
			peripheral.discoverCharacteristics(nil, for: peripheral.services![0])
		}
	}
	
	func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
		for characteristic in service.characteristics! {
			//print(characteristic)
			if characteristic.uuid == rxCharacteristicUUID {
				//print("uuid- rx", characteristic.uuid.uuidString)
				rxCharacteristic = characteristic
				peripheral.setNotifyValue(true, for: rxCharacteristic!)
				peripheral.readValue(for: rxCharacteristic!)
				
				
			} else if (characteristic.uuid == txCharacteristicUUID) {
				txCharacteristic = characteristic
				//print("UUID-tx", characteristic.uuid.uuidString)
				
			}
			
		}
	}
	
	func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
		if let value = characteristic.value {
			
			
			// .txt
			let byteArray: [UInt8] = Array(value)
			let stringAbyteArray = "\(byteArray)"
			//print("********************BytesArray******************", stringAbyteArray)
			// add to string stringAbyteArray
			// add new line \n
			
			let parseData: String = String.init(data: value, encoding: .utf8) ?? ""
			//print("********************Byte to string********************", parseData)
			// add to string parseData
			// add new line \n
			
			if let stringData = String.init(data: value, encoding: .utf8) {
				
				if stringData.contains(Constants.QUESTION_MARK) || stringData.contains(Constants.NODATA) || stringData.contains(Constants.NO_DATA) || stringData.contains(Constants.ERROR) || stringData.contains(Constants.CARET) {
					self.completionHandler?("")
				} else {
					
					self.completionHandler?(stringData)
				}
			}
		}
	}
	
	
	public func writeBytesData(data: String) {
		//print("Write Command::::::", data)
		guard let characterstics = txCharacteristic else {
			return
		}
		let dataToSend: Data = data.data(using: .utf8)!
		bluetoothPeripheral!.writeValue(dataToSend, for: characterstics, type: .withResponse)
		bluetoothPeripheral?.setNotifyValue(true, for: rxCharacteristic!)
	}
	
	func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
		//print(characteristic)
	}
	
	func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
		if error == nil {
			bluetoothNotifyCallback?.onCharacteristicChanged(byteArray: characteristic.value)
		} else {
			bluetoothNotifyCallback?.onNotifyFailure(exception: error)
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
}
