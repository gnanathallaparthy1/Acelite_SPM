//
//  VehicalInformationViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 12/23/22.
//

import UIKit

class VehicalInformationViewController: UIViewController {
	
	init(viewModel: VehicleInformationViewModel) {
		super.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
		//super.init()
	}
	//gameDetailsViewController.delegate = self
	
//	init() {
//
//	}
	
	required init?(coder: NSCoder) {
		//form = Form()
		super.init(coder: coder)
	}

//	required init?(coder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
	var delegate:UpdateVehicleInformationDelegate?
	public var viewModel: VehicleInformationViewModel?
	
	@IBOutlet weak var scanLabel: UILabel! {
		didSet {
			//scanLabel.isHidden = false
		}
	}
	
	@IBOutlet weak var barCodeView: UIView! {
		didSet {
			//barCodeView.isHidden = false
		}
	}
	
	@IBOutlet weak var carInfoView: UIView! {
		didSet {
			//barCodeView.isHidden = true
		}
	}
	@IBOutlet weak var screenCountLabel: UILabel! {
		didSet {
			screenCountLabel.layer.cornerRadius = screenCountLabel.frame.size.width / 2
			screenCountLabel.clipsToBounds = true
			screenCountLabel.text = "3/5"
		}
	}
	@IBOutlet weak var cancelButton: UIButton! {
		didSet {
			cancelButton.layer.cornerRadius = 8
		}
	}
	@IBOutlet weak var backButton: UIButton! {
		didSet {
			backButton.layer.cornerRadius = 8
			
		}
	}
	@IBOutlet weak var nextButton: UIButton! {
		didSet {
			nextButton.layer.cornerRadius = 8
			
		}
	}
	
	@IBOutlet weak var barcodeTextField: UITextField!
	// CardViewInfo
	@IBOutlet weak var vimTitle: UILabel!
	@IBOutlet weak var vimName: UILabel!
	@IBOutlet weak var vimModel: UILabel!
	@IBOutlet weak var vimYear: UILabel!
	@IBOutlet weak var vimBodyStyle: UILabel!
		
    override func viewDidLoad() {
        super.viewDidLoad()
		viewModel?.delegate = self
		self.barcodeTextField.delegate = self
		carInfoView.isHidden = true
		nextButton.addTarget(self, action: #selector(self.nextButtonAction(_:)), for: .touchUpInside)
//		backButton.addTarget(self, action: #selector(self.backButtonAction(_:)), for: .touchUpInside)
		cancelButton.addTarget(self, action: #selector(self.cancelButtonAction(_:)), for: .touchUpInside)
		//barcodeTextField.text = "3FA6P0SU1KR191846"
        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationItem.setHidesBackButton(true, animated:true)
		
		let menuBarButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(self.menuButtonAction(_ :)))
		menuBarButton.tintColor = UIColor.appPrimaryColor()
		self.navigationItem.leftBarButtonItem  = menuBarButton
	}
	
	@IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
		sender.target = revealViewController()
		sender.action = #selector(revealViewController()?.revealSideMenu)
	}
	
	@IBAction func barcodeScannerButtonAction(_ sender: UIButton) {
		let storyBaord = UIStoryboard.init(name: "Main", bundle: nil)
		let vc = storyBaord.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
		vc.delegate = self
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func nextButtonAction(_ sender: UIButton) {
		let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
		let workOrderVC = storyBoard.instantiateViewController(withIdentifier: "WorkOrderViewController") as! WorkOrderViewController
		workOrderVC.vehicleInfo = viewModel?.vehicleInformation
		self.navigationController?.pushViewController(workOrderVC, animated: true)
	}
}

extension VehicalInformationViewController: ScannerViewDelegate {
	func didFindScannedText(text: String) {
		self.barcodeTextField?.text = text
	}
	
	
}

extension VehicalInformationViewController: UITextFieldDelegate {
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		self.barcodeTextField?.text = "3FA6P0SU1KR191846"
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == self.barcodeTextField {
			//make call from view model
			self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
			self.viewModel?.fetchVehicalInformation(vim: "3FA6P0SU1KR191846")
			
		}
		textField.resignFirstResponder()
		return true
	}
}

extension VehicalInformationViewController: UpdateVehicleInformationDelegate {
	func updateVehicleInfo(viewModel: VehicleInformationViewModel) {
		self.view.activityStopAnimating()
		self.vimTitle.text = viewModel.vehicleInformation?.title
		self.vimModel.text = viewModel.vehicleInformation?.modelName
		self.vimName.text = viewModel.vehicleInformation?.vin
		let yr = viewModel.vehicleInformation?.year
		self.vimYear.text = "\(String(describing: yr))"
		self.vimBodyStyle.text = viewModel.vehicleInformation?.bodyStyle
		self.barCodeView.isHidden = true
		self.carInfoView.isHidden = false
		self.scanLabel.isHidden = true
	}
	
	func handleErrorVehicleUpdate() {
		self.view.activityStopAnimating()
	}
}
