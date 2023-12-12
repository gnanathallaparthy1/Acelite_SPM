//
//  ScanHistoryViewController.swift
//  Acelite
//
//  Created by NagaKumar Ganja on 24/03/23.
//

import UIKit

class ScanHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

	@IBOutlet weak var dataNotAvilableLabel: UILabel!
	@IBOutlet weak var historyTableView: UITableView!
	var vinDataArray = [[String: String]]()
    override func viewDidLoad() {
		FirebaseLogging.instance.logScreen(screenName: ClassNames.scanHistory)
        super.viewDidLoad()
        historyTableView.delegate = self
        historyTableView.dataSource = self
        self.historyTableView.register(UINib(nibName: "ScanHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "ScanHistoryCell")
        // Update TableView with the data
		loadDataIntoVinArray()
		
		// Remote Notification
		NotificationCenter.default.addObserver(self, selector: #selector(self.goToVc(notification:)), name:NSNotification.Name(rawValue:"identifier"), object: nil)
    }
	
	@objc func goToVc(notification:Notification) {
		NotificationCenter.default.removeObserver(self)
		DispatchQueue.main.async {
			if self.navigationController?.topViewController == self {
				self.dismiss(animated: true)
				let storyBaord = UIStoryboard.init(name: "BatteryHealthCheck", bundle: nil)
				let vc = storyBaord.instantiateViewController(withIdentifier: "TestableModelsViewController") as! TestableModelsViewController
				vc.isModallyPresented = true
				self.navigationController?.present(vc, animated: true)
			}
		}
		
		
   }

	
	private func loadDataIntoVinArray() {
		vinDataArray = userDefaults.object(forKey: "myKey") as? [[String : String]] ?? [[String: String]]()
		if vinDataArray.count > 0 {
			historyTableView.isHidden = false
			dataNotAvilableLabel.isHidden = true
			self.historyTableView.reloadData()
		} else {
			historyTableView.isHidden = true
			dataNotAvilableLabel.isHidden = false
		}		
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationItem.setHidesBackButton(true, animated:true)
		let menuBarButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(self.menuButtonAction(_ :)))
		menuBarButton.tintColor = UIColor.appPrimaryColor()
		self.navigationItem.leftBarButtonItem  = menuBarButton
	}
	
	@IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
		self.navigationController?.dismiss(animated: true)
	}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return vinDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScanHistoryCell") as? ScanHistoryTableViewCell
		let vinData = vinDataArray[indexPath.row]
		cell?.makeLabel.text = vinData["Make"]
		cell?.yearLabelValue.text = vinData["Year"]
		cell?.dateTimeLabelValue.text = vinData["Date-Time"]
		cell?.transectionIdLabelValue.text = vinData["Transaction ID"]
		cell?.bodyStyleLabelValue.text = vinData["Body Style"]
		cell?.vinNumberLabelValue.text = vinData["Vin number"]
		cell?.modelLabelValue.text = vinData["Model"]
		cell?.workOrderLabelValue.text = vinData["Work order"]
		cell?.healthLabelValue.text = vinData["Health"]
		cell?.vehicleTitleLabel.text = vinData["Title"]
		cell?.scoreLabelValue.text = vinData["Score"]
		cell?.estimateRangeOnFullChargeValue.text = vinData["Est. Range on Full Charge"]
		cell?.rangeWhenNewValueLabel.text = vinData["Range When New"]
        return cell ?? UITableViewCell()
    }
}
