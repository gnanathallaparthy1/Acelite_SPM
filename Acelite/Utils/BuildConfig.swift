//
//  BuildConfig.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 1/26/23.
//

import Foundation

public final class BuildConfig {
   static let DEBUG = true
 static let APPLICATION_ID = "com.coxauto.acelite.nonprod"
   static let BUILD_TYPE = "debug"
   static let FLAVOR = "nonprod"
   static let VERSION_CODE = 1
   static  let VERSION_NAME = "1.0-debug"
  // Field from product flavor: nonprod
  static  let GRAPHQL_BASE_URL = "api.fleet.io.nonprod.caioptimizations.com"
  // Field from product flavor: nonprod
   static  let GRAPHQL_ENDPOINT = "/graphql"
  // Field from product flavor: nonprod
  static  let GRAPHQL_SCHEME = "https://"
  // Field from product flavor: nonprod
   static  let HEADER_GRAPHQL = "0FPKgwbkWP6wkOov1jTFO2BLfWhesqBY8dPBZB45"
	
	
	
	static let PROD_GRAPHQL_BASE_URL = "api.fleet.io.caioptimizations.com"
	static let PROD_HEADER_GRAPHQL = "xZx5AtQHzY05ZzUgZpQitRYYVc9XjTtV3Un9Ow3Pm3DRuzjt"
	
	
	func getBaseUrl() -> String {
	#if DEV
		return "\(BuildConfig.GRAPHQL_SCHEME + BuildConfig.GRAPHQL_BASE_URL + BuildConfig.GRAPHQL_ENDPOINT)"
	#else
		return "\(BuildConfig.GRAPHQL_SCHEME + BuildConfig.PROD_GRAPHQL_BASE_URL + BuildConfig.GRAPHQL_ENDPOINT)"
	#endif
	}
	
	func getXapiKey() -> String {
		#if DEV
			return "\(BuildConfig.HEADER_GRAPHQL)"
		#else
			return "\(BuildConfig.PROD_HEADER_GRAPHQL)"
		#endif
	}
	
}
