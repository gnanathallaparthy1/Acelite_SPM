//
//  BluetoohClassicTableViewCell.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/8/24.
//

import UIKit

class BluetoohClassicTableViewCell: UITableViewCell {

	@IBOutlet weak var disclosureButton: UIButton!
	@IBOutlet weak var accessoryName: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		disclosureButton.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
