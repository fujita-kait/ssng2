//  ssng2:getIFAddresses.swift
//
// Created by Hiro Fujita on 2021.08.17
// Copyright (c) 2021 Hiro Fujita. All rights reserved.

import Foundation

func getIFAddresses() -> [String] {
  var addresses = [String]()
  // Get list of all interfaces on the local machine:
  var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
  if getifaddrs(&ifaddr) == 0 {
    // For each interface ...
    var ptr = ifaddr
    while( ptr != nil) {
      let flags = Int32((ptr?.pointee.ifa_flags)!)
      var addr = ptr?.pointee.ifa_addr.pointee
      
      // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
      if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
        if addr?.sa_family == UInt8(AF_INET) {  // IPv4 only
          //              if addr?.sa_family == UInt8(AF_INET) || addr?.sa_family == UInt8(AF_INET6) { // IPv4 or IPv6
          // Convert interface address to a human readable string:
          var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
          if (getnameinfo(&addr!, socklen_t((addr?.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST) == 0) {
            if let address = String(validatingUTF8: hostname) {
              // ignore link local address (169.254.xxx.xxx, 10.254.xxx.xxx)
              if (!address.hasPrefix("169.254") && !address.hasPrefix("10.254")) {
                addresses.append(address)
              }
            }
          }
        }
      }
      ptr = ptr?.pointee.ifa_next
    }
    freeifaddrs(ifaddr)
  }
  return addresses
}
