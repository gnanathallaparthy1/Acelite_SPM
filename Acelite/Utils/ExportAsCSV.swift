//
//  ExportAsCSV.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 2/24/23.
//

import Foundation

class CSVFile {
	
	var fileName: String?
	
	init( fileName: String) {
		self.fileName = fileName
		
	}
	
	//TO-DO test method Method will remove
//	func generateCSVFile() -> String {
//
//		let urlPath = creatCSV(data: self.csvTagsArray ?? [[0.0]])
//		print(urlPath)
//		return urlPath.absoluteString
//	}
	
	
	func creatCSVForArray(data: [Double]) -> URL {
		var csvText = ""
		var newLine = ""
		for item in data {
			
				newLine += "\(item)"
			
			newLine += "\n"
		}
		csvText.append(newLine)
		let fileManager = FileManager.default
		do {
			let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
			let fileURL = path.appendingPathComponent("\(self.fileName ?? "nofilename").csv")
			try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
			return fileURL
		} catch {
			print("error creating file")
			return URL.init(fileURLWithPath: "")
		}
	}
	
	
// MARK: CSV file creating
 
	func creatCSVForCellVoltage(data: [[Double]]) -> URL {
		var csvText = ""
		var newLine = ""
		for item in data {
			for value in item {
				newLine += "\(value),"
			}
			newLine.remove(at: newLine.index(before: newLine.endIndex))
			newLine += "\n"
		}
		csvText.append(newLine)
		let fileManager = FileManager.default
		do {
			let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
			let fileURL = path.appendingPathComponent("\(self.fileName ?? "nofilename").csv")
			try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
			return fileURL
		} catch {
			print("error creating file")
			return URL.init(fileURLWithPath: "")
		}
	}
}
