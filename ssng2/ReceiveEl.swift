//  ssng2:ReceiveEl.swift
//
//  Created by Hiro Fujita on 2021.05.14
//  Copyright (c) 2021 Hiro Fujita. All rights reserved.

import Foundation

class ReceiveEl {
  var address = String()       // source IP Address: example: "192.168.1.2"
  var udpData = String()       // received UDP data in HEX string
  var ehd  = [UInt8(), UInt8()]           // 2 bytes
  var tid  = [UInt8(), UInt8()]           // 2 bytes
  var seoj = [UInt8(), UInt8(), UInt8()]  // 3 bytes
  var deoj = [UInt8(), UInt8(), UInt8()]  // 3 bytes
  var esv  = UInt8()
  var opc  = UInt8()
  var messages = [ElMessage]()
  var messagesSet = [ElMessage]() // for SetGet
  var messagesGet = [ElMessage]() // for SetGet
  private var opcSetGet  = UInt8()        // for SetGet:OPCGet (ESV = 0x6E)
  private var messagesSetGet = [ElMessage]()
  private var inSocket : InSocket!        // receive UDP data
  
  init() {
    print("ReceiveEl: init")
    inSocket = InSocket()           // start receiving UDP data
    // Receive Notification "ReceiveUdpData" from inSocket, then call a function receiveUdpData
    NotificationCenter.default.addObserver(self, selector: #selector(receiveUdpData(_:)), name: Notification.Name("ReceiveUdpData"), object: nil)
    //        NSNotificationCenter.defaultCenter.addObserver(self, selector: #selector(ReceiveEl.receiveUdpData(_:)), name: "NotificationReceiveUdpData", object: nil)
    //        NSNotificationCenter.defaultCenter.addObserver(self, selector: #selector(ReceiveEl.updateUDPSocket(_:)), name: "UIApplicationDidBecomeActiveNotification", object: nil)
    //        NSNotificationCenter.defaultCenter.addObserver(self, selector: #selector(ReceiveEl.closeUDPSocket(_:)), name: "UIApplicationWillResignActiveNotification", object: nil)
  }
  
  /// UIApplicationDidBecomeActiveNotificationを受信時に実行するfunction
  /// Receive用のsocketを作成する
  @objc func updateUDPSocket(_ notification: Notification) {
    inSocket.setupConnection()
  }
  
  /// UIApplicationWillResignActiveNotificationを受信時に実行するfunction
  /// Receive用のsocketをcloseする
  @objc func closeUDPSocket(_ notification: Notification) {
    inSocket.closeUdpSocket()
  }
  
  /// Notification "ReceiveUdpData" を受信すると呼ばれるメソッド
  /// inSocketで受信したデータをParseする。
  /// Parse結果はehd,tid,seoj,deoj,esv,opc,messages,opcSetGet,messagesSetGetにstoreする
  /// Parseが成功したらnotification "ReceiveElData" を送る
  @objc func receiveUdpData(_ notification: Notification) {
    messages = []
    messagesSet = []
    messagesGet = []
    let rawIp = inSocket.rawIp
    let rawData = inSocket.rawData
    
    if (rawIp.count < 8) { return }
    let addressTmp = rawIp[4...7].map{(a: UInt8) -> String in String(a)}   // [UInt8] -> [String]
    address = addressTmp.joined(separator: ".")
    
    // Parse
    if  rawData.count < 14 {
      print("ReceiveEL: data is too short")
      return
    } // ignore too short message as ECHONET Lite

    ehd[0] = rawData[0]; ehd[1] = rawData[1]  // EHD
    // EHD should be ECHONET Lite compliant
    if !(ehd[0] == UInt8(0x10) && ehd[1] == UInt8(0x81)) {
      print("ReceiveEL: EHD ERROR \(ehd[0]) \(ehd[1])")
      return
    }
    
    tid[0]  = rawData[2]; tid[1]  =  rawData[3] // TID
    seoj[0] = rawData[4]; seoj[1] = rawData[5]; seoj[2] = rawData[6] // SEOJ
    deoj[0] = rawData[7]; deoj[1] = rawData[8]; deoj[2] = rawData[9] // DEOJ
    esv     = rawData[10]  // ESV
    opc     = rawData[11]  // OPC
    
    // idx is a pointer for rawData
    var idx = 12
    for i in 0 ..< Int(opc) {
      print("i: \(i) idx: \(idx)")
      var message = ElMessage(epc: rawData[idx], edt: [])
      let pdc = rawData[idx+1]
      if (pdc != 0) {
        message.edt.append(contentsOf:rawData[(idx+2)..<((idx+2) + Int(pdc))])
      }
      print("ReceiveEL: message: \(message)")
      messages.append(message)
      idx += (Int(pdc) + 2)
    }
    print("ReceiveEL: messages: \(messages)")
    
    // For SetGet
    if (esv == UInt8(0x5E)) || (esv == UInt8(0x6E)) || (esv == UInt8(0x7E)) {     // SetGet
      print("ReceiveEL: SetGet")
      messagesSet = messages
      opc     = rawData[idx]  // OPCGet
      idx += 1
      for _ in 0 ..< Int(opc) {
        var message = ElMessage(epc: rawData[idx], edt: [])
        let pdc = rawData[idx+1]
        if (pdc != 0) {
          message.edt.append(contentsOf:rawData[(idx+2)..<((idx+2) + Int(pdc))])
        }
        print("message: \(message)")
        messagesGet.append(message)
        idx += (Int(pdc) + 2)
      }
      print("ReceiveEL: messagesSet: \(messagesSet)")
      print("ReceiveEL: messagesGet: \(messagesGet)")
    }
    
    let dataString = rawData.map{(a: UInt8) -> String in String(format:"%02X", a)}   // [UInt8] -> [String]
    let dataEHD  = dataString[0] + dataString[1]
    let dataTID  = dataString[2] + dataString[3]
    let dataSEOJ = dataString[4] + dataString[5] + dataString[6]
    let dataDEOJ = dataString[7] + dataString[8] + dataString[9]
    let dataESV  = dataString[10]
    let dataOPC  = dataString[11]
    let dataEPC  = dataString[12]
    let dataPDC  = dataString[13]
    udpData = dataEHD + " " + dataTID + " " + dataSEOJ + " " + dataDEOJ + " " + dataESV + " " + dataOPC + " " + dataEPC + " " + dataPDC + " "
    udpData += dataString[14...].joined()
    NotificationCenter.default.post(name: Notification.Name("ReceiveElData"), object: nil)
  }
}
