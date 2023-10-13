//
//  VINDataTableViewCell.swift
//  Acelite
//
//  Created by  Gnana Thallaparthy on 04.10.23.
//

import UIKit
import CoreData
class VINDataTableViewCell: UITableViewCell {

    @IBOutlet weak var ymmtLabel: UILabel!
    @IBOutlet weak var dateTimeLable: UILabel!
    @IBOutlet weak var workOrderLabel: UILabel!
    @IBOutlet weak var vinLabel: UILabel!
    
    @IBOutlet weak var uploadDataButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	func loadCellData(data: NSManagedObject) {
		

		let vehicalInformation: String = data.value(forKey: Constants.VEHICAL) as? String ?? ""
		// Decode
		let jsonDecoder = JSONDecoder()
		let stringToDataConversion = Data(vehicalInformation.utf8)
		let vehicalData = try! jsonDecoder.decode(Vehicle.self, from: stringToDataConversion)

		let vinData = vehicalData.vin
		let dateTime = data.value(forKey: Constants.DATE_TIME)
		let workOrder = data.value(forKey: Constants.WORK_ORDER)
		let ymmt = vehicalData.year
		vinLabel.text = "Vin: " + "\(vinData )"
		dateTimeLable.text = "Date-Time: " + "\(dateTime ?? "")"
		workOrderLabel.text = "Worker Order: " + "\(workOrder ?? "")"
		ymmtLabel.text = "YMMT: " + "\(ymmt )"
	}
	
    
}
