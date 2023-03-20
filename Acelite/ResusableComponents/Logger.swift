//
//  Logger.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/12/23.
//

import Foundation

struct Log: TextOutputStream {
	
	func write(_ string: String) {
		
		let text = string
		let folder = "Saved"
		let timeStamp = Date.currentTimeStamp
		let fileNamed = "Logs"
		guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
		guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else { return }
		try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
		let file = writePath.appendingPathComponent(fileNamed + ".txt")
		try? text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
		// alert
		//
		// generated file stored in your phone file folder with app name.
	}

		
//
//		let fm = FileManager.default
//		let log = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("log.txt")
//
//		if let handle = try? FileHandle(forWritingTo: file) {
//			handle.seekToEndOfFile()
//			handle.write(string.data(using: .utf8)!)
//			handle.closeFile()
//		} else {
//			try? string.data(using: .utf8)?.write(to: file)
//		}
//	}
}

var logger = Log()


