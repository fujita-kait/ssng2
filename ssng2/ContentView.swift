// ssng2:ContentView.swift
//
// Created by Hiro Fujita on 2021.06.02
// Copyright (c) 2021 Hiro Fujita. All rights reserved.

import SwiftUI

struct ContentView: View {
  var edts: [UInt8]  = [0x30, 0x31]
  var outSocket = OutSocket()
  @ObservedObject var controller = Controller()
  @State private var edtInputValue = ""
  @State private var edtValue = ""
  @State private var flagEditting = false
  
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
            Text("SEND ").font(.title2)
          }
          Button(action: {
            print("SEARCH")
            controller.send(address: controller.addressList[controller.selectedNode],epc: UInt8(0xD6))
          }) {
            Text("SEARCH").font(.title2)
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
            controller.txContents = ""
            controller.rxContents = ""
            controller.rxSubContents = ""

//            controller.udpSentData = ""
//            controller.rxEpc = ""
//            controller.rxEdt = ""
          }) {
            Text("CLEAR").font(.title2)
          }
          Button(action: {
            print("SPOT")
            controller.spot()
          }) {
            Text("SPOT").font(.title2)
          }
          Spacer()
          Text(controller.myIpList.joined(separator:", ")).font(.headline)
          Text(" ")
        }.padding(.top).padding(.horizontal).padding(.bottom, 5.0)
        
        HStack(spacing: 0.0) {
          // PV-IP
          VStack(spacing: 0.0) {
            Text("IP").font(.headline)
            Picker(selection: $controller.selectedNode, label: Text("")){
              ForEach(0 ..< controller.addressList.count){ index in
                Text(controller.addressList[index]).font(.title2)
              }
            }
            .id(controller.idPvNode)
            .labelsHidden().frame(width: geometry.size.width * (2/8), height: 100).clipped()
            let makerCode = controller.nodes[controller.selectedNode].makerCode
            Text("\(EL.makerCode[makerCode] ?? "unknown")").font(.callout)
          }
          
          // PV-EOJ
          VStack(spacing: 0.0) {
            Text("EOJ").font(.headline)
            Picker(selection: $controller.selectedEoj, label: Text("")){
              ForEach(0 ..< controller.eojCodeList.count){ index in
                Text(controller.eojCodeList[index]).font(.title2)
              }
            }
            .id(controller.idPvEoj)
            .labelsHidden().frame(width: geometry.size.width * (2/8), height: 100).clipped()
            let eojCode = controller.eojCodeList[controller.selectedEoj]
            let to = eojCode.index(eojCode.startIndex, offsetBy:4)
            let eojCode2bytes = String(eojCode[..<to])
            Text(" \(EL.deviceDescriptions[eojCode2bytes]?.name ?? "unknown")").font(.callout)
          }
          
          // PV-ESV
          VStack(spacing: 0.0) {
            Text("ESV").font(.headline)
            Picker(selection: $controller.selectedEsv, label: Text("Label")) {
              ForEach(0 ..< controller.esvCodeList.count){ index in
                Text(controller.esvCodeList[index]).font(.title2)
              }
            }
            .id(controller.idPvEsv)
            .labelsHidden().frame(width: geometry.size.width * (1/8), height: 100).clipped()
            Text(" \(EL.esv[controller.esvCodeList[controller.selectedEsv]]!)").font(.callout)
          }
          
          // PV-EPC
          VStack(spacing: 0.0) {
            Text("EPC").font(.headline)
            Picker(selection: $controller.selectedEpc, label: Text("Label")) {
              ForEach(0 ..< controller.epcCodeList.count){ index in
                Text(controller.epcCodeList[index]).font(.title2)
              }
            }
            .id(controller.idPvEpc)
            .labelsHidden().frame(width: geometry.size.width * (1/8), height: 100).clipped()
            let eojCode = controller.eojCodeList[controller.selectedEoj]
            let to = eojCode.index(eojCode.startIndex, offsetBy:4)
            let eojCode2bytes = String(eojCode[..<to])
            let epc = UInt8(controller.epcCodeList[controller.selectedEpc], radix:16)!
            Text("\(controller.propertyName(classCode: eojCode2bytes, epc: epc))").font(.callout)
//            Text("Sel: \(controller.selectedEpc)").font(.callout)
          }

          // View-EDT
          VStack(spacing: 0.0) {
            Text("EDT").font(.headline)
            TextField("Input Data", text: $edtInputValue,
              onEditingChanged: { begin in
                  if begin {
                      self.flagEditting = true
                      self.edtValue = ""
                  } else {
                      self.flagEditting = false
                  }
              },
              /// リターンキーが押された時の処理
              onCommit: {
                  self.edtValue = "\(self.edtInputValue)"
                  self.edtInputValue = ""
              })
              .textFieldStyle(RoundedBorderTextFieldStyle()) // 入力域を枠で囲む
              .padding()
              // 編集フラグがONの時に枠に影を付ける
              .shadow(color: flagEditting ? .blue : .clear, radius: 3)
            .id(controller.idPvEdt)
            .labelsHidden().frame(width: geometry.size.width * (2/8), height: 100).clipped()
            Text("\(edtValue): ON").font(.callout)
          }
        }
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        
          
