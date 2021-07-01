//  SSNG:Global.swift
//
//  Global structures and functions
//
//  Created by Hiro Fujita on 2016.02.03, updated on 2016.03.31
//  Copyright (c) 2016 Hiro Fujita. All rights reserved.

import Foundation

// for EHD
struct Ehd {
  var d1: UInt8
  var d2: UInt8
  var hex: [UInt8] {  // [0x10, 0x81]
    return [d1, d2]
  }
  var code: String {  // "1081"
    let a1 = String(format: "%02x", d1).uppercased()
    let a2 = String(format: "%02x", d2).uppercased()
    return a1 + a2
  }
}

// for TID (ex. 0001)
struct Tid {
  var d1: UInt8       // 0x00
  var d2: UInt8       // 0x01
  var hex: [UInt8] {  // [0x00, 0x01]
    return [d1, d2]
  }
  var code: String {  // "0001"
    let a1 = String(format: "%02x", d1).uppercased()
    let a2 = String(format: "%02x", d2).uppercased()
    return a1 + a2
  }
  mutating func increment() {
    var data = UInt16(d1) * 256 + UInt16(d2)
    if data == 0xFFFF {
      data = 0
    } else {
      data += 1
    }
    d1 = UInt8(data / 0x0100)
    d2 = UInt8(data % 0x0100)
  }
}

// for SEOJ and DEOJ
struct Eoj {
  var d1: UInt8       // 0x02
  var d2: UInt8       // 0x7A
  var d3: UInt8       // 0x01
  var hex: [UInt8] {  // [0x02, 0x7A, 0x01]
    return [d1, d2, d3]
  }
  var code: String {  // "027A01"
    let a1 = String(format: "%02x", d1).uppercased()
    let a2 = String(format: "%02x", d2).uppercased()
    let a3 = String(format: "%02x", d3).uppercased()
    return a1 + a2 + a3
  }
  var classCode: String {  // "027A"
    let a1 = String(format: "%02x", d1).uppercased()
    let a2 = String(format: "%02x", d2).uppercased()
    return a1 + a2
  }
}

struct DeviceObj {
  var eoj = Eoj(d1: UInt8(), d2: UInt8(), d3: UInt8())
  var propertyListGet: [UInt8] = [0x80]
  var propertyListSet: [UInt8] = [0x80]
  var propertyListInf: [UInt8] = [0x80]
}

struct Node {
  var address: String // "192.169.0.1"
  var makerCode: String // "000077"
  var deviceObjs: [DeviceObj]
}

struct ElMessage {
  var epc = UInt8(0x00)
  var edt: [UInt8] = []
}

// for Device Description
struct ElDevObj {
  var name: String = ""
  var props: [String:ElProp] = [:]
}

struct ElProp {
  var name: String = ""  // Property Name
  var size: Int = 0      // Data Size (0 is unknown size)
  var type: Type = .raw  // Data type
  var multiple: Float = 1.0
  var state: [String:String]? = nil
}

enum Type {
    case number
    case state
    case raw
}

/// EOJ: var elClass:UInt16; var elInstance:UInt8
//struct Device {
//  var elClass = UInt16(0x0000)
//  var elInstance = UInt8(0x00)
//}
//
//struct NodeInfo: Identifiable {
//  var ip: String
//  var makerCode : UInt?       // Example 0x000077 for KAIT
//  var devices: [Device] = []
//  var id: String { ip }
//
//  init(ip: String) {
//    self.ip = ip
//  }
//}


/// ECHONET Lite Device Object
//struct ElObj {
//  var name: String = ""            // Object Name: Example: "エアコン" for EOJ = 0x0130
//  var properties: [UInt8:ElProperty] = [:]    // EPC : EL property (excluding Superclass properties)
//}

//struct ElProperty {                 // For EPC=0x80
//  var name: String       = ""     // Property Name
//  var size: Int          = 0      // Data Size
//  var set: Bool          = true   // Access Rule: Set
//  var required: Bool     = true   // Required Item
//  var anno: Bool         = true   // Access Rule: Announce
//  var edt: [UInt:String]? = nil
//}


/// Struct for ECHONET-property data including AccessMode and Data
//struct Property {
//  var accessMode = [String]()    // "S" for Set and "I" for voluntary INF
//  var data = [UInt8]()           // EDT data
//}

