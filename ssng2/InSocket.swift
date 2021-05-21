//
//  InSocket.swift
//
//  Created by 藤田 on 2020/02/28.
//  Copyright 2020 KAIT. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
import Combine

class InSocket: NSObject, GCDAsyncUdpSocketDelegate {
  var ip = ""
  var dataString = ""
  var rawIp = Data()
  var rawData = Data()
  var socket:GCDAsyncUdpSocket!
  let multicastAddress = "224.0.23.0"
  let portEL = UInt16(3610)
  
  override init(){
    super.init()
    setupConnection()
  }
  
  func setupConnection(){
    print("InSocket:setupConnection")
    socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
    
    do {
      try socket.bind(toPort: portEL)
    } catch { print("InSocket:socket.bindToPort:error", error)            // error handling
    }
    
    do {
      try socket.enableBroadcast(true)
    } catch { print("InSocket:socket.enableBroadcast:error", error)       // error handling
    }
    
    do {
      try socket.joinMulticastGroup(multicastAddress)
    } catch {  print("InSocket:socket.joinMulticastGroup:error", error)   // error handling
    }
    
    do {
      try socket.beginReceiving()
    } catch { print("InSocket:socket.beginReceiving:error", error)         // error handling
    }
  }
  
  func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error:Error?) {
    print("InSocket:udpSocketDidClose")
  }
  
  func closeUdpSocket() {
    print("InSocket:closeUdpSocket")
    socket.close()
  }
  
  func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data,
                 fromAddress address: Data, withFilterContext filterContext: Any?) {
    ip = String(format: "%@", address as CVarArg)
    dataString = String(format: "%@", data as CVarArg)
    rawIp = address
    rawData = data
    print("InSocket:udpSocket: IP: \(ip), Data: \(dataString)")
    NotificationCenter.default.post(name: Notification.Name("ReceiveUdpData"), object: nil)
  }
}
