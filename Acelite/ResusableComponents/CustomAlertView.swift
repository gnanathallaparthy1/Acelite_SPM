//
//  CustomAlertView.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/5/23.
//

import Foundation
import UIKit
protocol CustomAlertViewDelegate {
	func removeAlert(sender: CustomAlertView)
}
class CustomAlertView: UIView {
	@IBOutlet weak var TitleLabel: UILabel!
	
	@IBOutlet weak var leftImageView: UIImageView!
	@IBOutlet weak var rightImageView: UIImageView!
	public var delegate: CustomAlertViewDelegate?
	private func setupView() {
	self.backgroundColor = .white
	self.layer.borderColor = UIColor.lightGray.cgColor
	self.layer.borderWidth = 1
	self.layer.cornerRadius = 4
	//self.okButton.isEnabled = false
}
	
	class func instanceFromNib() -> CustomAlertView {
		let view = UINib(nibName: "CustomAlertView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomAlertView
		view.setupView()
		return view
	}

}