//          VStack(spacing: 5) {
//            Text("EDT").font(.headline)
//            Picker(selection: $controller.selectedEdt, label: Text("Label")) {
//              ForEach(0 ..< self.edts.count) {
//                Text(String(self.edts[$0], radix: 16).uppercased()).font(.title)
//              }
//            }
//            .id(controller.idPvEdt)
//            .labelsHidden().frame(width: geometry.size.width * (2/8), height: 100).clipped()
//            Text("Selection: \(controller.selectedEdt)")
//          }

//          Group{
//            if controller.selectedEsv == 1 {
//              VStack(spacing: 5) {
//                Text("EDT").font(.headline)
//                Picker(selection: $controller.selectedEdt, label: Text("Label")) {
//                  ForEach(0 ..< self.edts.count) {
//                    Text(String(self.edts[$0], radix: 16).uppercased()).font(.title)
//                  }
//                }
//                .id(controller.idPvEdt)
//                .labelsHidden().frame(width: geometry.size.width * (2/8), height: 100).clipped()
//                Text("Selection: \(controller.selectedEdt)")
//              }
//            } else {
//              TextField("Input Data", text: edtInputValue)
//              Text(edtValue)

//              VStack(spacing: 5) {
//                TextField("Input Data", text: edtInputValue,
//                  onEditingChanged: { begin in
//                      if begin {
//                          self.flagEditting = true
//                          self.edtValue = ""
//                      } else {
//                          self.flagEditting = false
//                      }
//                  },
//                  /// リターンキーが押された時の処理
//                  onCommit: {
//                      self.edtValue = "、\(self.edtInputValue)"
//                      self.edtInputValue = ""
//                  })
//                  .textFieldStyle(RoundedBorderTextFieldStyle()) // 入力域を枠で囲む
//                  .padding()      // 余白を追加
//                  // 編集フラグがONの時に枠に影を付ける
//                  .shadow(color: flagEditting ? .blue : .clear, radius: 3)
//                Text(edtValue)
//              }
//            }
//          }
        

        HStack {
          List{
            Text("Tx: \(controller.txContents)")
            Text("Rx: \(controller.rxContents)")
            Text("\(controller.rxSubContents)")
//            Text("Tx: \(controller.udpSentData)")
//            Text("Rx: \(controller.address): \(controller.udpData)")
//            Text("EPC: \(controller.rxEpc), EDT: \(controller.rxEdt)")
          }.environment(\.defaultMinListRowHeight, 0).font(.callout)
//          VStack(spacing: 0.0) {
//            Text("EDT").font(.headline)
//            Picker(selection: $controller.selectedEdt, label: Text("Label")) {
//              ForEach(0 ..< self.edts.count) {
//                Text(String(self.edts[$0], radix: 16).uppercased()).font(.title2)
//              }
//            }
//            .id(controller.idPvEdt)
//            .labelsHidden().frame(width: geometry.size.width * (2/8), height: 100).clipped()
//            Text("Selection: \(controller.selectedEdt)")
//          }
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
