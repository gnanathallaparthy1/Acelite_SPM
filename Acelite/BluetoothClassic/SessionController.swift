//
//  SessionController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 2/27/24.
//

import Foundation

import UIKit
import ExternalAccessory

class SessionController: NSObject, EAAccessoryDelegate, StreamDelegate {
	
	static let sharedController = SessionController()
	var _accessory: EAAccessory?
	var _session: EASession?
	var _protocolString: String?
	var _writeData: NSMutableData?
	var _readData: NSMutableData?
	var _dataAsString: String?
	var _dataAsHexString: String?
	var completionHandler: ((Data)->())?
	var commandType: CommandType = .Other
	var instructionType: InstructionType = .NONE
	var dataString: String = ""
	// MARK: Controller Setup
		
	func setupController(forAccessory accessory: EAAccessory, withProtocolString protocolString: String) {
		_accessory = accessory
		_protocolString = protocolString
	}
	
	// MARK: Opening & Closing Sessions
	
	func openSession() -> Bool {
		guard let accessory = _accessory else {
			print(Date(), "Accessory Not Connected", to: &Log.log)
			return false
		}
		_accessory = accessory
		guard let protocolStringName = _protocolString else {
			print(Date(), "Protocol string name is empty", to: &Log.log)
			return false
		}
		print(Date(), "Classic session started", to: &Log.log)
		_accessory?.delegate = self
		_session = EASession(accessory: accessory, forProtocol: protocolStringName)

		if _session != nil {
			_session?.inputStream?.delegate = self
			_session?.inputStream?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
			_session?.inputStream?.open()
			
			_session?.outputStream?.delegate = self
			_session?.outputStream?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
			_session?.outputStream?.open()
		} else {
			print(Date(), "Failed to create session", to: &Log.log)
		}
		
		return (_session != nil)
	}
	
	func closeSession() {
		_session?.inputStream?.close()
		_session?.inputStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
		_session?.inputStream?.delegate = nil
		
		_session?.outputStream?.close()
		_session?.outputStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
		_session?.outputStream?.delegate = nil
		
		_session = nil
		_writeData = nil
		_readData = nil
	}
	
	// MARK: Write & Read Data
	
	func writeData(instructionType: InstructionType, commandType: CommandType, data: Data, completionHandler: ((Data)->())?) {
		if _writeData == nil {
			_writeData = NSMutableData()
		}
		print(Date(), "Write Classic Instruction type: \(instructionType), commandType: \(commandType) data: \(data)", to: &Log.log)
		_writeData?.append(data)
		self.writeData()
		self.completionHandler = completionHandler
	}
	
	func readData(bytesToRead: Int) -> Data {
		
		var data: Data?
		if (_readData?.length)! >= bytesToRead {
			let range = NSMakeRange(0, bytesToRead)
			data = _readData?.subdata(with: range)
			_readData?.replaceBytes(in: range, withBytes: nil, length: 0)
		}
		return data!
	}
	
	func readBytesAvailable() -> Int {
		return (_readData?.length)!
	}
	
	// MARK: - Helpers
	func updateReadData() {
		let bufferSize = 512
		var buffer = [UInt8](repeating: 0, count: bufferSize)
		while _session?.inputStream?.hasBytesAvailable == true {
			let bytesRead = _session?.inputStream?.read(&buffer, maxLength: bufferSize)
			if _readData == nil {
				_readData = NSMutableData()
			}
			_readData?.append(buffer, length: bytesRead!)
			_dataAsString = NSString(bytes: buffer, length: bytesRead!, encoding: String.Encoding.utf8.rawValue) as String?
			if let dataString  = _dataAsString {
				if dataString.contains(Constants.CARET) {
					let data = NSData(data: _readData as? Data ?? Data())
	
					self.completionHandler?(data as Data)
					_readData = nil
					
				} else if dataString.contains(Constants.QUESTION_MARK) || dataString.contains(Constants.NODATA) || dataString.contains(Constants.NO_DATA) || dataString.contains(Constants.ERROR)   {
					_readData = nil
					print(Date(), "Write Data Error", to: &Log.log)
				} else if dataString.contains(Constants.OK) {
					self.completionHandler?(Network.shared.bleData)
					_readData = nil
				} else {
					
				}
			}
			//print(Date(), "RESPONSE::: \(String(describing: dataString))", to: &Log.log)
			NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BESessionDataReceivedNotification"), object: nil)
			
		}
		
	}
	
	private func writeData() {
	
		while (_session?.outputStream?.hasSpaceAvailable) == true && _writeData != nil && (_writeData?.length)! > 0 {
			var buffer = [UInt8](repeating: 0, count: _writeData!.length)
			_writeData?.getBytes(&buffer, length: (_writeData?.length)!)
			let bytesWritten = _session?.outputStream?.write(&buffer, maxLength: _writeData!.length)
			if bytesWritten == -1 {
				print(Date(), "Write Data Error1", to: &Log.log)
				return
			} else if bytesWritten! > 0 {
				_writeData?.replaceBytes(in: NSMakeRange(0, bytesWritten!), withBytes: nil, length: 0)
				print(Date(), "Write Command End", to: &Log.log)
			}
		}
	}
	
	// MARK: - EAAcessoryDelegate
	
	func accessoryDidDisconnect(_ accessory: EAAccessory) {
		print(Date(), "accessory did disconnect", to: &Log.log)
		// Accessory diconnected from iOS, updating accordingly
	}
	
	// MARK: - NSStreamDelegateEventExtensions
	
	func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
		switch eventCode {
		case Stream.Event.openCompleted:
			print(Date(), "stream completed", to: &Log.log)
			break
		case Stream.Event.hasBytesAvailable:
			// Read Data
			updateReadData()
			break
		case Stream.Event.hasSpaceAvailable:
			// Write Data
			self.writeData()
			break
		case Stream.Event.errorOccurred:
			print("Error- errorOccurred:", Stream.Event.errorOccurred)
			break
		case Stream.Event.endEncountered:
			print("Error- endEncountered:", Stream.Event.endEncountered)
			break
			
		default:
			break
		}
	}
}

