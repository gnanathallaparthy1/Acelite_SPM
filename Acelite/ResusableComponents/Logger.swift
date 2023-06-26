//
//  Logger.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/12/23.
//

import Foundation

class Log: TextOutputStream {

	func write(_ string: String) {
		
		let fileManager = FileManager.default
		do {
			let path = try? fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
			let fileURL: URL = (path?.appendingPathComponent("\(Date.getCurrentDate()).txt"))!
			
			
			//let fm = FileManager.default
			//let log = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("log.txt")
			if let handle = try? FileHandle(forWritingTo: fileURL) {
				handle.seekToEndOfFile()
				handle.write(string.data(using: .utf8)!)
				handle.closeFile()
			} else {
				try? string.data(using: .utf8)?.write(to: fileURL)
			}
		}
	}
	static var log: Log = Log()
	private init() {} // we are sure, nobody else could create it
}

extension Date {

 static func getCurrentDate() -> String {

		let dateFormatter = DateFormatter()

		dateFormatter.dateFormat = "dd-MM-yyyy"

		return dateFormatter.string(from: Date())

	}
}