/// Convert UInt8(x2) -> Int16 data
/// - parameter data0: 上位バイト
/// - parameter data1: 下位バイト
/// - returns: 例　0x12,0x34->0x1234　0xED,0xCC->(-0x1234)
func uint8ToInt16(data0: UInt8, data1: UInt8) -> Int16 {
  var uint8Array:[UInt8] = [data1, data0];
  let dataNSData = NSData(bytes: &uint8Array, length: uint8Array.count)
  var dataInt16 = Int16(0)
  dataNSData.getBytes(&dataInt16, length: MemoryLayout<Int16>.size)
  return dataInt16
}

/// Convert UInt8(x2) -> UInt16 data
/// - parameter data0: 上位バイト
/// - parameter data1: 下位バイト
/// - returns: 例　0x12,0x34->0x1234　0xED,0xCC->0xEDCC
//func uint8ToUint16(data0: UInt8, data1: UInt8) -> UInt16 {
//  var uint8Array:[UInt8] = [data1, data0];
//  let dataNSData = NSData(bytes: &uint8Array, length: uint8Array.count)
//  var dataUInt16 = UInt16(0)
//  dataNSData.getBytes(&dataUInt16, length: MemoryLayout<Int16>.size)
//  return dataUInt16
//}

/// Convert UInt8(x4) -> UInt
//func uint8ToUInt(data0: UInt8, data1: UInt8, data2: UInt8, data3: UInt8) -> UInt {
//  var uint8Array:[UInt8] = [data3, data2, data1, data0];
//  let dataNSData = NSData(bytes: &uint8Array, length: uint8Array.count)
//  var dataUInt = UInt(0)
//  dataNSData.getBytes(&dataUInt, length: MemoryLayout<Int>.size)
//  return dataUInt
//}

/// Convert UInt16 data to Two UInt8 data
/// - parameter a: Int16 data
/// - returns: 例　0x1234->(0x12,0x34)
//func uint16ToUInt8(a:UInt16) -> (data0:UInt8, data1:UInt8) {
//  // UInt16 -> NSData
//  var src = a
//  let data = NSData(bytes: &src, length: MemoryLayout<UInt16>.size)
//  // NSData -> [UInt8]    Caution: byte order
//  var buffer = [UInt8](repeating: 0x00, count: data.length)    // init Array [(UInt8)]
//  data.getBytes(&buffer, length: data.length)           // NSData -> buffer: [(UInt8)]
//  return (buffer[1], buffer[0])
//}

/// Convert UInt data to n x UInt8 data
/// - parameter a: Int16 data
/// - returns: 例　0x123456->(0x12,0x34,0x56) 0x12345678->(0x12,0x34,0x56,0x78)
//func uintToUInt8(a:UInt?, n:Int) -> [UInt8] { // n = 1...4
//  var returnValue = [UInt8]()
//  if (0 < n) && (n <= 4) {
//    // UInt -> NSData
//    if var src = a {
//      let data = NSData(bytes: &src, length: MemoryLayout<UInt>.size)
//      // NSData -> [UInt8]    Caution: byte order
//      var buffer = [UInt8](repeating: 0x00, count: data.length) // init Array [(UInt8)]
//      data.getBytes(&buffer, length: data.length)           // NSData -> buffer: [(UInt8)]
//      for i in 0..<n {
//        returnValue.insert(buffer[i], at: 0)
//      }
//    }
//  }
//  return returnValue
//}

/// Convert Int16 data to Two UInt8 data
/// - parameter a: Int16 data
/// - returns: 例　0x1234->(0x12,0x34)　(-0x1234)->(0xED,0xCC)
//func int16ToUInt8(a:Int16) -> (data0:UInt8, data1:UInt8) {
//  // Int16 -> NSData
//  var src = a
//  let data = NSData(bytes: &src, length: MemoryLayout<Int16>.size)
//  // NSData -> [UInt8]    Caution: byte order
//  var buffer = [UInt8](repeating: 0x00, count: data.length)    // init Array [(UInt8)]
//  data.getBytes(&buffer, length: data.length)           // NSData -> buffer: [(UInt8)]
//  return (buffer[1], buffer[0])
//}
