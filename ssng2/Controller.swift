//  SSNG:Controller.swift
//
//  Created by Hiro Fujita on 2016.02.10, update on 2016.03.31, 2016.06.10
//  Copyright (c) 2016 Hiro Fujita. All rights reserved.

import Foundation

class Controller: ObservableObject {
  let myIpList = getIFAddresses()
  let esvList: [UInt8] = [0x61, 0x62, 0x73]
  @Published var nodes: [Node] = [ EL.defaultNode ]
  @Published var selectedNode: Int = 0 {
    didSet {
      selectedEoj = 0
      selectedEsv = 1 // 0x62
      selectedEpc = 0
      selectedEdt = 0
      idPvEoj = UUID()  // Update PickerView(EOJ)
      idPvEsv = UUID()  // Update PickerView(ESV)
      idPvEpc = UUID()  // Update PickerView(EPC)
      idPvEdt = UUID()  // Update PickerView(EDT)
      print("PV-IP changed, selectedNode: \(selectedNode)")
    }
  }
  @Published var selectedEoj: Int = 0 {
    didSet {
      print("PV-EOJ changed, selectedEoj: \(selectedEoj)")
    }
  }

  @Published var selectedEsv: Int = 1 {
    didSet {
      print("PV-ESV changed, selectedEsv: \(selectedEsv)")
    }
  }

  @Published var selectedEpc: Int = 0 {
    didSet {
      print("PV-EPC changed, selectedEpc: \(selectedEpc)")
    }
  }

  @Published var selectedEdt: Int = 0 {
    didSet {
      print("PV-EDT changed, selectedEdt: \(selectedEdt)")
    }
  }

  // idx is updated to redraw PickerView
  @Published var idPvNode: UUID = UUID() // id for PickerView(Node)
  @Published var idPvEoj: UUID = UUID() // id for PickerView(EOJ)
  @Published var idPvEsv: UUID = UUID() // id for PickerView(ESV)
  @Published var idPvEpc: UUID = UUID() // id for PickerView(EPC)
  @Published var idPvEdt: UUID = UUID() // id for PickerView(EDT)

  // for PickerView
  var addressList: [String] {
    nodes.map { (node) in
      node.address
    }
  }
  var eojCodeList: [String] {
    nodes[selectedNode].eojs.map { (eoj) in
      eoj.code
    }
  }
  var esvCodeList: [String] {
    esvList.map{(a: UInt8) -> String in String(format:"%02X", a)}
  }
  var epcCodeList: [String] {
    [String](EL.esv.keys).sorted()
  }

  @Published var udpSentData = String()   // View Tx: sent UDP data in HEX string
  @Published var address = String()       // View Rx: source IP Address: example: "192.168.1.2"
  @Published var udpData = String()       // View Rx data: received UDP data in HEX string
  @Published var rxEpc = String()       // View Rx epc
  @Published var rxEdt = String()       // View Rx edt

  var receiveEl: ReceiveEl!    // for receiving data
  var sendEl: SendEl!          // for sending data
  var infomation = String()
  private var tid = UInt8(0x00)
  private var findDevice = (ip: "", tid: UInt8(0x00))     // for findDevice method
  
