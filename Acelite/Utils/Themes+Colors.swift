//
//  Themes+Colors.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 2/8/23.
//

import UIKit

extension UIColor {
	// MARK: - Color codes used in the app -
	/**
	 List of Color code Constants used in the app
	 */
	/*
	 <color name="purple_200">#FFBB86FC</color>
	 <color name="purple_500">#FF6200EE</color>
	 <color name="purple_700">#FF3700B3</color>
	 <color name="teal_200">#FF03DAC5</color>
	 <color name="teal_700">#FF018786</color>
	 <color name="black">#FF000000</color>
	 <color name="white">#FFFFFFFF</color>
	 <color name="green">#5B7C3B</color>
	 <color name="gray">#F8F8F8</color>
	 <color name="darkGray">#B3B3B3</color>
	 <color name="statusBarGray">#F2F3F2</color>
	 <color name="grayCardBg">#F6F7F8</color>
	 <color name="headText">#333333</color>
	 <color name="transparent">#00000000</color>
	 <color name="hot_red">#FE6358</color>
	 <color name="cold_gray">#99A5B3</color>

	 <color name="green_d">#CC8BAF3E</color>
	 <color name="green_a">#338BAF3E</color>
	 <color name="green_f">#5B7C3B</color>
	 <color name="green_b">#668BAF3E</color>
	 <color name="green_e">#8BAF3E</color>
	 <color name="green_c">#998BAF3E</color>
	 */
	struct Colors {
		static let appPurple200  = "#FFBB86FC" //"#007988" // F8C43B
		static let appPurple500  = "#FF6200EE"
		static let appPurple700  = "#FF3700B3"
		static let appTeal200 = "#FF03DAC5"
		static let appTeal700 = "#FF018786"
		static let appBlack = "#FF000000"
		static let appWhite = "#FFFFFFFF"
		static let appGreen = "#5B7C3B"
		static let appGray = "#F8F8F8"
		static let appDarkGray = "#B3B3B3"
		static let coldGray  = "#99A5B3"
		static let appstatusBarGray = "#F2F3F2"
		static let appgrayCardBg = "#F6F7F8"
		static let headText = "#333333"
		static let transparent = "#00000000"
		static let hotRed  = "#FE6358"
		static let bodySubtitleTextColor = "#2F3138"
		static let warningColor = "#DB5C58"
		static let offileViewBorder = "#A10B00"
		static let viewBackgroundColor = "#F2F2F7"
		//static let infoIconCOlor =  "#0041C2"
	}

	// MARK: - Initializations -

	/**
	 Initializes the UIColor using hexa color code and alpha value
	 - Parameter hexString: the hexa color code with or without '#'
	 - Parameter alpha: transparency to be applied between 0.0 to 1.0, defaults to 1.0
	 */
	convenience init(hexString: String, alpha: CGFloat = 1.0) {
		let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		let scanner = Scanner(string: hexString)
		if hexString.hasPrefix("#") {
			scanner.scanLocation = 1
		}
		var color: UInt32 = 0
		scanner.scanHexInt32(&color)
		let mask = 0x000000FF
		let rInt = Int(color >> 16) & mask
		let gInt = Int(color >> 8) & mask
		let bInt = Int(color) & mask

		let red = CGFloat(rInt) / 255.0
		let green = CGFloat(gInt) / 255.0
		let blue = CGFloat(bInt) / 255.0
		
		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}
	/**
	 Converts UIColor to hexa colorcode
	 - returns: the hexa color code of the UIColor prefixed with #
	 */
	func toHexString() -> String {
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0
		return String(format: "#%06x", rgb)
	}

	/// Checks whether the color is bright shaded or dark shaded
	/// - Parameter color: the given color to be checked
	/// - returns: true - for bright colors, false - for dark colors, default - true when color components are undefined
	func isBrightColor() -> Bool {
		guard let colors: [CGFloat] = self.cgColor.components else { return true }
		let colorBrightness: CGFloat = ((colors[0] * 299) + (colors[1] * 587) + (colors[2] * 114)) / 1000
		return colorBrightness >= 0.5
	}

	// MARK: - UIColors used in the app -
	
	class func appPrimaryColor() -> UIColor {
		return UIColor(hexString: Colors.appGreen, alpha: 1.0)
	}
	
	class func appDarkTextColor() -> UIColor {
		return UIColor(hexString: Colors.appDarkGray, alpha: 1.0)
	}

	class func appLightTextColor() -> UIColor {
		return UIColor(hexString: Colors.appGray, alpha: 1.0)
	}
	
	class func appCalendarLightGrayColor() -> UIColor {
		return UIColor(hexString: Colors.coldGray, alpha: 1.0)
	}
	class func appCalendarSelectBGColor() -> UIColor {
		return UIColor(hexString: Colors.appgrayCardBg, alpha: 1.0)
	}
	
	class func appBGColor() -> UIColor {
		return UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1) //UIColor(hexString: Colors.appScreenBG, alpha: 1.0)
	}
	
	class func appRedColor() -> UIColor {
		return UIColor(hexString: Colors.hotRed, alpha: 1.0)
	}
	
	class func bodySubtitleTextColor() -> UIColor {
		return UIColor(hexString: Colors.bodySubtitleTextColor, alpha: 1.0)
	}
	class func warningColor() -> UIColor {
		return UIColor(hexString: Colors.warningColor, alpha: 1.0)
	}
	class func offlineViewBorderColor() -> UIColor {
		return UIColor(hexString: Colors.offileViewBorder, alpha: 1.0)
	}
	
	class func viewBackgroundColor() -> UIColor {
		return UIColor(hexString: Colors.viewBackgroundColor, alpha: 1.0)
	}
	
	
	//bodySubtitleTextColor
	
}
