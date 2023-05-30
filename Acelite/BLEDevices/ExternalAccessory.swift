//
//  ExternalAccessory.swift
//  Acelite
//
//  Created by Gnana Thallaparthy on 30/05/23.
//

import Foundation
import ExternalAccessory

class AceliteExternalAccessory {
    static let accessoryManager = EAAccessoryManager.shared()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryConnected), name: NSNotification.Name.EAAccessoryDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(accessoryDisconnected), name: NSNotification.Name.EAAccessoryDidDisconnect, object: nil)
print("Connected/Disconnected notification centers")
		print(AceliteExternalAccessory.accessoryManager.connectedAccessories)
    }
    
    @objc func accessoryConnected(notification: NSNotification) {
		print("connected notification called")
        if let accessory = notification.userInfo?[EAAccessoryKey] as? EAAccessory {
            let session = EASession(accessory: accessory, forProtocol: "com.acelite.protocol")
            if let inputStream = session?.inputStream, let outputStream = session?.outputStream {
                // Open the input and output streams and start communication
                inputStream.open()
                outputStream.open()
                // Handle communication with the accessory
            }
        }
    }
 

    @objc func accessoryDisconnected(notification: NSNotification) {
		print("disconnected notification called")
        if let accessory = notification.userInfo?[EAAccessoryKey] as? EAAccessory {
            // Accessory disconnected, handle it
        }
    }

  

    
}
