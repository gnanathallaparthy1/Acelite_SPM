//
//  AceLiteServices.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 1/26/23.
//
// https://stackoverflow.com/questions/55395589/how-to-add-header-in-apollo-graphql-ios

import Foundation
import Apollo
import Network
import UIKit
import CoreBluetooth


class Network {
	static let shared = Network()
	var vehicleInformation:  GetBatteryTestInstruction?
	var bluetoothService: BluetoothServices?
	var myPeripheral: CBPeripheral!
	public var byteDataArray: [UInt8] = []
	public var arrayOfBytesData: String = ""
	public var bleData = Data()
	public var normalCommandsList = [TestCommandExecution]()
	public var sampledCommandsList = [TestCommandExecution]()
	public var diagnosticCommand: TestCommandDiagnosticExecution?
	public var isDiagnosticSession: Bool = false
	public var batteryTestInstructionId: String?

  //  lazy var apollo = ApolloClient(url: URL.init(string: "http://countries.trevorblades.com/")!)
	lazy var apollo: ApolloClient = {

	   let cache = InMemoryNormalizedCache()
	   let store1 = ApolloStore(cache: cache)
	   let authPayloads = ["x-api-key": "0FPKgwbkWP6wkOov1jTFO2BLfWhesqBY8dPBZB45"]
	   let configuration = URLSessionConfiguration.default
	   configuration.httpAdditionalHeaders = authPayloads
		configuration.timeoutIntervalForRequest = 30.0
		configuration.timeoutIntervalForResource = 45.0
	   
	   let client1 = URLSessionClient(sessionConfiguration: configuration, callbackQueue: nil)
	   let provider = NetworkInterceptorProvider(client: client1, shouldInvalidateClientOnDeinit: true, store: store1)
	   
	   let url = URL(string: "https://api.fleet.io.nonprod.caioptimizations.com/graphql")!
	   
	   let requestChainTransport = RequestChainNetworkTransport(interceptorProvider: provider,
																endpointURL: url)
	   
	   return ApolloClient(networkTransport: requestChainTransport,
						   store: store1)
   }()
	
	
}

class NetworkInterceptorProvider: DefaultInterceptorProvider {
override func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
	var interceptors = super.interceptors(for: operation)
	interceptors.insert(CustomInterceptor(), at: 0)
	return interceptors
}
}

class CustomInterceptor: ApolloInterceptor {
	
	func interceptAsync<Operation: GraphQLOperation>(
		chain: RequestChain,
		request: HTTPRequest<Operation>,
		response: HTTPResponse<Operation>?,
		completion: @escaping (Swift.Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
			request.addHeader(name: "x-api-key", value: "0FPKgwbkWP6wkOov1jTFO2BLfWhesqBY8dPBZB45")
			
			print("request :\(request)")
			print("response :\(String(describing: response))")
			
			chain.proceedAsync(request: request,
							   response: response,
							   completion: completion)
		}
}


