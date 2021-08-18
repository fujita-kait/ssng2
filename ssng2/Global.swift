//  SSNG:Global.swift
//
//  Global struct and enum
//
// Created by Hiro Fujita on 2021.07.21
// Copyright (c) 2021 Hiro Fujita. All rights reserved.

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
