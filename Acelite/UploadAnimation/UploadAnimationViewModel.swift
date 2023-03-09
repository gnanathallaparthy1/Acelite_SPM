//
//  UploadAnimationViewModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 3/6/23.
//


import Foundation
import Apollo
import UIKit


class UploadAnimationViewModel {
	public var delegate: UploadAndSubmitDataDelegate?

	init(delegate: UploadAndSubmitDataDelegate?) {
		self.delegate = delegate
	}
}
