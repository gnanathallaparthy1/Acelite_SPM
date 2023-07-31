//
//  TerminalViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 1/20/23.
//

import UIKit
import CoreBluetooth
class TerminalViewController: UIViewController {

	@IBOutlet weak var commandResponseTextView: UITextView!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var sendButton: UIButton!
	//@IBOutlet weak var responseTableView: UITableView!
	@IBOutlet weak var commandTextFiled: UITextField!
	var bluetoothService: BluetoothServices?
	private let notificationCenter = NotificationCenter.default
	var commandResponseString = ""
	var bleResonseArray = [String]()
	override func viewDidLoad() {
        super.viewDidLoad()
		commandTextFiled.delegate = self
		commandResponseTextView.delegate = self
		cancelButton.layer.cornerRadius = 10
		sendButton.layer.cornerRadius = 10
		commandResponseTextView.text = ""
		notificationCenter.addObserver(self, selector: #selector(self.debugBleResponse(_:)), name: NSNotification.Name.init(rawValue: "BLEResponse"), object: nil)

    }
	//MARK: - Receive User Details
	@objc func debugBleResponse(_ notification: Notification) {
		
		let notificationobject = notification.object as? [String: Any] ?? [:]
		let commandResponse = notificationobject["BLEResponse"]
		print("command Response::::::", commandResponse ?? "")
		guard let commandResponse: String = notificationobject["BLEResponse"] as? String, commandResponse.count > 0 else {
			return
		}
		self.commandResponseString += commandResponse
		self.commandResponseString += "\n"
		updateTextView()
	}
	func updateTextView() {
		self.commandResponseTextView.text = ""
		self.commandResponseTextView.text = self.commandResponseString
	}
	func bluetoothService(bleServices: BluetoothServices)  {
		self.bluetoothService = bleServices
		print(self.bluetoothService?.txCharacteristic?.uuid.uuidString)
		print(self.bluetoothService?.rxCharacteristic?.uuid.uuidString)
	}
	
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func sendButtonAction(_ sender: UIButton) {
		guard let commandData = self.commandTextFiled.text, commandData.count > 0 else {
			return
		}
		self.bluetoothService?.writeByteData(data: commandData + Constants.NEW_LINE_CHARACTER)
		//self.bluetoothService?.writeBytesData(data: commandData, completionHandler: <#((String) -> ())?#>)
		commandTextFiled.resignFirstResponder()
	}
}

extension TerminalViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
}

extension TerminalViewController: UITextViewDelegate {
	func textViewDidBeginEditing(_ textView: UITextView) {
		textView.resignFirstResponder()
	}
	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		
		textView.resignFirstResponder()
		return true
	}
	func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		textView.resignFirstResponder()
		return true
	}
}



