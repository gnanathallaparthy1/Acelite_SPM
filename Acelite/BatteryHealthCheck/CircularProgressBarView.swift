//
//  CircularProgressBarView.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/13/23.
//

import UIKit

class CircularProgressBarView: UIView {
	

	
	
	private var circleLayer = CAShapeLayer()
	private var progressLayer = CAShapeLayer()
//	private var startPoint = CGFloat(-Double.pi / 2)
	//private var endPoint = CGFloat(Double.pi/2)
	private var startPoint = CGFloat(-Double.pi / 2)
	private var endPoint = CGFloat(3 * Double.pi / 2)
	override init(frame: CGRect) {
		super.init(frame: frame)
		
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	
	func createCircularPath() {
			// created circularPath for circleLayer and progressLayer
			let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 100, startAngle: endPoint,
				endAngle: startPoint, clockwise: false)
			circleLayer.path = circularPath.cgPath
			// ui edits
			circleLayer.fillColor = UIColor.clear.cgColor
			circleLayer.lineCap = .round
			circleLayer.lineWidth = 7.0
			circleLayer.strokeEnd = 1.0
			circleLayer.strokeColor = UIColor.white.cgColor //AceliteColors.buttonBgColorGreen.cgColor
			// added circleLayer to layer
			layer.addSublayer(circleLayer)
			// progressLayer path defined to circularPath
			progressLayer.path = circularPath.cgPath
			// ui edits
			progressLayer.fillColor = UIColor.clear.cgColor
			progressLayer.lineCap = .round
			progressLayer.lineWidth = 7.0
			progressLayer.strokeEnd = 0
			progressLayer.strokeColor = AceliteColors.buttonBgColorGreen.cgColor//UIColor.white.cgColor
			// added progressLayer to layer
			layer.addSublayer(progressLayer)
		}
	
	func changeProgresslayerStockeColor(progress: UIColor, circle: UIColor)  {
		progressLayer.strokeColor  =  progress.cgColor
		circleLayer.strokeColor = progress.cgColor
		//circle.cgColor
		//progressLayer.strokeColor = progress.cgColor
	}
	
	func progressAnimation(duration: TimeInterval) {
		// created circularProgressAnimation with keyPath
		let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
		circleLayer.strokeColor = UIColor.white.cgColor
		// set the end time
		circularProgressAnimation.duration = duration
		circularProgressAnimation.fromValue = 1.0
		circularProgressAnimation.toValue = 0.0
		circularProgressAnimation.fillMode = .forwards
		
		circularProgressAnimation.isRemovedOnCompletion = false
		progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
	}
	
	
   
}
