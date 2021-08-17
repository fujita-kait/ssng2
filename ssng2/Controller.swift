// ssng2:Controller.swift
//
// Created by Hiro Fujita on 2021.08.17
// Copyright (c) 2021 Hiro Fujita. All rights reserved.

import Foundation

class Controller: ObservableObject {
  let myIpList = getIFAddresses()
  @Published var nodes: [Node] = [ EL.defaultNode ]
  
  // selectedNode,selectedEoj,selectedEsv,selectedEpc,selectedEdt: index of selected item on each PV
  @Published var selectedNode: Int = 0 {
    didSet {
      selectedEoj = 0
      selectedEsv = 1 // 0x62
      selectedEpc = 0
      selectedEdt = 0
      idPvEoj = UUID()  // Update PickerView(EOJ)
      print("PV-IP changed, selectedNode: \(selectedNode)")
    }
  }
  
  @Published var selectedEoj: Int = 0 {
    didSet {
      selectedEsv = 1 // 0x62
      selectedEpc = 0
      selectedEdt = 0
      idPvEsv = UUID()  // Update PickerView(ESV)
      print("PV-EOJ changed, selectedEoj: \(selectedEoj)")
    }
  }
  
  var selectedEpcCode = "80"
  @Published var selectedEsv: Int = 1 {
    didSet {
      // ある EPC が Set/Get の場合、ESV を変更しても選択中のEPCは変更しない
      // Set と Get でEPCのリスト(epcCodeList)の中身が変わるので、中身を見て selectedEpc の値を設定する必要がある
      // epcCodeList の中身に selectedEpcCode が存在する場合はその index を selectedEpc に設定する。
      // 存在しない場合は selectedEpc = 0
      selectedEpc = epcCodeList.firstIndex(of: selectedEpcCode) ?? 0
      selectedEpcCode = epcCodeList[selectedEpc]
      selectedEdt = 0
      idPvEpc = UUID()  // Update PickerView(EPC)
      print("PV-ESV changed, selectedEsv: \(selectedEsv)")
    }
  }
  
  @Published var selectedEpc: Int = 0 {
    didSet {
      selectedEpcCode = epcCodeList[selectedEpc]
      selectedEdt = 0
      idPvEdt = UUID()  // Update PickerView(EDT)
      print("PV-EPC changed, selectedEpc: \(selectedEpc)")
    }
  }
  
  @Published var selectedEdt: Int = 0 {
    didSet {
      print("PV-EDT changed, selectedEdt: \(selectedEdt)")
    }
  }
  
  // idx is updated to redraw PickerView
  @Published var idPvNode = UUID() // id for PickerView(Node)
  @Published var idPvEoj = UUID() // id for PickerView(EOJ)
  @Published var idPvEsv = UUID() // id for PickerView(ESV)
  @Published var idPvEpc = UUID() // id for PickerView(EPC)
  @Published var idPvEdt = UUID() // id for PickerView(EDT)
  
  // for PickerView
  var addressList: [String] {
    nodes.map{(node) in node.address }
  }
  
  var eojCodeList: [String] {
    nodes[selectedNode].deviceObjs.map{(a) in a.eoj.code }
  }
  
  var esvCodeList: [String] {
    [String](EL.esv.keys).sorted()
  }
  
  var epcCodeList: [String] {
    print("epcCodeList: selectedNode \(selectedNode) selectedEoj \(selectedEoj)")
    var epcList: [UInt8]
    if esvCodeList[selectedEsv] == "61" { // Set
      epcList = nodes[selectedNode].deviceObjs[selectedEoj].propertyListSet
    } else { // Get or Inf
      epcList = nodes[selectedNode].deviceObjs[selectedEoj].propertyListGet
    }
    return epcList.map{(a: UInt8) -> String in String(format:"%02X", a)}
  }
  
  var elProp: ElProp {
    var tmp = EL.deviceDescriptions[selectedEojCode2bytes]?.props[selectedEpcCode]
    if tmp == nil {
      tmp = EL.superClass[selectedEpcCode]
    }
    return tmp ?? ElProp()
  }
  
  var edtDataType: Type {
    elProp.type
  }
  
