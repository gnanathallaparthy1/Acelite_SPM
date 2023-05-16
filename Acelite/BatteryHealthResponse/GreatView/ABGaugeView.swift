//
//  ABGaugeView.swift
//


import Foundation
import UIKit
//@IBDesignable

enum VehicleGrade: String {
	case A
	case B
	case C
	case D
	case E
	
	var title: String {
		get {
			switch self {
			case .A:
				return "A"
			case .B:
				return "B"
			case .C:
				return  "C"
			case .D:
				return "D"
			case .E:
				return "E"
			}
		}
	}
}
public class ABGaugeView: UIView {
	

	@IBInspectable public var colorCodes: String = "8BAF3E,8BAF3E,8BAF3E,8BAF3E,8BAF3E"
	@IBInspectable public var alphaColorCodes: [Double] = [0.2, 0.4, 0.6, 0.8, 1.0]

	@IBInspectable public var areas: String = "20,20,20,20,20"
	@IBInspectable public var arcAngle: CGFloat = 2.6
	
	@IBInspectable public var isRoundCap: Bool = false {
		didSet {
			capStyle = isRoundCap ? .round : .square
		}
	}
	
	@IBInspectable public var blinkAnimate: Bool = true
	
	@IBInspectable public var circleColor: UIColor = UIColor.black
	@IBInspectable public var shadowColor: UIColor = UIColor.clear
	 var grade: VehicleGrade = .A
	 var scoreValue: Float = 0.0
	
	var firstAngle = CGFloat()
	var capStyle = CGLineCap.square
	
	// MARK:- UIView Draw method
	override public func draw(_ rect: CGRect) {
		drawGauge()
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		drawGauge()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		drawGauge()
	}
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		drawGauge()
	}
	
	// MARK:- Custom Methods
	func drawGauge() {
		layer.sublayers = []
		
		drawSmartArc()
		//drawSelectedSmartArc()
	}
	
	func drawSmartArc() {
		let angles = getAllAngles()
		let arcColors = colorCodes.components(separatedBy: ",")
		//let alphaColors = alphaColorCodes.components(separatedBy: ",")
		let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
		
		var arcs = [ArcModel(startAngle: angles[0],
							 endAngle: angles.last!,
							 strokeColor: shadowColor,
							 arcCap: CGLineCap.square,
							 center:CGPoint(x: bounds.width / 2, y: (bounds.height / 2)+5))]
		
		for index in 0..<arcColors.count {
			let arc = ArcModel(startAngle: angles[index], endAngle: angles[index+1],
							   strokeColor: UIColor(hex: arcColors[index], alpha: self.alphaColorCodes[index]),
								arcCap: CGLineCap.butt,
							   center: center)
			arcs.append(arc)
		}
		arcs.rearrange(from: arcs.count-1, to: 2)
		arcs[1].arcCap = self.capStyle
		arcs[2].arcCap = self.capStyle
		for i in 0..<arcs.count {
			switch scoreValue {
			case 0...1.0:
				if i == 1 {
					createArcWith(startAngle: arcs[i].startAngle, endAngle: arcs[i].endAngle, arcCap: arcs[i].arcCap, strokeColor: arcs[i].strokeColor, center: arcs[i].center, pathWidth: 18)
				} else {
					createArcWith(startAngle: arcs[i].startAngle, endAngle: arcs[i].endAngle, arcCap: arcs[i].arcCap, strokeColor: arcs[i].strokeColor, center: arcs[i].center, pathWidth: 12)
				}
			case 2.1...3.0:
				if i == 4 {
					createArcWith(startAngle: arcs[i].startAngle, endAngle: arcs[i].endAngle, arcCap: arcs[i].arcCap, strokeColor: arcs[i].strokeColor, center: arcs[i].center, pathWidth: 16)
				} else {
					createArcWith(startAngle: arcs[i].startAngle, endAngle: arcs[i].endAngle, arcCap: arcs[i].arcCap, strokeColor: arcs[i].strokeColor, center: arcs[i].center, pathWidth: 12)
				}
			case 3.1...4.0:
				if i == 5 {
					createArcWith(startAngle: arcs[i].startAngle, endAngle: arcs[i].endAngle, arcCap: arcs[i].arcCap, strokeColor: arcs[i].strokeColor, center: arcs[i].center, pathWidth: 16)
				} else {
					createArcWith(startAngle: arcs[i].startAngle, endAngle: arcs[i].endAngle, arcCap: arcs[i].arcCap, strokeColor: arcs[i].strokeColor, center: arcs[i].center, pathWidth: 12)
				}
			case 4.1...5.0:
				if i == 2 {
					createArcWith(startAngle: arcs[i].startAngle, endAngle: arcs[i].endAngle, arcCap: arcs[i].arcCap, strokeColor: arcs[i].strokeColor, center: arcs[i].center, pathWidth: 16)
				} else {
					createArcWith(startAngle: arcs[i].startAngle, endAngle: arcs[i].endAngle, arcCap: arcs[i].arcCap, strokeColor: arcs[i].strokeColor, center: arcs[i].center, pathWidth: 12)
				}
			case 1.1...2.0:
				if i == 3 {
					createArcWith(startAngle: arcs[i].startAngle, endAngle: arcs[i].endAngle, arcCap: arcs[i].arcCap, strokeColor: arcs[i].strokeColor, center: arcs[i].center, pathWidth: 16)
				} else {
					createArcWith(startAngle: arcs[i].startAngle, endAngle: arcs[i].endAngle, arcCap: arcs[i].arcCap, strokeColor: arcs[i].strokeColor, center: arcs[i].center, pathWidth: 12)
				}
			default:
				break
			}
			//based on the health score
		
			
		}
		
	}	
	
	func radian(for area: CGFloat) -> CGFloat {
		let degrees = arcAngle * area
		let radians = degrees * .pi/180
		return radians
	}
	
	func getAllAngles() -> [CGFloat] {
		var angles = [CGFloat]()
		firstAngle = radian(for: 0) + .pi/2
		var lastAngle = radian(for: 100) + .pi/2
		
		let degrees:CGFloat = 3.6 * 100
		let radians = degrees * .pi/(1.8*100)
		
		let thisRadians = (arcAngle * 50) * .pi/(1.8*100)
		let theD = (radians - thisRadians)/4
		firstAngle += theD
		lastAngle += theD
		
		angles.append(firstAngle)
		let allAngles = self.areas.components(separatedBy: ",")
		for index in 0..<allAngles.count {
			let n = NumberFormatter().number(from: allAngles[index])
			let angle = radian(for: CGFloat(truncating: n!)) + angles[index]
			angles.append(angle)
		}
		
		angles.append(lastAngle)
		return angles
	}
	
	func createArcWith(startAngle: CGFloat, endAngle: CGFloat, arcCap: CGLineCap, strokeColor: UIColor, center:CGPoint, pathWidth: CGFloat) {
		// 1
		let center = center
		let radius: CGFloat = max(bounds.width, bounds.height)/5 - self.frame.width/17
		//let lineWidth: CGFloat = self.frame.width/10
		// 2
		let path = UIBezierPath(arcCenter: center,
								radius: radius,
								startAngle: startAngle,
								endAngle: endAngle,
								clockwise: true)
		// 3
		path.lineWidth = pathWidth
		path.lineCapStyle = .butt
		strokeColor.setStroke()
		path.stroke()
	}
   
}
