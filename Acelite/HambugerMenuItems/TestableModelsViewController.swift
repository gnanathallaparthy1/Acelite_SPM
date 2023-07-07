//
//  TestableModelsViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/22/23.
//

import Foundation
import FirebaseDatabase
import Firebase
import UIKit

class TestableModelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var goToSettings: UIButton!
	let notificationCenter = NotificationCenter.default
	
	@IBOutlet weak var NoDataLabel: UILabel!
	var remoteConfig = RemoteConfig.remoteConfig()
	@IBOutlet var modelTableView: UITableView!
	var ref = DatabaseReference()
	var isModallyPresented = false
	var itemDict : [[String: Any]]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		FirebaseLogging.instance.logScreen(screenName: ClassNames.testableModels)
		modelTableView.delegate = self
		modelTableView.dataSource = self
		
		self.modelTableView.register(TestableTableViewCell.nib, forCellReuseIdentifier: TestableTableViewCell.identifier)
		self.goToSettings.isHidden = true
		// Update TableView with the data
		
		//		self.ref = Database.database().reference()
		//		self.messageObserver()
		//self.modelTableView.reloadData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		setDefaultRemoteConfigDefaults()
		//fetchRemoteConfigForTestablemodels()
		self.title = "Testable Models".uppercased()
		self.navigationItem.setHidesBackButton(true, animated:true)
		
		
		let menuBarButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(self.menuButtonAction(_ :)))
		menuBarButton.tintColor = UIColor.appPrimaryColor()
		self.navigationItem.rightBarButtonItem  = menuBarButton
		appVefifyNotificationAuthentication()
		notificationCenter.addObserver(self, selector: #selector(self.appVefifyNotificationAuthentication), name: UIApplication.willEnterForegroundNotification, object: nil)
	}
	
	@objc func appVefifyNotificationAuthentication() {
		let current = UNUserNotificationCenter.current()
		current.getNotificationSettings(completionHandler: { permission in
			switch permission.authorizationStatus  {
			case .authorized:
				print("User granted permission for notification")
				self.messageObserver()
			case .denied:
				print("User denied notification permission")
				self.showMessageLable()
			case .notDetermined:
				self.showMessageLable()
				print("Notification permission haven't been asked yet")
			case .provisional:
				// @available(iOS 12.0, *)
				print("The application is authorized to post non-interruptive user notifications.")
			case .ephemeral:
				// @available(iOS 14.0, *)
				print("The application is temporarily authorized to post notifications. Only available to app clips.")
			@unknown default:
				print("Unknow Status")
			}
		})
	}
	
	deinit {
		self.notificationCenter.removeObserver(self)
	}
	
	func showMessageLable() {
		DispatchQueue.main.async {
			self.modelTableView.isHidden = true
			self.goToSettings.isHidden = false
			self.NoDataLabel.text = "Please turn on Notifications to check and receive notifications about testable models."
		}
	}
	
	
	func fetchRemoteConfigForTestablemodels() {
		//FIXME remove this before we go in production
		//	let debugSettings = FIRRemoteConfigSettings(developerModeEnabled: true)
		//RemoteConfig.remoteConfig().configSettings =
		RemoteConfig.remoteConfig().fetch(withExpirationDuration: 0) { (status, error) in
			guard error == nil else {
				print("Got an error fetching remote values: \(String(describing: error))")
				//self.setDefaultRemoteConfigDefaults()
				//self.updateViewWithRCValues()
				//				let alertViewController = UIAlertController.init(title: "Oops!", message: "Please check your network connection", preferredStyle: .alert)
				//				let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
				////					let url = URL(string: "App-Prefs:root=Privacy&path=Bluetooth") //for bluetooth setting
				////								   let app = UIApplication.shared
				////								   app.openURL(url!)
				//				})
				//				alertViewController.addAction(ok)
				//				self.present(alertViewController, animated: true, completion: nil)
				return
			}
			RemoteConfig.remoteConfig().fetchAndActivate()
			self.messageObserver()
		}
	}
	
	
	
	
	@IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
		if self.isModallyPresented == true {
			self.navigationController?.dismiss(animated: true)
		} else {
			self.navigationController?.popViewController(animated: true)
		}
	}
	
	func setDefaultRemoteConfigDefaults() {

	}
	
	private func messageObserver()  {
//		if currentReachabilityStatus != .notReachable {
//			DispatchQueue.main.async {
//				self.NoDataLabel.isHidden = false
//				self.nodataFoundLable(message: "Please check your network connection")
//			}
//		} else {
			// if net available
			remoteConfig.fetch(withExpirationDuration: 0) { [unowned self] (status, error) in
				guard error == nil else {
					self.nodataFoundLable(message: "Error Retreiving Data.Please try again later")
					return }
				print("got remote")
				remoteConfig.activate()
				self.NoDataLabel.isHidden = false
				self.modelTableView.isHidden = true
				let testableModels = remoteConfig.configValue(forKey: "testable_models").jsonValue as? AnyObject
				let array = testableModels?.value(forKey: "testableModels") as? NSArray
				guard let testableModel = array, testableModel.count > 0 else {
					self.nodataFoundLable(message: "Error Retreiving Data.Please try again later")
					return
				}
				itemDict = testableModel as? [[String : Any]]
				self.modelTableView.reloadData()
				if self.itemDict?.count ?? 0 > 0  {
					self.NoDataLabel.isHidden = true
					self.modelTableView.isHidden = false
				} else {
					self.NoDataLabel.isHidden = false
					self.modelTableView.isHidden = true
					self.nodataFoundLable(message: "Error Retreiving Data.Please try again later")
				}
			}
			
		//}
	}
	
	func nodataFoundLable(message: String) {
		DispatchQueue.main.async {
			self.NoDataLabel.text = message // message
			self.goToSettings.isHidden = true
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = modelTableView.dequeueReusableCell(withIdentifier:"TestableTableViewCell",for: indexPath) as! TestableTableViewCell
		if let vinInfor = itemDict?[indexPath.row] {
			let name = vinInfor["title"] as! String
			let year = vinInfor["yearsRange"] as! String
			let model = vinInfor["model"] as! String
			let make = vinInfor["makeString"] as! String
			cell.Name.text =  name
			cell.year.text = "Years: " + year
			cell.model.text = "Model: " + model
			cell.make.text = "Make: " + make
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemDict?.count ?? 0
	}
	
	@IBAction func goToSettingsScreen(_ sender: UIButton) {
		DispatchQueue.main.async {
			UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
		}
	}
	
}

	
