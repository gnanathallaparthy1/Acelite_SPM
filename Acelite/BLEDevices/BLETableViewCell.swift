//
//  BLETableViewCell.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 1/6/23.
//

import UIKit

class BLETableViewCell: UITableViewCell {

	@IBOutlet weak var testButton: UIButton!
	@IBOutlet weak var connectButton: UIButton!
	@IBOutlet weak var bleNameLable: UILabel!	
	@IBOutlet weak var bleAddress: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		testButton.layer.cornerRadius = 10.0
		connectButton.layer.cornerRadius = 10.0
		testButton.frame.size.width = 50
		connectButton.frame.size.width = 110
		
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
