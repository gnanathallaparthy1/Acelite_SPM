//
//  CustomeView.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 9/25/23.
//

import UIKit

class CustomView: UIView {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var arrowButton: UIButton!
	var viewType: InfoWarning = .INFO
	
	@IBOutlet weak var arrowWidthConstraint: NSLayoutConstraint!
	
	override init(frame: CGRect) {
		   super.init(frame: frame)
	   }
	   
	   required init?(coder aDecoder: NSCoder) {
		   super.init(coder: aDecoder)
	   }
	
	func setupView(message: String)  {
		self.layer.cornerRadius = 8
		if viewType == .INFO {
			imageView.image = UIImage(named: "ic_info")
			self.infoLabel.text = message
			self.arrowButton.isHidden = false
			self.backgroundColor = UIColor.viewBackgroundColor()
			self.arrowWidthConstraint.constant = 25
			self.arrowButton.frame.size.width = 25
			self.layoutIfNeeded()
						
		} else {
			imageView.image = UIImage(named: "ic_warning")
			self.infoLabel.text = message
			self.arrowButton.isHidden = true		
			self.layer.borderColor = UIColor.offlineViewBorderColor().cgColor
			self.layer.borderWidth = 4
			self.backgroundColor = .white
			self.arrowWidthConstraint.constant = 0
			self.layoutIfNeeded()
			self.arrowButton.frame.size.width = 0
		}
	}
	
}
