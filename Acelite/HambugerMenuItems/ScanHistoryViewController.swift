//
//  ScanHistoryViewController.swift
//  Acelite
//
//  Created by NagaKumar Ganja on 24/03/23.
//

import UIKit
import CoreData
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
		//coredate
		self.retrieveData()
		//vinDataArray = userDefaults.object(forKey: "myKey") as? [[String : String]] ?? [[String: String]]()
		if vinDataArray.count > 0 {
			historyTableView.isHidden = false
			dataNotAvilableLabel.isHidden = true
			self.historyTableView.reloadData()
		} else {
			historyTableView.isHidden = true
			dataNotAvilableLabel.isHidden = false
		}		
	}
	
	func retrieveData() {
		//As we know that container is set up in the AppDelegates so we need to refer that container.
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
		//We need to create a context from this container
		let managedContext = appDelegate.persistentContainer.viewContext
		//Prepare the request of type NSFetchRequest  for the entity
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BatteryInstructionsData")
		do {
			let result = try managedContext.fetch(fetchRequest)
			for data in result as! [NSManagedObject] {
				var dict = [String: String]()
				dict["dateAndTime"] = data.value(forKey: "dateAndTime") as? String
				dict["make"] = data.value(forKey: "make") as? String
				dict["model"] = data.value(forKey: "model") as? String
				dict["trim"] = data.value(forKey: "trim") as? String
				dict["vinNumber"] = data.value(forKey: "vinNumber") as? String
				dict["workOrder"] = data.value(forKey: "workOrder") as? String
				//print(data.value(forKey: "finalJsonData") as! String)
				vinDataArray.append(dict)
			}
		} catch {
			print("Failed")
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
		cell?.makeLabel.text = vinData["make"]
		//cell?.yearLabelValue.text = vinData["Year"]
		cell?.yearLabelValue.text = "Test 2003"
		cell?.dateTimeLabelValue.text = vinData["dateAndTime"]
		//cell?.transectionIdLabelValue.text = vinData["Transaction ID"]
		cell?.transectionIdLabelValue.text = "Test123456"
		//cell?.bodyStyleLabelValue.text = vinData["Body Style"]
		cell?.vinNumberLabelValue.text = vinData["vinNumber"]
		cell?.modelLabelValue.text = vinData["model"]
		cell?.workOrderLabelValue.text = vinData["workOrder"]
		cell?.healthLabelValue.text = vinData["Health"]
		//cell?.vehicleTitleLabel.text = vinData["Title"]
		cell?.vehicleTitleLabel.text = "Test Title"
		//cell?.scoreLabelValue.text = vinData["Score"]
		cell?.scoreLabelValue.text = "Test No Score"
        return cell ?? UITableViewCell()
        
    }
    
    
}
