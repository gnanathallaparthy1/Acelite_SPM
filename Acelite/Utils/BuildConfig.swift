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
}
