//  ssng2:OutSocket.swift
//
//  Created by 藤田 on 2021/05/28
//  Copyright 2021 KAIT. All rights reserved.

import Foundation
import CocoaAsyncSocket

class OutSocket: NSObject, GCDAsyncUdpSocketDelegate {
  var socket:GCDAsyncUdpSocket!
  let portEL = UInt16(EL.portEL)
    
    override init(){
        super.init()
        setupConnection()
    }

    func setupConnection(){
      socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
      print("OutSocket:setupConnection!", socket ?? "socket is null"
      )
    }

    func setupConnection(_ address:String){
        print("OutSocket:setupConnection \(address)")
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        do {
            try socket.connect(toHost: address, onPort: portEL)
        } catch {
            print("OutSocket:setupConnection:connectToHost:error")  // error handling
        }
    }
    
    func sendBinary(_ udpData:Data){
        socket.send(udpData, withTimeout: 2, tag: 0)
        print("OutSocket:sendBinary: \(udpData)")
    }
    func sendBinary(_ udpData:Data, address:String){
        socket.send(udpData, toHost:address, port: portEL, withTimeout: 2, tag: 0)
        print("OutSocket:sendBinary: \(address) \(udpData)")
    }
    func udpSocket(_ sock: GCDAsyncUdpSocket, didConnectToAddress address: Data) {
        print("OutSocket:didConnectToAddress")
    }
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
        print("OutSocket:didNotConnect \(String(describing: error))")
    }
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        print("OutSocket:didSendDataWithTag")
    }
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        print("OutSocket:didNotSendDataWithTag")
    }
}
