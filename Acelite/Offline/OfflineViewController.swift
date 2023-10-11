//
//  OfflineViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 8/12/23.
//

import UIKit

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
		okButton.layer.cornerRadius = 10
		bttomSheetView.layer.cornerRadius = 10
		self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
		massageLabel.text = viewModel?.message
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
