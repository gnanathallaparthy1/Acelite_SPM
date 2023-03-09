//
//  InfoPopUpViewController.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/5/23.
//

import UIKit

protocol InfoPopAlertViewDelegate {
	func removeAlert(sender: InfoPopUpViewController)
}

class InfoPopUpViewController: UIViewController {

	@IBOutlet weak var titleName: UILabel!
	
	@IBOutlet weak var leftImage: UIImageView!
	
	@IBOutlet weak var descriptionText: UILabel!
	
	@IBOutlet weak var rightImage: UIImageView!
	
	@IBOutlet weak var leftImage1: UIImageView!
	
	@IBOutlet weak var rightImage1: UIImageView!
	
	@IBOutlet weak var descriptionText1: UILabel!
	
	public var delegate: InfoPopAlertViewDelegate?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.view.layoutIfNeeded()
		self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
		self.leftImage.layer.cornerRadius = self.leftImage.frame.width/2.0
		self.leftImage.clipsToBounds = true
		self.leftImage1.layer.cornerRadius = self.leftImage.frame.width/2.0
		self.leftImage1.clipsToBounds = true
//		self.rightImage.layer.cornerRadius = self.rightImage.frame.width/2.0
//		self.rightImage.clipsToBounds = true
		
        // Do any additional setup after loading the view.
    }
    

	@IBAction func doneButtonPressed(_ sender: Any) {
		//self.dismiss(animated: true)
		self.delegate?.removeAlert(sender: self)
	}
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
