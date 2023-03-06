//
//  AceLiteBleNotifyCallback.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 2/9/23.
//

import Foundation

protocol AceLiteBleNotifyCallback {

	 func onCharacteristicChanged(byteArray: Data?)

	 func onNotifyFailure(exception: Error?)
}
