//
//  ScanHistoryTableViewCell.swift
//  Acelite
//
//  Created by NagaKumar Ganja on 24/03/23.
//

import UIKit

class ScanHistoryTableViewCell: UITableViewCell {

	@IBOutlet weak var rangeWhenNewValueLabel: UILabel!
	@IBOutlet weak var vehicleTitleLabel: UILabel!
	@IBOutlet weak var healthLabelValue: UILabel!
	@IBOutlet weak var bodyStyleLabelValue: UILabel!
	@IBOutlet weak var modelLabelValue: UILabel!
	@IBOutlet weak var transectionIdLabelValue: UILabel!
	@IBOutlet weak var estimateRangeOnFullChargeValue: UILabel!
	@IBOutlet weak var scoreLabelValue: UILabel!
	@IBOutlet weak var dateTimeLabelValue: UILabel!
	@IBOutlet weak var workOrderLabelValue: UILabel!
	@IBOutlet weak var vinNumberLabelValue: UILabel!
	@IBOutlet weak var yearLabelValue: UILabel!
	@IBOutlet weak var makeLabel: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
