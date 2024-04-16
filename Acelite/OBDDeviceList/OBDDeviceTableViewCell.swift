//
//  OBDDeviceTableViewCell.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/12/24.
//

import UIKit

class OBDDeviceTableViewCell: UITableViewCell {

	@IBOutlet weak var obdDeviceImage: UIImageView!
	@IBOutlet weak var obdDeviceName: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		obdDeviceImage.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
