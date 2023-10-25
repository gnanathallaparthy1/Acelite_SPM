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
		massageLabel.text = viewModel?.submitApiResponse.message
		
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
				self.delegate?.navigateToRootView()
			}
		})
	}
}
