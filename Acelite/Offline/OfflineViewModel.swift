//
//  OfflineViewModel.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 10/11/23.
//

import Foundation

enum SUBMITAPIRESPONSE {
case ERROR_ONE
	case ERROR_TWO
	case ERROR_THREE
	case ERROR_FOUR
	
}


class OfflineViewModel {
	
	var message: String = ""
	var submitApiResponse = SUBMITAPIRESPONSE.ERROR_ONE
	init(message: String, submitApiResponse: SUBMITAPIRESPONSE = SUBMITAPIRESPONSE.ERROR_ONE) {
		self.message = message
		self.submitApiResponse = submitApiResponse
	}
	
}
