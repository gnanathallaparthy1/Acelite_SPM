//
//  ViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 12/21/22.
//

import UIKit

enum ScreenState {
case ConnectOBDdevice
//case StartCar
//	//scan
//case VehicalInfo
}


class ViewController: UIViewController {
	//@IBOutlet weak var sideMenuBtn: UIBarButtonItem!
	@IBOutlet weak var imageTitleLabel: UILabel!
	var screenState = ScreenState.ConnectOBDdevice
	
	@IBOutlet weak var imageView: UIImageView!
	
	@IBOutlet weak var screenCountLabel: UILabel! {
		didSet {
			screenCountLabel.layer.cornerRadius = screenCountLabel.frame.size.width / 2
			screenCountLabel.clipsToBounds = true
		}
	}
	@IBOutlet weak var cancelButton: UIButton! {
		didSet {
			cancelButton.layer.cornerRadius = 8
		}
	}
	//@IBOutlet weak var backButton: UIButton! {
//		didSet {
//			backButton.layer.cornerRadius = 8
//
//		}
//	}
	@IBOutlet weak var nextButton: UIButton! {
		didSet {
			nextButton.layer.cornerRadius = 8
			
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.setStatusBar(backgroundColor: UIColor.appPrimaryColor())
		self.navigationController?.navigationBar.setNeedsLayout()
	
		let menuBarButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.menuButtonAction(_ :)))
		menuBarButton.tintColor = UIColor.appPrimaryColor()
		self.navigationItem.leftBarButtonItem  = menuBarButton
		//sideMenuBtn.target = revealViewController()
		//sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
		
		nextButton.addTarget(self, action: #selector(self.nextButtonAction(_:)), for: .touchUpInside)
		
	//backButton.addTarget(self, action: #selector(self.backButtonAction(_:)), for: .touchUpInside)
		
		cancelButton.addTarget(self, action: #selector(self.cancelButtonAction(_:)), for: .touchUpInside)
	
		uiViewUpdate()
		
	}

	
	@IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
		sender.target = revealViewController()
		sender.action = #selector(revealViewController()?.revealSideMenu)
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		imageTitleLabel.text = "Connect The OBD-II Device"
		cancelButton.backgroundColor = .lightGray
		cancelButton.isUserInteractionEnabled = false
		cancelButton.isHidden = true
		//backButton.isHidden = true
//			backButton.backgroundColor = .lightGray
//			backButton.isUserInteractionEnabled = false
		imageView.image = UIImage.init(named: "1-5")
		screenCountLabel.text = "1/5"
		//self.navigationItem.setHidesBackButton(true, animated: true)
			//setNavigationBar(bgColor: UIColor(red: 0.00, green: 0.76, blue: 0.84, alpha: 1.00), TitleColor: UIColor.white, title: "" ,imageLeft: UIImage(named: "menu")!,imageRight: UIImage(named: "menu")!, leftbarImageisHide: false, rightbarImageisHide: true, popView: false)
		}
	
	private func uiViewUpdate()  {
		nextButton.backgroundColor = UIColor.appPrimaryColor()
		if screenState == .ConnectOBDdevice {
			imageTitleLabel.text = "Connect The OBD-II Device"
			cancelButton.backgroundColor = .lightGray
			cancelButton.isUserInteractionEnabled = false
			cancelButton.isHidden = true
			//backButton.isHidden = true
//			backButton.backgroundColor = .lightGray
//			backButton.isUserInteractionEnabled = false
			imageView.image = UIImage.init(named: "1-5")
			screenCountLabel.text = "1/5"
		} else {
			
			let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
			let vehicalVC = storyBoard.instantiateViewController(withIdentifier: "ScanBleDevicesViewController") as! ScanBleDevicesViewController
			self.navigationController?.pushViewController(vehicalVC, animated: false)
		}
	
	}
	
	@IBAction func backButtonAction(_ sender: UIButton) {
		screenState = .ConnectOBDdevice
		uiViewUpdate()
	}
	
	
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		screenState = .ConnectOBDdevice
		uiViewUpdate()
	}
	
	@IBAction func nextButtonAction(_ sender: UIButton) {
		
		
		/*
		 let storyboard = UIStoryboard.init(name: "BatteryHealthCheck", bundle: nil)
				 let vc = storyboard.instantiateViewController(withIdentifier: "ErrorAlertDailogViewController") as! ErrorAlertDailogViewController
				 vc.modalPresentationStyle = .fullScreen
		 vc.popoverPresentationController?.delegate = self
		 self.navigationController?.present(vc, animated: true)
		 */
	
				//self.present(vc, animated: true)
		
//		if screenState == .ConnectOBDdevice {
//			screenState = .StartCar
//		} else if screenState == .StartCar {
//			screenState = .VehicalInfo
//		} else {
//			screenState = .ConnectOBDdevice
//		}
//		uiViewUpdate()
		let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
		let vehicalVC = storyBoard.instantiateViewController(withIdentifier: "ScanBleDevicesViewController") as! ScanBleDevicesViewController
		self.navigationController?.pushViewController(vehicalVC, animated: false)
	}

}

extension ViewController: UIPopoverPresentationControllerDelegate {
	public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
		return .none
	}
}

extension UINavigationController {

	func setStatusBar(backgroundColor: UIColor) {
		let statusBarFrame: CGRect
		if #available(iOS 13.0, *) {
			statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
		} else {
			statusBarFrame = UIApplication.shared.statusBarFrame
		}
		let statusBarView = UIView(frame: statusBarFrame)
		statusBarView.backgroundColor = backgroundColor
		view.addSubview(statusBarView)
	}

}
