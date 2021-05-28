//  ssng2:ReceiveEl.swift
//
//  Created by Hiro Fujita on 2021.05.28
//  Copyright (c) 2021 Hiro Fujita. All rights reserved.

import Foundation

class ReceiveEl {
  var address = String()       // source IP Address: example: "192.168.1.2"
  var udpData = String()       // received UDP data in HEX string
  var ehd  = Ehd(d1: UInt8(), d2: UInt8())
  var tid  = Tid(d1: UInt8(), d2: UInt8())
  var seoj = Eoj(d1: UInt8(), d2: UInt8(), d3: UInt8())
  var deoj = Eoj(d1: UInt8(), d2: UInt8(), d3: UInt8())
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
  }
    
  /// Notification "ReceiveUdpData" を受信すると呼ばれるメソッド
  /// inSocket で受信したデータをParse し、ehd,tid,seoj,deoj,esv,opc,messages,opcSetGet,messagesSetGetにstoreする
  /// Parseが成功したらnotification "ReceiveElData" を送る
  @objc func receiveUdpData(_ notification: Notification) {
    messages = []
    messagesSet = []
    messagesGet = []
    let rawIp = inSocket.rawIp
    let rawData = inSocket.rawData
    
    if (rawIp.count < 8) { return }
    address = rawIp[4...7].map{(a: UInt8) -> String in String(a)}.joined(separator: ".")

    // Parse
    if  rawData.count < 14 {
      print("ReceiveEL: data is too short")
      return
    }

    ehd = Ehd(d1: rawData[0], d2: rawData[1])
    if !(ehd.d1 == UInt8(EL.ehd.d1) && ehd.d2 == UInt8(EL.ehd.d2)) {
      print("ReceiveEL: EHD ERROR \(ehd.code)")
      return
    }
    
    tid  = Tid(d1: rawData[2], d2: rawData[3])
    seoj = Eoj(d1: rawData[4], d2: rawData[5], d3: rawData[6])
    deoj = Eoj(d1: rawData[7], d2: rawData[8], d3: rawData[9])
    esv  = rawData[10]  // ESV
    opc  = rawData[11]  // OPC
    
    // idx is a pointer for rawData
    var idx = 12
    for i in 0 ..< Int(opc) {
      print("i: \(i) idx: \(idx)")
      var message = ElMessage(epc: rawData[idx], edt: [])
      let pdc = rawData[idx+1]
      if (pdc != 0) {
        message.edt.append(contentsOf:rawData[(idx+2)..<((idx+2) + Int(pdc))])
      }
      messages.append(message)
      idx += (Int(pdc) + 2)
    }
    
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
//      print("ReceiveEL: messagesSet: \(messagesSet)")
//      print("ReceiveEL: messagesGet: \(messagesGet)")
    }

    var stringArray = rawData.map{(a: UInt8) -> String in String(format:"%02X", a)}
    stringArray.insert(" ", at: 2)
    stringArray.insert(" ", at: 5)
    stringArray.insert(" ", at: 9)
    stringArray.insert(" ", at: 13)
    stringArray.insert(" ", at: 15)
    stringArray.insert(" ", at: 17)
    stringArray.insert(" ", at: 19)
    stringArray.insert(" ", at: 21)
    udpData = stringArray.joined()
    
    NotificationCenter.default.post(name: Notification.Name("ReceiveElData"), object: nil)
  }
}
