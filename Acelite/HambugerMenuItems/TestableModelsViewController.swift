//
//  TestableModelsViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/22/23.
//

import Foundation
import FirebaseDatabase
import UIKit


class TestableModelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	@IBOutlet weak var NoDataLabel: UILabel!
	
	@IBOutlet var modelTableView: UITableView!
	var ref = DatabaseReference()
	var itemDict : [[String: Any]]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		FirebaseLogging.instance.logScreen(screenName: ClassNames.testableModels)
		modelTableView.delegate = self
		modelTableView.dataSource = self
	
		self.modelTableView.register(TestableTableViewCell.nib, forCellReuseIdentifier: TestableTableViewCell.identifier)
		
		// Update TableView with the data
		
		self.ref = Database.database().reference()
		self.messageObserver()
		//self.modelTableView.reloadData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.title = "Testable Models".uppercased()
		self.navigationItem.setHidesBackButton(true, animated:true)
		
		let menuBarButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(self.menuButtonAction(_ :)))
		menuBarButton.tintColor = UIColor.appPrimaryColor()
		self.navigationItem.rightBarButtonItem  = menuBarButton
		
		
	}
	
	@IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
		self.navigationController?.dismiss(animated: true)
	}
	
	
	private func messageObserver() {
		let rootRef = Database.database().reference()
		let ref = rootRef.child("testable_models").child("items")
		let data = ref.observe(.value) { data in
			self.itemDict = data.value as? [[String: Any]]
			self.modelTableView.reloadData()
			if self.itemDict?.count ?? 0 > 0  {
				self.NoDataLabel.isHidden = true
				self.modelTableView.isHidden = false
			} else {
				self.NoDataLabel.isHidden = false
				self.modelTableView.isHidden = true
			}
		}
		
		
	}
	
	 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = modelTableView.dequeueReusableCell(withIdentifier:"TestableTableViewCell",for: indexPath) as! TestableTableViewCell
		if let person = itemDict?[0] {
			let name = person["title"] as! String
			let year = person["yearsRange"] as! String
			let model = person["model"] as! String
			let make = person["make"] as! Int
			cell.Name.text =  name
			cell.year.text = "Years: " + year
			cell.model.text = "Model: " + model
			cell.make.text = "Make: " + String(make)
		}
		
		return cell
	}
	
	 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	 return 1
	 }
	
//	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//		return 100
//	}

}

	
