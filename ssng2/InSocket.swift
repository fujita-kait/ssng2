//  ssng2:InSocket.swift
//
//  Created by 藤田 on 2021/05/28
//  Copyright 2021 KAIT. All rights reserved.
//
//  UDP の受信モジュール。CocoaAsyncSocket を利用している。
//  UDP を受信すると、
//  - 送信元の ip address を rawIP に、受信データを rawData に代入する
//  - 通知 Notification.Name("ReceiveUdpData") を送る。

import Foundation
import CocoaAsyncSocket
import Combine

class InSocket: NSObject, GCDAsyncUdpSocketDelegate {
  var rawIp = Data()
  var rawData = Data()

  private var socket:GCDAsyncUdpSocket!
  private let multicastAddress = EL.mcAddress  // multicast address for ECHONET Lite
  private let portEL = UInt16(EL.portEL)       // port number for ECHONET Lite

  override init(){
    super.init()
    setupConnection()
  }
  
  func setupConnection(){
    socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
    print("InSocket:setupConnection", socket ?? "socket is null")
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
    rawIp = address
    rawData = data
    NotificationCenter.default.post(name: Notification.Name("ReceiveUdpData"), object: nil)

    let ip = String(format: "%@", address as CVarArg)
    let dataString = String(format: "%@", data as CVarArg)
    print("InSocket IP: \(ip), Data: \(dataString)")
  }
}
