// ssng2:ContentView.swift
//
// Created by Hiro Fujita on 2021.06.02
// Copyright (c) 2021 Hiro Fujita. All rights reserved.

import SwiftUI

struct ContentView: View {
  var edts: [UInt8]  = [0x30, 0x31]
  var outSocket = OutSocket()
  @ObservedObject var controller = Controller()
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        HStack {
          Text(" ")
          Button(action: {
            print("Send EL")
            controller.send(
              address: controller.addressList[controller.selectedNode],
              deoj: controller.nodes[controller.selectedNode].deviceObjs[controller.selectedEoj].eoj,
              esv: UInt8(controller.esvCodeList[controller.selectedEsv], radix:16)!,
              epc: UInt8(controller.epcCodeList[controller.selectedEpc], radix:16)!,
              edt: Array(repeating: edts[controller.selectedEdt], count:1))
          }) {
            Text("SEND ").font(.title)
          }
          Button(action: {
            print("SEARCH")
            controller.send(address: controller.addressList[controller.selectedNode],epc: UInt8(0xD6))
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
            controller.rxEpc = ""
            controller.rxEdt = ""
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
        }.padding(.top).padding(.horizontal).padding(.bottom, 5.0)
        HStack {
          // PV-IP
          VStack(spacing: 5) {
            Text("IP").font(.headline)
            Picker(selection: $controller.selectedNode, label: Text("")){
              ForEach(0 ..< controller.addressList.count){ index in
                Text(controller.addressList[index]).font(.title)
              }
            }
            .id(controller.idPvNode)
            .labelsHidden().frame(width: geometry.size.width * (2/8), height: 100).clipped()
            Text("S: \(controller.selectedNode),  \(controller.nodes[controller.selectedNode].makerCode)")
          }
          
          // PV-EOJ
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
          
          // PV-ESV
          VStack(spacing: 5) {
            Text("ESV").font(.headline)
            Picker(selection: $controller.selectedEsv, label: Text("Label")) {
              ForEach(0 ..< controller.esvCodeList.count){ index in
                Text(controller.esvCodeList[index]).font(.title)
              }
            }
            .id(controller.idPvEsv)
            .labelsHidden().frame(width: geometry.size.width * (1/8), height: 100).clipped()
            Text("Selection: \(controller.selectedEsv)")
            
          }

          // PV-EPC
          VStack(spacing: 5) {
            Text("EPC").font(.headline)
            Picker(selection: $controller.selectedEpc, label: Text("Label")) {
              ForEach(0 ..< controller.epcCodeList.count){ index in
                Text(controller.epcCodeList[index]).font(.title)
              }
            }
            .id(controller.idPvEpc)
            .labelsHidden().frame(width: geometry.size.width * (1/8), height: 100).clipped()
            Text("Selection: \(controller.selectedEpc)")
          }

          // PV-EDT
          VStack(spacing: 5) {
            Text("EDT").font(.headline)
            Picker(selection: $controller.selectedEdt, label: Text("Label")) {
              ForEach(0 ..< self.edts.count) {
                Text(String(self.edts[$0], radix: 16).uppercased()).font(.title)
              }
            }
            .id(controller.idPvEdt)
            .labelsHidden().frame(width: geometry.size.width * (2/8), height: 100).clipped()
            Text("Selection: \(controller.selectedEdt)")
          }
        }
        List{
          Text("Tx: \(controller.udpSentData)")
          Text("Rx: \(controller.address): \(controller.udpData)")
          Text("EPC: \(controller.rxEpc), EDT: \(controller.rxEdt)")
        }.environment(\.defaultMinListRowHeight, 0)
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