  var edtCodeList: [String] {
    if edtDataType == .state {
      return elProp.state?.keys.map{$0}.sorted() ?? []
    } else {
      return []
    }
  }
  
  var edtNumberMultiple: String {
    if elProp.multiple != 1.0 {
      return "X \(elProp.multiple)"
    } else {
      return ""
    }
  }
  
  // for footer of Picker View
  var footerPvIp: String {
    let makerCode = nodes[selectedNode].makerCode
    return EL.makerCode[makerCode] ?? "unknown"
  }
  var footerPvEoj: String {
    let eojCode = eojCodeList[selectedEoj]
    let to = eojCode.index(eojCode.startIndex, offsetBy:4)
    let eojCode2bytes = String(eojCode[..<to])
    return EL.deviceDescriptions[eojCode2bytes]?.name ?? "unknown"
  }
  var footerPvEsv: String {
    EL.esv[esvCodeList[selectedEsv]] ?? "unknown"
  }
  var selectedEojCode2bytes: String {
    let eojCode = eojCodeList[selectedEoj]
    let to = eojCode.index(eojCode.startIndex, offsetBy:4)
    return String(eojCode[..<to])
  }
  var footerPvEpc: String {
    return propertyName(classCode: selectedEojCode2bytes, epcCode: selectedEpcCode)
  }
  var selectedEdtCode: String {
    edtCodeList[selectedEdt]
  }
  var footerPvEdt: String {
    var elProp = EL.deviceDescriptions[selectedEojCode2bytes]?.props[selectedEpcCode]
    if elProp == nil {
      elProp = EL.superClass[selectedEpcCode]
    }
    return elProp?.state?[selectedEdtCode] ?? ""
  }
  var edtValueFromTextField = ""
  
  @Published var txContents = String()  // View Tx: sent UDP data in HEX string
  @Published var rxContents = String()  // View Rx: received UDP data in HEX string
  @Published var rxInfContents = String()  // View Rx-INF: received INF data in HEX string
  @Published var rxSubContents = String()  // View Rx: EPC and EDT
  
  var address = String()     // View Rx: source IP Address: example: "192.168.1.2"
  var udpData = String()     // View Rx data: received UDP data in HEX string
  var receiveEl: ReceiveEl!  // for receiving data
  var sendEl: SendEl!        // for sending data
  
  private var tid = Tid(d1: UInt8(0x00), d2: UInt8(0x00))
  private var spotDeviceInfo = (address:"", eoj:Eoj(d1: UInt8(), d2: UInt8(), d3: UInt8()))
  