  init() {
    receiveEl = ReceiveEl()
    sendEl = SendEl()
    // Receive Notification "receiveElData" from inSocket, then call a function receiveElData
    NotificationCenter.default.addObserver(self, selector: #selector(receiveElData(_:)), name: Notification.Name("ReceiveElData"), object: nil)
  }
  
  /// Notification "receiveElData" を受信すると呼ばれるメソッド
  @objc func receiveElData(_ notification: Notification) {
    address = receiveEl.address
    udpData = receiveEl.udpData
    let esv = receiveEl.esv
    let seoj = receiveEl.seoj
    let epc = receiveEl.messages[0].epc
    rxEpc = ""
    rxEdt = ""
    
//    switch receiveEl.esv {
    switch esv {
    case 0x60, 0x61:  // SetI or SetC
      break
    case 0x62:  // Get: reply to 80, 8A and D6
      switch receiveEl.messages[0].epc {
      case 0x80:
        let message = ElMessage(epc: UInt8(0x80), edt: [0x30])
        sendEl.messages = []
        sendEl.messages.append(message)
        sendGetRes()
      case 0x8A:  // maker code
        let message = ElMessage(epc: UInt8(0x8A), edt: [0x00, 0x00, 0x77])
        sendEl.messages = []
        sendEl.messages.append(message)
        sendGetRes()
      case 0xD6:  // instance list
        if receiveEl.deoj == [0x0E, 0xF0, 0x01] {  // node only
          let message = ElMessage(epc: UInt8(0xD6), edt: [0x01, 0x05, 0xFF, 0x01])
          sendEl.messages = []
          sendEl.messages.append(message)
          sendGetRes()
        }
      default:
        sendEl.messages = receiveEl.messages
        sendSNA()
      }
    case 0x63:  // INF_Req
      break
    case 0x72, 0x73:  // Get_Res(0x72) or INF(0x73)
      print("case 0x72 0x73")
      rxEpc = String(format:"%02X", receiveEl.messages[0].epc)
      rxEdt = String(receiveEl.messages[0].edt.map{(a: UInt8) -> String in String(format:"%02X", a)}.joined())
//      infomation = ""

//      switch receiveEl.messages[0].epc {
      switch epc {
      // Instance ListS: append a node to nodes
//      case UInt8(0xD5), UInt8(0xD6):
      case 0xD5, 0xD6:
        print("case EPC:D5, D6")
        if myIpList.contains(address) {
          print("\(address) is loopback, ignore")
          return
        }
        if addressList.contains(address) {
          print("\(address) is already in the IP list, ignore")
          return
        }
        let instanceList = receiveEl.messages[0].edt
//        print("instanceList: \(instanceList)")
        var node = Node(address: address, makerCode: "", eojs: [])
        for i in 0...(Int(instanceList[0])-1) {
          node.eojs.append(Eoj(d1: instanceList[3*i+1], d2: instanceList[3*i+2], d3: instanceList[3*i+3]))
        }
//        print("node: \(node)")
        nodes.append(node)
        idPvNode = UUID()  // update PV IP
        idPvEoj = UUID()  // update PV DEOJ
        elGet(address: address, epc: 0x8A)  // Get maker code
//        getMakerCode(ipAddress: address)
        for eoj in node.eojs {
          elGet(address: address, deoj:eoj.hex, epc: 0x9D)
          elGet(address: address, deoj:eoj.hex, epc: 0x9E)
          elGet(address: address, deoj:eoj.hex, epc: 0x9F)
        }
      
      // Maker Code: append Maker Code to a node
//      case UInt8(0x8A):
      case 0x8A:
        print("case EPC:8A")
        let makerCode = receiveEl.messages[0].edt
        if makerCode.count == 3 {
          for (index, node) in nodes.enumerated() {
            if node.address == address {
              nodes[index].makerCode = makerCode.map{(a: UInt8) -> String in String(format:"%02X", a)}.joined()
              print("node.makerCode: \(node.makerCode)")
//              print("nodes: \(nodes)")
            }
          }
        }
      
      // Property Map: Decode EDT data and append it to a node
//      case UInt8(0x9D): // inf
      case 0x9D, 0x9E, 0x9F: // inf, set, get property map
        print("case EPC:9D, 9E, 9F")
        for (index, node) in nodes.enumerated() {
//          print("index \(index)")
          if node.address == address {
            for var eoj in nodes[index].eojs {
              if eoj.hex == seoj {
//                print("epc \(epc)")
                if epc == 0x9D {
                  eoj.instanceListInf = decodePropertyMap(edt: receiveEl.messages[0].edt)
                  print("instanceListInf: \(String(describing: eoj.instanceListInf))")
                } else if epc == 0x9E {
                  eoj.instanceListSet = decodePropertyMap(edt: receiveEl.messages[0].edt)
                  print("instanceListSet: \(String(describing: eoj.instanceListSet))")
                } else {
                  eoj.instanceListGet = decodePropertyMap(edt: receiveEl.messages[0].edt)
                  print("instanceListGet: \(String(describing: eoj.instanceListGet))")
                }
              }
            }
          }
        }

      case UInt8(0x9E): // Set
        print("9E")

      case UInt8(0x9F): // Get
        print("9F")

//        infomation = propertyMap(edt: receiveEl.messages[0].edt)
      case UInt8(0x80):   // for method "findDevice"
        if findDevice.ip != "" {
          if receiveEl.address == findDevice.ip {
            findDeviceSendSet(ipAddress: receiveEl.address, getRes: receiveEl.messages[0].edt[0])
          }
        }
        findDevice.ip = ""
      default: break
      }
    case 0x74:  // INFC
      break
    case 0x6E:  // SetGet -> send SetGet_SNA
      sendEl.messages = []
      sendSNA()
      print("Obj:ESV=0x5E:SetGet_SNA, send SNA: \(sendEl.esv)")
    default:
      print("Obj:ESV error \(receiveEl.esv)")
    }
  }

    //    ips = ["224.0.23.0"]
//    for node in nodeList {
//      ips.append(node.ip)
//    }
    //    ips = Array(nodeList.keys)
    //    ips = ["192.168.0.1","192.168.0.2","192.168.0.3"]
//    print(ips)
  
//  func clearNodeList() {
//    nodeList = [NodeInfo(ip: "224.0.23.0")]
//    ips = ["224.0.23.0"]
//  }
  
  /// Send data based on PV
  func send(address: String, deoj:[UInt8], esv:UInt8, epc:UInt8, edt:[UInt8]) {
    var message = ElMessage(epc: UInt8(0x00), edt: [])
    message.epc = epc
    message.edt = []
    sendEl.tid = [0x00, tid]
    sendEl.seoj = [0x05, 0xFF, 0x01]    // controller
    sendEl.deoj = deoj    // node
    sendEl.esv  = esv                  // Get
    // Set EDT data in case of SETC(0x60) or SETI(0x61)
    if (esv == UInt8(0x60)) || (esv == UInt8(0x61)) {
      message.edt = edt
    }
    sendEl.messages = [message]
    if (!sendEl.send(address: address)) {
      print("Send failed")
    }
    udpSentData = sendEl.udpData
    tid = incrementTid(tid: tid)     // update on 2016.03.26
  }
  
  func sendGetRes() {
    sendEl.tid = receiveEl.tid
    sendEl.seoj = receiveEl.deoj
    sendEl.deoj = receiveEl.seoj
    sendEl.esv  =  0x72                 // GET_RES
    if (!sendEl.send(address: receiveEl.address)) {
      print("Send failed")
    }
    print("Obj:sendGetRes")
  }
  
  func sendSNA() {
    sendEl.tid = receiveEl.tid
    sendEl.seoj = receiveEl.deoj
    sendEl.deoj = receiveEl.seoj
    switch receiveEl.esv {
    case 0x60:  // SetI
      sendEl.esv = 0x50   // SetI_SNA
    case 0x61:  // SetC
      sendEl.esv = 0x51   // SetC_SNA
    case 0x62:  // Get
      sendEl.esv = 0x52   // GET_SNA
    case 0x63:  // INF_Req
      sendEl.esv = 0x53   // INF_SNA
    case 0x6E:  // SetGet
      sendEl.esv = 0x5E   // SetGet_SNA
    default:
      return
    }
    if (!sendEl.send(address: receiveEl.address)) {
      print("Send failed")
    }
    print("Obj:sendSNA: \(sendEl.esv)")
  }

  /// Send ECHONET Lite Get message
  func elGet(address: String = "224.0.23.0", deoj: [UInt8] = [0x0E, 0xF0, 0x01], epc: UInt8) {
    let message = ElMessage(epc: UInt8(epc), edt: [])
    sendEl.tid = [0x00, tid]
    sendEl.seoj = [0x05, 0xFF, 0x01]    // controller
    sendEl.deoj = deoj    // node
    sendEl.esv  = 0x62                  // Get
    sendEl.messages = [message]
    if (!sendEl.send(address: address)) {
      print("Send failed")
    }
    tid = incrementTid(tid: tid)     // update on 2016.03.26
  }

  func search() {
    elGet(epc: 0xD6)
  }

//  /// Send Get(DEOJ:node, EPC:D6) to Multicast Address
//  func search() {
//    var message = ElMessage(epc: UInt8(0x00), edt: [])
//    // create message
//    message.epc = 0xD6                  // instance list S
//    sendEl.tid = [0x00, tid]
//    sendEl.seoj = [0x05, 0xFF, 0x01]    // controller
//    sendEl.deoj = [0x0E, 0xF0, 0x01]    // node
//    sendEl.esv  = 0x62                  // Get
//    sendEl.messages = [message]
//    if (!sendEl.send(address: "224.0.23.0")) {
//      print("Send failed to 224.0.23.0")
//    }
//    tid = incrementTid(tid: tid)     // update on 2016.03.26
//  }
  
  /// Send INF(DEOJ:node, EPC:D5) to Multicast Address
  func infD5() {
    var message = ElMessage(epc: UInt8(0x00), edt: [])
    // create message
    message.epc = 0xD5                  // instance list
    message.edt = [0x01, 0x05, 0xFF, 0x01]
    sendEl.tid = [0x00, tid]
    sendEl.seoj = [0x05, 0xFF, 0x01]    // controller
    sendEl.deoj = [0x0E, 0xF0, 0x01]    // node
    sendEl.esv  = 0x73                  // INF
    sendEl.messages = [message]
    if (!sendEl.send(address: "224.0.23.0")) {
      print("Send failed to 224.0.23.0")
    }
    tid = incrementTid(tid: tid)     // update on 2016.03.26
  }
  
  /// Send Get(DEOJ:node, EPC:8A) to Unicast Address
//  func getMakerCode(ipAddress: String) {
//    let message = ElMessage(epc: UInt8(0x8A), edt: [])
////    message.epc = 0x8A                  // maker code
//    sendEl.tid = [0x00, tid]
//    sendEl.seoj = [0x05, 0xFF, 0x01]    // controller
//    sendEl.deoj = [0x0E, 0xF0, 0x01]    // node
//    sendEl.esv  = 0x62                  // Get
//    sendEl.messages = [message]
//    if (!sendEl.send(address: ipAddress)) {
//      print("Send failed")
//    }
//    tid = incrementTid(tid: tid)     // update on 2016.03.26
//  }
  
  /// Increment TID   // update on 2016.03.26
  func incrementTid(tid: UInt8) -> UInt8 {
    var tmp = tid
    if tid == 0xFF {
      tmp = 0
    } else {
      tmp += 1
    }
    return tmp
  }
  
  // decode property map
  func decodePropertyMap(edt: [UInt8]) -> [UInt8] {
    var propertyArray = [UInt8]()
    var bitmapArray = [UInt8]()
//    var propertyStringArray = [String]()
    
    switch edt.count {
    case 0:
      return []
    case 1...16:
      propertyArray = Array(edt[1..<edt.count])
    case 17:
      bitmapArray = Array(edt[1..<edt.count])
      for i: UInt8 in 0..<16 {
        for j:UInt8 in 0..<8 {
          if (bitmapArray[Int(i)] & (UInt8(0b00000001) << j)) != 0 {
            propertyArray += [0x80 + (0x10 * j) + i]
          }
        }
      }
    default:
      return []
    }
    propertyArray.sort()
    return propertyArray
  }
//    propertyStringArray = propertyArray.map{(a: UInt8) -> String in String(format:"%02X", a)}
//    propertyStringArray.sort()       // sort
//    return ("EPC: " + propertyStringArray.joined(separator: " "))

  
  /// Parse Property Map(EPC=0x9D,9E and 9F) and return a list of EPC in String
//  func propertyMap(edt: [UInt8]) -> String {
//    var propertyArray = [UInt8]()
//    var bitmapArray = [UInt8]()
//    var propertyStringArray = [String]()
//
//    switch edt.count {
//    case 0:
//      return "Error: EDT is 0 byte"
//    case 1...16:
//      propertyArray = Array(edt[1..<edt.count])
//    case 17:
//      bitmapArray = Array(edt[1..<edt.count])
//      for i: UInt8 in 0..<16 {
//        for j:UInt8 in 0..<8 {
//          if (bitmapArray[Int(i)] & (UInt8(0b00000001) << j)) != 0 {
//            propertyArray += [0x80 + (0x10 * j) + i]
//          }
//        }
//      }
//    default:
//      return "Error: EDT is more than 17 byte"
//    }
//    propertyStringArray = propertyArray.map{(a: UInt8) -> String in String(format:"%02X", a)}
//    propertyStringArray.sort()       // sort
//    return ("EPC: " + propertyStringArray.joined(separator: " "))
//  }
  
  func spot() {
    print("SPOT")
  }
  
  /// In order to find a device with given IP address, turn the ON/OFF status
  func findDevice(ipAddress: String) {    // 2016.06.10
    // Set findDevice property for processing GET_RES
    findDevice = (ipAddress, tid)
    print("Controller:findDevice: findDevice = \(findDevice)")
    
    // Send "GET EPC=0x80"
    var message = ElMessage(epc: UInt8(0x00), edt: [])
    message.epc = 0x80                  // ON/OFF status
    sendEl.tid = [0x00, tid]
    sendEl.seoj = [0x05, 0xFF, 0x01]    // controller
//    for node in nodeList {
//      if node.ip == ipAddress {
//        let deoj = node.devices[0]
//        let d0 : UInt8
//        let d1 : UInt8
//        (d0, d1) = uint16ToUInt8(a: deoj.elClass)
//        sendEl.deoj = [d0, d1, deoj.elInstance]    // node
//      }
//    }
    
    sendEl.esv  = 0x62                  // Get
    sendEl.messages = [message]
    if (!sendEl.send(address: ipAddress)) {
      print("Send failed")
    }
    tid = incrementTid(tid: tid)
    
    // GET_RESの処理は xxx
  }
  
  func findDeviceSendSet(ipAddress: String, getRes: UInt8) {
    // Send "SET EPC=0x80"
    let edtData = (getRes == UInt8(0x30)) ? UInt8(0x31) : UInt8(0x30)
    var message = ElMessage(epc: UInt8(0x00), edt: [edtData])
    message.epc = 0x80                  // ON/OFF status
    sendEl.tid = [0x00, tid]
    sendEl.seoj = [0x05, 0xFF, 0x01]    // controller
//    for node in nodeList {
//      if node.ip == ipAddress {
//        let deoj = node.devices[0]
//        let d0 : UInt8
//        let d1 : UInt8
//        (d0, d1) = uint16ToUInt8(a: deoj.elClass)
//        sendEl.deoj = [d0, d1, deoj.elInstance]    // node
//      }
//    }
    sendEl.esv  = 0x61                  // SetC
    sendEl.messages = [message]
    if (!sendEl.send(address: ipAddress)) {
      print("Send failed")
    }
    tid = incrementTid(tid: tid)
  }
}
