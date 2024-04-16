//
//  OfflineViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 8/12/23.
//

import UIKit

enum ErrorSheetSource: String {
	case OFFLINE_LIST = "offline_list"
	case INSTRUCTION_FLOW = "instructions_flow"
}

protocol OffileViewDelegate: AnyObject {
	func navigateToRootView()
}

class OfflineViewController: UIViewController {
	
	@IBOutlet weak var massageLabel: UILabel!
	@IBOutlet weak var bttomSheetView: UIView!
	@IBOutlet weak var okButton: UIButton!
	let network = NetworkManager.sharedInstance
	weak var delegate:  OffileViewDelegate? = nil
	var viewModel: OfflineViewModel?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		FirebaseLogging.instance.logEvent(eventName:OfflineEvents.offlineErrorSheet, parameters: nil)
		okButton.layer.cornerRadius = 10
		bttomSheetView.layer.cornerRadius = 10
		self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
		if self.viewModel?.submitApiResponse == .BLUETOOTH_CLASSIC {
			var attributedText = NSMutableAttributedString(string: Constants.BLUETOOTH_CLASSIC_MESSAGE, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
			var bleMessage = NSMutableAttributedString(string: Constants.BLUETOOTH_CLASSIC_INSTRUCTION_MESSAGE, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold)])
			
			let combination = NSMutableAttributedString()
			combination.append(attributedText)
			combination.append(bleMessage)
			massageLabel.attributedText =  combination
		} else {
			massageLabel.text = viewModel?.submitApiResponse.message
		}
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: animated)
//		network.reachability.whenReachable = { reachability in
//			self.dismiss(animated: true)
//		}
	}
	
	@IBAction func okButtonAction(_ sender: UIButton) {
		self.dismiss(animated: true, completion: {
			DispatchQueue.main.async {
				if self.viewModel?.submitApiResponse == .BLUETOOTH_CLASSIC {
					UIApplication.shared.open(URL(string: "App-prefs:Bluetooth")!)
				} else {
					self.delegate?.navigateToRootView()
				}
			}
		})
	}
}