  init() {
    receiveEl = ReceiveEl()
    sendEl = SendEl()
    // Receive Notification "receiveElData" from inSocket, then call a function receiveElData
    NotificationCenter.default.addObserver(self, selector: #selector(receive(_:)), name: Notification.Name("ReceiveElData"), object: nil)
    // Boot process: INF D5
    send(seoj: Eoj(d1: UInt8(0x0E), d2: UInt8(0xF0), d3: UInt8(0x01)), esv: UInt8(0x73),
         epc: UInt8(0xD5), edt: [0x01, 0x05, 0xFF, 0x01])
  }
  
  /// Notification "receiveElData" を受信すると呼ばれるメソッド
  @objc func receive(_ notification: Notification) {
    address  = receiveEl.address
    udpData  = receiveEl.udpData
    //    rxContents = ""
    
    if myIpList.contains(address) {
      print("\(address) is loopback, ignore")
      return
    }
    
    //    rxContents = address + ": " + udpData
    //    rxSubContents = ""
    let esv  = receiveEl.esv
    let seoj = receiveEl.seoj
    let deoj = receiveEl.deoj
    let epc  = receiveEl.messages[0].epc
    let edt  = receiveEl.messages[0].edt
    
    if !((deoj.code == "0EF001") || (deoj.code == "05FF01")) {
      print("received: DEOJ \(deoj.code)")
      return
    }
    
    switch esv {
    case 0x60, 0x61:  // SetI or SetC: ignore
      print("case ESV 0x60")
    case 0x62:  // Get: respond to 80, 8A and D6
      switch epc {
      case 0x80:
        send(deoj: seoj, esv: UInt8(0x72), epc: epc, edt: [0x30])
      case 0x8A:  // maker code
        send(deoj: seoj, esv: UInt8(0x72), epc: epc, edt: [0x00, 0x00, 0x77])
      case 0xD6:  // instance list
        if receiveEl.deoj.hex == [0x0E, 0xF0, 0x01] {  // node only
          send(seoj: deoj, deoj: seoj, esv: UInt8(0x72), epc: UInt8(0xD6), edt: [0x01, 0x05, 0xFF, 0x01])
        }
      default:
        send(seoj: deoj, deoj: seoj, esv: UInt8(0x52), epc: epc, edt: edt)
      }
    case 0x63:  // INF_Req: ignore
      print("case ESV 0x63")
    case 0x72, 0x73:  // Get_Res(0x72) or INF(0x73)
      print("case ESV 0x72 0x73")
      let epcCode = String(format:"%02X", receiveEl.messages[0].epc)
      let rxEpc = epcCode + " " + propertyName(classCode: seoj.classCode, epcCode: epcCode)
      let edtCode = receiveEl.messages[0].edt.map{(a: UInt8) -> String in String(format:"%02X", a)}.joined()
      let rxEdt = edtCode + decodeEdt(classCode: seoj.classCode, epcCode: epcCode, edtCode: edtCode)

      if (esv == 0x72) {
        rxContents = address + ": " + udpData
        rxSubContents = "EPC:\(rxEpc) EDT:\(rxEdt)"
      } else {
        rxInfContents = "Rx-INF: " + address + ": " + udpData
      }
      
      switch epc {
      // Instance ListS: append a node to nodes
      case 0xD5, 0xD6:
        print("case EPC:D5, D6")
        if addressList.contains(address) {
          print("\(address) is already in the IP list, ignore")
          return
        }
        let instanceList = receiveEl.messages[0].edt
        var node = Node(address: address, makerCode: "", deviceObjs: [])
        for i in 0...(Int(instanceList[0])-1) {
          node.deviceObjs.append(DeviceObj(eoj: Eoj(d1: instanceList[3*i+1], d2: instanceList[3*i+2], d3: instanceList[3*i+3])))
        }
        
        nodes.append(node)
        idPvNode = UUID()  // update PV IP
        idPvEoj = UUID()   // update PV DEOJ
        
        send(address: address, epc: 0x8A)  // Get maker code
        for a in node.deviceObjs {          // Get property map
          send(address: address, deoj:a.eoj, epc: 0x9D)
          send(address: address, deoj:a.eoj, epc: 0x9E)
          send(address: address, deoj:a.eoj, epc: 0x9F)
        }
        
      // Maker Code: append Maker Code to a node
      case 0x8A:
        print("case EPC:8A")
        let makerCode = receiveEl.messages[0].edt
        if makerCode.count == 3 {
          for (index, node) in nodes.enumerated() {
            if node.address == address {
              nodes[index].makerCode = makerCode.map{(a: UInt8) -> String in String(format:"%02X", a)}.joined()
              print("node.makerCode: \(node.makerCode)")
            }
          }
        }
        
      // Property Map: Decode EDT data and append it to a node
      case 0x9D, 0x9E, 0x9F: // inf, set, get property map
        print("case EPC:9D, 9E, 9F")
        for (index, node) in nodes.enumerated() {
          if node.address == address {
            for (idx, a) in nodes[index].deviceObjs.enumerated() {
              if a.eoj.hex == seoj.hex {
                if epc == 0x9D {
                  nodes[index].deviceObjs[idx].propertyListInf = decodePropertyMap(edt: receiveEl.messages[0].edt)
                } else if epc == 0x9E {
                  nodes[index].deviceObjs[idx].propertyListSet = decodePropertyMap(edt: receiveEl.messages[0].edt)
                } else { // epc == 0x9F
                  nodes[index].deviceObjs[idx].propertyListGet = decodePropertyMap(edt: receiveEl.messages[0].edt)
                }
              }
            }
          }
        }
        
      case UInt8(0x80):   // for method "spot"
        if ((address == spotDeviceInfo.address) && (seoj.code == spotDeviceInfo.eoj.code)) {
          let edt = receiveEl.messages[0].edt[0]
          let data = (edt == UInt8(0x30)) ? UInt8(0x31) : UInt8(0x30)
          send(address: address, deoj:seoj, esv:UInt8(0x61), epc:UInt8(0x80), edt:[data])
          spotDeviceInfo.address = ""
          spotDeviceInfo.eoj = Eoj(d1: UInt8(), d2: UInt8(), d3: UInt8())
        }
      default:
        print("case default")
      }
    case 0x74:  // INFC
      print("case ESV 0x74")
    case 0x6E:  // SetGet -> send SetGet_SNA
      send(seoj: deoj, deoj: seoj, esv: UInt8(0x5E), epc: epc, edt: edt)
      print("Obj:ESV=0x5E:SetGet_SNA, send SNA: \(sendEl.esv)")
    case 0x71:  // Set_Res
      print("Obj:ESV=0x71:SetRes")
      rxContents = address + ": " + udpData
    case 0x52:  // Get_SNA
      print("Obj:ESV=0x52:Get_SNA")
      rxContents = address + ": " + udpData
    default:
      print("Obj:ESV error \(esv)")
    }
  }
  
  // get property name from class code and epc code
  // "0130" "B0" -> "運転モード"
  func propertyName(classCode: String, epcCode: String) -> String {
    //    print("propertyName: \(classCode) \(epcCode)")
    if (classCode == "" || epcCode == "") { return " " }
    var propertyName = ""
    
    // node profile
    if classCode == "0EF0" {
      propertyName = EL.nodeProfile[epcCode]?.name ?? "unknown"
      return propertyName
    }
    
    // device object
    propertyName = EL.deviceDescriptions[classCode]?.props[epcCode]?.name ?? "unknown"
    if propertyName == "unknown" {
      propertyName = EL.superClass[epcCode]?.name ?? "unknown"
    }
    return propertyName
  }
  
  // "0130" "B0" "42" -> "冷房"
  func decodeEdt(classCode: String, epcCode: String, edtCode: String) -> String {
    var elProp:ElProp?
    if classCode == "0EF0" {
      elProp = EL.nodeProfile[epcCode]
      if elProp == nil {
        return ""
      }
    } else if EL.deviceDescriptions[classCode] != nil {
      elProp = EL.deviceDescriptions[classCode]?.props[epcCode]
      if elProp == nil {
        elProp = EL.superClass[epcCode]
      }
      if elProp == nil {
        return ""
      }
    }
    
    if elProp?.type == .state {
      return " \(elProp?.state?[edtCode] ?? "")"
    } else if elProp?.type == .number {
      // edtCode を 数値に変換して 10進数のString にする
      return " \(Int(edtCode, radix: 16) ?? 0)"
    } else {
      return ""
    }
  }
  
  /// Send ECHONET Lite message (OPC: 1)
  /// default value of argument: IP:224.0.23.0, SEOJ:05FF01, DEOJ:0EF001, ESV:62, EPC:80, EDT:none
  func send(address: String  = EL.mcAddress,
            seoj: Eoj = Eoj(d1: 0x05, d2: 0xFF, d3: 0x01),
            deoj: Eoj = Eoj(d1: 0x0E, d2: 0xF0, d3: 0x01),
            esv: UInt8 = UInt8(0x62),
            epc: UInt8 = UInt8(0x80),
            edt: [UInt8] = []) {
    sendEl.tid = tid
    sendEl.seoj = seoj    // controller
    sendEl.deoj = deoj
    sendEl.esv  = esv
    sendEl.messages = [ElMessage(epc: epc, edt: edt)]
    if esv == UInt8(0x62) {
      sendEl.messages[0].edt = []
    }
    if (!sendEl.send(address: address)) {
      print("Send failed")
    }
    // Update txContents only when SEND Button is pressed
    //    txContents = sendEl.udpData
    tid.increment()
  }
  
  func sendFromUi() {
    // edtの処理
    var edt: [UInt8]
    if esvCodeList[selectedEsv] == "61" {
      if edtDataType == .state {
        edt = Array(repeating: UInt8(edtCodeList[selectedEdt], radix:16)!, count:1)
      } else if edtDataType == .number { // No need for validation, because keypad is number
        edt = uintToUInt8(a:UInt(edtValueFromTextField), n:elProp.size)
      } else {  // edtDataType == .raw
        edt = stringToUInt8(a:edtValueFromTextField, n:elProp.size)
      }
    } else {
      edt = []
    }
    send(
      address: addressList[selectedNode],
      deoj: nodes[selectedNode].deviceObjs[selectedEoj].eoj,
      esv: UInt8(esvCodeList[selectedEsv], radix:16)!,
      epc: UInt8(epcCodeList[selectedEpc], radix:16)!,
      edt: edt)
    // Update UI of "TX:"
    txContents = sendEl.udpData
    rxContents = ""
    rxInfContents = ""
    rxSubContents = ""
  }
  
  func validateInputData(a:String, n:Int) -> Bool {
    print("validateInputData \(a) \(n)")
    let count = a.lengthOfBytes(using: String.Encoding.ascii)
    // count should be even
    if count % 2 == 1 {
      print("count should be even \(count) n=\(n)")
      return false
    }
    // "n == 0" means unknown property
    if !((n == 0) || (count <= 2*n)) {
      print("wrong size \(count) n=\(n)")
      return false
    }
    // Character check
    let pattern = "^[0-9a-fA-F]+$"
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    let matches = regex.matches(in: a, options: [], range: NSMakeRange(0, a.count))
    print("matches \(matches.count)")
    if matches.count > 0 {
      return true
    } else {
      print("wrong character")
      return false
    }
  }
  
  /// Convert String data to n x UInt8 data
  /// "1234AB" -> [0x12, 0x34, 0xAB]
  // 入力データのvalidationを行い、error の場合は return [UInt8(0x00)]
  // それから２文字単位でUInt8に変換する
  // n =0 0 の場合はすべてのデータを [UInt8] に変換
  // n !=0 の場合、データが n byte 未満の場合は 0x00 で先頭からpadding
  func stringToUInt8(a:String, n:Int) -> [UInt8] {
    var returnValue: [UInt8] = []
    print("stringToUInt8 \(a) \(n)")
    if !validateInputData(a:a, n:n) {
      print("stringToUInt8 input data is wrong, return [0x00]")
      return [UInt8(0x00)]
    }
    let countOfData = a.lengthOfBytes(using: String.Encoding.ascii)
    let countOfPadding = 2*n - countOfData
    if (n != 0) && (countOfPadding > 0) {
      for _ in 1...countOfPadding {
        returnValue.append(UInt8(0x00))
      }
    }
    // ２文字ずつ切り出して UInt8(string, radix:16)で変換し、arrayにpush
    for index in 0...(countOfData/2 - 1) {
      let from = a.index(a.startIndex, offsetBy:index*2)
      let to =   a.index(a.startIndex, offsetBy:(index*2 + 2))
      returnValue.append(UInt8(String(a[from..<to]), radix:16) ?? UInt8(0x00))
    }
    
    return returnValue
  }
  
  
  /// Convert UInt data to n x UInt8 data
  /// - parameter a: Int data, n: byte size
  /// - returns: ex 0x123456->(0x12,0x34,0x56) 0x12345678->(0x12,0x34,0x56,0x78)
  func uintToUInt8(a:UInt?, n:Int) -> [UInt8] { // n = 1...4
    var returnValue = [UInt8]()
    if (0 < n) && (n <= 4) {
      // UInt -> NSData
      if var src = a {
        let data = NSData(bytes: &src, length: MemoryLayout<UInt>.size)
        // NSData -> [UInt8]    Caution: byte order
        var buffer = [UInt8](repeating: 0x00, count: data.length) // init Array [(UInt8)]
        data.getBytes(&buffer, length: data.length)           // NSData -> buffer: [(UInt8)]
        for i in 0..<n {
          returnValue.insert(buffer[i], at: 0)
        }
      }
    }
    return returnValue
  }
  
  func search() {
    send(address: addressList[selectedNode],epc: UInt8(0xD6))
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
  
  /// A function called when "SPOT" button is clicked
  func spot() {
    spotDeviceInfo.address = addressList[selectedNode]
    spotDeviceInfo.eoj = nodes[selectedNode].deviceObjs[selectedEoj].eoj
    send(address: addressList[selectedNode], deoj: spotDeviceInfo.eoj)
    print("SPOT")
  } 
  
}
