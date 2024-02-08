//
//  DropDownViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 2/2/24.
//

import UIKit
import iOSDropDown
class DropDownViewController: UIViewController {

	@IBOutlet weak var iOSDropDownView: DropDown!
	override func viewDidLoad() {
        super.viewDidLoad()
		DispatchQueue.main.async {
			self.iOSDropDownView.optionArray = ["Apple", "Banana", "Coconut", "Draggon fruite"]
			self.iOSDropDownView.arrowSize = 20
			self.iOSDropDownView.bringSubviewToFront(self.view)
			self.iOSDropDownView.textColor = .black
			self.iOSDropDownView.rowHeight = 50
			self.iOSDropDownView.didSelect { selectedText, index, id in
				print("Selected String: \(selectedText) \n index: \(index) \n Id: \(id)")
			}
		}
    }

}
