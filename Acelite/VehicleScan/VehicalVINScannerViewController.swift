//
//  VehicalInformationViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy   on 24/04/23.
//

import UIKit

class VehicalVINScannerViewController: UIViewController {

	init(viewModel: VehicleVinScannerViewModel) {
		super.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
		//super.init()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
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
    
    
    @IBOutlet weak var clearButton: UIButton!{
        didSet {
            clearButton.layer.cornerRadius = 5
            clearButton.layer.borderWidth = 1
            clearButton.layer.borderColor = UIColor.appCalendarLightGrayColor().cgColor
        }
    }
    @IBOutlet weak var vehicleInfoLabel: UILabel! {
        didSet {
            vehicleInfoLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        }
    }

    @IBOutlet weak var screenCountLabel: UILabel! {
        didSet {
            screenCountLabel.layer.cornerRadius = screenCountLabel.frame.size.width / 2
            screenCountLabel.clipsToBounds = true
            screenCountLabel.text = "2/5"
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
	var delegate: PassVehicleInformationDelegate?
	public var viewModel: VehicleVinScannerViewModel?
  
	
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.delegate = self
        self.barcodeTextField.delegate = self
		nextButton.isUserInteractionEnabled = false
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
		if let textFieldData = barcodeTextField.text, textFieldData.count <= 17,  isValidVinNumber(textFieldData) == true {
			self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
			//regex validation for vin
			self.viewModel?.fetchVehicalInformation(vim: self.barcodeTextField?.text ?? "N/A")
		} else {
			let dialogMessage = UIAlertController(title: "WHOOPS!", message: "Please enter a Valid Vin Number ", preferredStyle: .alert)
			// Create OK button with action handler
			let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
			})
			self.nextButton.isUserInteractionEnabled = false
			self.nextButton.isEnabled = false
			//Add OK button to a dialog message
			dialogMessage.addAction(ok)
			// Present Alert to
			self.present(dialogMessage, animated: true, completion: nil)
		}
    }

}
extension VehicalVINScannerViewController: ScannerViewDelegate {
    func didFindScannedText(text: String) {
		//regex validation for vin
		if  text.count <= 17,  isValidVinNumber(text) == true {
			self.barcodeTextField?.text = text
		} else {
			let dialogMessage = UIAlertController(title: "WHOOPS!", message: "Please enter a Valid Vin Number ", preferredStyle: .alert)
			// Create OK button with action handler
			let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
			})
			self.nextButton.isUserInteractionEnabled = false
			self.nextButton.isEnabled = false
			//Add OK button to a dialog message
			dialogMessage.addAction(ok)
			// Present Alert to
			self.present(dialogMessage, animated: true, completion: nil)
		}
       
    }
    
    
}

extension VehicalVINScannerViewController: UITextFieldDelegate {
    

	func textFieldDidBeginEditing(_ textField: UITextField) {
		self.barcodeTextField?.text = "1N4BZ0CP4GC311050"
		//singleframeVin
		//"3FA6P0LU8JR142415"
		//MultiFrame with BMS
		//"1N4BZ1CP3LC310701"
		//MultiFrame with SOC
		//1N4BZ0CP4GC311050
		//1N4AZ0CP3FC331073
	}
	
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
	
		if let textFieldData = textField.text, textFieldData.count <= 17,  isValidVinNumber(textFieldData) == true {
            self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
			self.viewModel?.fetchVehicalInformation(vim: textField.text ?? "N/A")
            
		} else {
			let dialogMessage = UIAlertController(title: "WHOOPS!", message: "Please enter a valid Vin number", preferredStyle: .alert)
			// Create OK button with action handler
			let ok = UIAlertAction(title: "GOT IT", style: .default, handler: { (action) -> Void in
			})
			self.nextButton.isUserInteractionEnabled = false
			self.nextButton.isEnabled = false
			//Add OK button to a dialog message
			dialogMessage.addAction(ok)
			// Present Alert to
			self.present(dialogMessage, animated: true, completion: nil)
		}
        textField.resignFirstResponder()
        return true
    }
}

extension VehicalVINScannerViewController: PassVehicleInformationDelegate {
	func handleErrorVehicleInfoUpdate(message: String) {
		self.view.activityStopAnimating()
		let dialogMessage = UIAlertController(title: "WHOOPS!", message: "This vehicle is not supported to run the test. Check testable vehicles.", preferredStyle: .alert)
		// Create OK button with action handler
		let ok = UIAlertAction(title: "GOT IT", style: .default, handler: { (action) -> Void in
		})
		self.nextButton.isUserInteractionEnabled = false
		self.nextButton.isEnabled = false
		//Add OK button to a dialog message
		dialogMessage.addAction(ok)
		// Present Alert to
		self.present(dialogMessage, animated: true, completion: nil)
	}
	
	func updateVehicleInfo(viewModel: VehicleVinScannerViewModel) {
		self.view.activityStopAnimating()
		nextButton.isUserInteractionEnabled = true
		if (viewModel.vehicleInformation?.getBatteryTestInstructions) != nil {
			let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
			let vehicalInformation = storyBoard.instantiateViewController(withIdentifier: "VehicalInformationViewController") as! VehicalInformationViewController
			if let vehicleInfo = viewModel.vehicleInformation {
				vehicalInformation.viewModel = VehicleInformationViewModel(vinNumber: vehicleInfo.vin, vehicleInformation: vehicleInfo)
			}
			
			self.navigationController?.pushViewController(vehicalInformation, animated: true)
			
		} else {
			let dialogMessage = UIAlertController(title: "WHOOPS!", message: "This vehicle is not supported to run the test. Check testable vehicles.", preferredStyle: .alert)
			// Create OK button with action handler
			let ok = UIAlertAction(title: "GOT IT", style: .default, handler: { (action) -> Void in
			})
			self.nextButton.isUserInteractionEnabled = false
			self.nextButton.isEnabled = false
			//Add OK button to a dialog message
			dialogMessage.addAction(ok)
			// Present Alert to
			self.present(dialogMessage, animated: true, completion: nil)
		}
	}
	
	func isValidVinNumber(_ vinNumber: String) -> Bool {
		let emailRegEx = "(?=.*\\d|=.*[A-Z])(?=.*[A-Z])[A-Z0-9]{17}"

		let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailPred.evaluate(with: vinNumber)
	}
	
	
}
