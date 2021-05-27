//  SSNG:SendEl.swift
//
//  Created by Hiro Fujita on 2016.01.21
//  Copyright (c) 2016 Hiro Fujita. All rights reserved.

import Foundation

class SendEl {
  var tid  = [UInt8(0x00), UInt8(0x00)]                   // 2 byte
  var seoj = [UInt8(0x05), UInt8(0xFF), UInt8(0x01)]      // 3 byte Controller
  var deoj = [UInt8(0x0E), UInt8(0xF0), UInt8(0x01)]      // 3 byte Node
  var esv  = UInt8(0x62)                                  // GET
  var messages = [ElMessage]()            // Array of "EPC EDT"
  var udpData = String()                  // String format of "send data", Get only
  private var outSocket : OutSocket!      // for sending data
  
  init() {
    print("SendEl: init")
    outSocket = OutSocket()
  }
  
  // send UDP Packet with ElPacket
  func send(address: String) -> Bool {
    // Data size check of TID, SEOJ and DEOJ
    if (tid.count != 2) || (seoj.count != 3) || (deoj.count != 3) {
      print("SendEl:send: Data Size Error: TID, SEOJ or DEOJ")
      return false
    }
    
    //        NSNotificationCenter.defaultCenter.postNotificationName("NotificationSendElData", object: nil)
    
    // create array of UInt8 data
    var sendData = [UInt8(0x10), UInt8(0x81)]   // EHD
    sendData += tid
    sendData += seoj
    sendData += deoj
    sendData += [esv]
    sendData += [UInt8(messages.count)]         // OPC
    if messages.count != 0 {
      for message in messages {
        sendData += [message.epc]
        sendData += [UInt8(message.edt.count)]  // PDC
        sendData += message.edt             // EDT
      }
    }
    
    if esv == UInt8(0x5E) {                     // SetGet_SNA
      sendData += [UInt8(0x00)]               // Add OPCGet = 0
    }
    
    //        print("SendEl:sendData: \(sendData)")
    let udpDataTmp = sendData.map{(a: UInt8) -> String in String(format:"%02X", a)} // [UInt8] -> [String]
    udpData = udpDataTmp[0] + udpDataTmp[1] + " " + udpDataTmp[2] + udpDataTmp[3] + " " + udpDataTmp[4] + udpDataTmp[5] + udpDataTmp[6] + " " + udpDataTmp[7] + udpDataTmp[8] + udpDataTmp[9] + " " + udpDataTmp[10] + " " + udpDataTmp[11] + " "
    for i in 12 ..< udpDataTmp.count {
      udpData += udpDataTmp[i]
    }
    print("SendEl:udpData \(udpData)")
    
    // send El data
    outSocket.sendBinary(NSData(bytes: &sendData, length: sendData.count) as Data, address:address) // send Binary Data
    return true
  }
}
