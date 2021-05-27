//
// ContentView.swift
// ssng2
//
// Created by Hiro Fujita on 2021/05/07.
//

import SwiftUI

struct ContentView: View {
//  let myIpList = getIFAddresses()
//  var ips = ["224.0.23.0", "192.168.0.1", "192.168.0.2"]
//  var eojs: [[UInt8]] = [[0x01,0x30,0x01],[0x01,0x30,0x02],[0x0E,0xF0,0x01]]
//  var esvs: [UInt8] = [0x61, 0x62, 0x73]
  var epcs: [UInt8] = [0x80, 0xA0, 0xB0]
  //  var edts = [[UInt8(0x30)]]
  //  var edts: [[UInt8]]  = [[0x30],[0x31]]
  var edts: [UInt8]  = [0x30,0x31]
//  @State private var ipSelection = 0
//  @State private var eojSelection = 0
//  @State private var selectedEsv = 1
//  @State private var selectedEpc = 0
//  @State private var selectedEdt = 0

  var outSocket = OutSocket()
  @ObservedObject var controller = Controller()
  let addressTo = "224.0.23.0"
  let byteArray: [UInt8] = [0x10,0x81,0x00,0x00,0x05,0xff,0x01,0x0e,0xf0,0x01,0x62,0x01,0x80,0x00]
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        HStack {
          Text(" ")
          Button(action: {
            print("Send EL")
            controller.send(
              address: controller.addressList[controller.selectedNode],
              deoj: controller.nodes[controller.selectedNode].eojs[controller.selectedEoj].hex,
//              esv: esvs[self.selectedEsv],
//              epc: epcs[self.selectedEpc],
//              edt: Array(repeating: edts[self.selectedEdt], count:1))
//              esv: esvs[controller.selectedEsv],
              esv: controller.esvList[controller.selectedEsv],
              epc: epcs[controller.selectedEpc],
              edt: Array(repeating: edts[controller.selectedEdt], count:1))
            //            self.outSocket.sendBinary(Data(self.byteArray), address: self.addressTo)
          }) {
            Text("SEND ").font(.title)
          }
          Button(action: {
            print("SEARCH")
            controller.search()
          }) {
            Text("SEARCH").font(.title)
          }
          Button(action: {
            print("Clear")
            controller.nodes = [EL.defaultNode]
            controller.selectedNode = 0
            controller.selectedEoj = 0
            controller.idPvNode = UUID()
            controller.idPvEoj = UUID()
            controller.address = ""
            controller.udpData = ""
            controller.udpSentData = ""
          }) {
            Text("CLEAR").font(.title)
          }
          Button(action: {
            print("SPOT")
            controller.spot()
          }) {
            Text("SPOT").font(.title)
          }
          Spacer()
          Text(controller.myIpList.joined(separator:", ")).font(.headline)
          Text(" ")
        }.padding()
        HStack {
          VStack(spacing: 5) {
            Text("IP").font(.headline)
            Picker(selection: $controller.selectedNode, label: Text("")){
              ForEach(0 ..< controller.addressList.count){ index in
//                Text(self.controller.addressList[index]).font(.title)
                Text(controller.addressList[index]).font(.title)
              }
            }
            .id(controller.idPvNode)
            .labelsHidden().frame(width: geometry.size.width * (2/8), height: 100).clipped()
            Text("S: \(controller.selectedNode),  \(controller.nodes[controller.selectedNode].makerCode)")
          }
          
          VStack(spacing: 5) {
            Text("EOJ").font(.headline)
            Picker(selection: $controller.selectedEoj, label: Text("")){
              ForEach(0 ..< controller.eojCodeList.count){ index in
                Text(controller.eojCodeList[index]).font(.title)
              }
            }
            .id(controller.idPvEoj)
            .labelsHidden().frame(width: geometry.size.width * (2/8), height: 100).clipped()
            Text("Selection: \(controller.selectedEoj)")
          }
          
          VStack(spacing: 5) {
            Text("ESV").font(.headline)
//            Picker(selection: $selectedEsv, label: Text("Label")) {
            Picker(selection: $controller.selectedEsv, label: Text("Label")) {
              ForEach(0 ..< controller.esvCodeList.count){ index in
                Text(controller.esvCodeList[index]).font(.title)
              }
//              ForEach(0 ..< esvs.count) {
//                Text(String(esvs[$0], radix: 16).uppercased()).font(.title)
//              }
            }
            .id(controller.idPvEsv)
            .labelsHidden().frame(width: geometry.size.width * (1/8), height: 100).clipped()
//            Text("Selection: \(selectedEsv)")
            Text("Selection: \(controller.selectedEsv)")
            
          }
          VStack(spacing: 5) {
            Text("EPC").font(.headline)
//            Picker(selection: self.$selectedEpc, label: Text("Label")) {
            Picker(selection: $controller.selectedEpc, label: Text("Label")) {
//              ForEach(0 ..< self.epcs.count) {
//                Text(String(self.epcs[$0], radix: 16).uppercased()).font(.title)
              ForEach(0 ..< self.epcs.count) {
                Text(String(self.epcs[$0], radix: 16).uppercased()).font(.title)
              }
            }
            .id(controller.idPvEpc)
            .labelsHidden().frame(width: geometry.size.width * (1/8), height: 100).clipped()
//            Text("Selection: \(self.selectedEpc)")
            Text("Selection: \(controller.selectedEpc)")
          }
          
          VStack(spacing: 5) {
            Text("EDT").font(.headline)
//            Picker(selection: self.$selectedEdt, label: Text("Label")) {
            Picker(selection: $controller.selectedEdt, label: Text("Label")) {
              ForEach(0 ..< self.edts.count) {
                Text(String(self.edts[$0], radix: 16).uppercased()).font(.title)
              }
            }
            .id(controller.idPvEdt)
            .labelsHidden().frame(width: geometry.size.width * (2/8), height: 100).clipped()
//            Text("Selection: \(self.selectedEdt)")
            Text("Selection: \(controller.selectedEdt)")
          }
        }
        HStack {
          List{
            Text("Tx: \(controller.udpSentData)")
            Text("Rx: \(controller.address)")
            Text("\(controller.udpData)")
          }.frame(width: geometry.size.width * (6/8))
          List{
            Text("EPC: \(controller.rxEpc)")
            Text("EDT: \(controller.rxEdt)")
          }.frame(width: geometry.size.width * (2/8))
        }
        
      }
      
    }
    
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
        ContentView()
          .previewLayout(.fixed(width: 812, height: 375))
          .environment(\.horizontalSizeClass, .compact)
          .environment(\.verticalSizeClass, .compact)
  }
}
