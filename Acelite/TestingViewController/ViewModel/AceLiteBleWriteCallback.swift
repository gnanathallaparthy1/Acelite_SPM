//
//  AceLiteBleWriteCallback.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 2/9/23.
//

import Foundation

protocol AceLiteBleWriteCallback {

	 func onWriteSuccess(byteArray: Data?)

	 func onWriteFailure(exception: Error?)
}
