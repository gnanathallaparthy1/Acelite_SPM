//
//  TestableTableViewCell.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/23/23.
//

import UIKit

class TestableTableViewCell: UITableViewCell {
	class var identifier: String { return String(describing: self) }
	class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
	
	@IBOutlet weak var Name: UILabel!
	
	@IBOutlet weak var year: UILabel!
	
	@IBOutlet weak var make: UILabel!
	
	@IBOutlet weak var model: UILabel!
}

