//  ssng2:SendEl.swift
//
//  Created by Hiro Fujita on 2021.05.28
//  Copyright (c) 2021 Hiro Fujita. All rights reserved.

import Foundation

class SendEl {
  var tid  = Tid(d1: UInt8(0x00), d2: UInt8(0x00))
  var seoj = Eoj(d1: UInt8(0x05), d2: UInt8(0xFF), d3: UInt8(0x01))
  var deoj = Eoj(d1: UInt8(0x0E), d2: UInt8(0xF0), d3: UInt8(0x01))
  var esv  = UInt8(0x62)                  // GET
  var messages = [ElMessage]()            // Array of "EPC EDT"
  var udpData = String()                  // String format of "send data", Get only
  private var outSocket : OutSocket!      // for sending data
  
  init() {
    print("SendEl: init")
    outSocket = OutSocket()
  }
  
  // send UDP Packet with EL messages
  func send(address: String) -> Bool {
    var sendData = EL.ehd.hex
    sendData += tid.hex
    sendData += seoj.hex
    sendData += deoj.hex
    sendData += [esv]
    sendData += [UInt8(messages.count)]         // OPC
    if messages.count != 0 {
      for message in messages {
        sendData += [message.epc]
        sendData += [UInt8(message.edt.count)]  // PDC
        sendData += message.edt                 // EDT
      }
    }
    
    if esv == UInt8(0x5E) {                     // SetGet_SNA
      sendData += [UInt8(0x00)]                 // Add OPCGet = 0
    }
    
    var stringArray = sendData.map{(a: UInt8) -> String in String(format:"%02X", a)}
    stringArray.insert(" ", at: 2)
    stringArray.insert(" ", at: 5)
    stringArray.insert(" ", at: 9)
    stringArray.insert(" ", at: 13)
    stringArray.insert(" ", at: 15)
    stringArray.insert(" ", at: 17)
    stringArray.insert(" ", at: 19)
    stringArray.insert(" ", at: 21)
    udpData = stringArray.joined()
    print("SendEl:udpData \(udpData)")
    
    // send El data
    outSocket.sendBinary(Data(bytes: &sendData, count: sendData.count), address:address) // send Binary Data
    return true
  }
}
