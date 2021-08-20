// ssng2:ContentView.swift
//
// Created by Hiro Fujita on 2021.08.17
// Copyright (c) 2021 Hiro Fujita. All rights reserved.

import SwiftUI

struct ContentView: View {
  var edts: [UInt8]  = [0x30, 0x31]
  var outSocket = OutSocket()
  @ObservedObject var controller = Controller()
  @State private var edtInputValue = ""
  @State private var flagEditting = false
  @State private var inputDataIscorrect = true
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        HStack {
          Text(" ")
          Button(action: {
            print("Send EL")
            self.edtInputValue = "" // Clear TextField
            controller.sendFromUi()
          }) {
            Text("SEND ").font(.title2)
          }
          Button(action: {
            print("SEARCH")
            controller.search()
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
                Text(controller.addressList[index]).font(/*@START_MENU_TOKEN@*/.title3/*@END_MENU_TOKEN@*/)
              }
            }
            .id(controller.idPvNode)
            .labelsHidden().frame(width: geometry.size.width * (5/20), height: 100).clipped()
            Text("\(controller.footerPvIp)").font(.callout)
          }.frame(width: geometry.size.width * (5/20))
          
          
          // PV-EOJ
          VStack(spacing: 0.0) {
            Text("EOJ").font(.headline)
            Picker(selection: $controller.selectedEoj, label: Text("")){
              ForEach(0 ..< controller.eojCodeList.count){ index in
                Text(controller.eojCodeList[index]).font(.title2)
              }
            }
            .id(controller.idPvEoj)
            .labelsHidden().frame(width: geometry.size.width * (3/20), height: 100).clipped()
            Text("\(controller.footerPvEoj)").font(.callout)
          }.frame(width: geometry.size.width * (3/20))
          
          // PV-ESV
          VStack(spacing: 0.0) {
            Text("ESV").font(.headline)
            Picker(selection: $controller.selectedEsv, label: Text("Label")) {
              ForEach(0 ..< controller.esvCodeList.count){ index in
                Text(controller.esvCodeList[index]).font(.title2)
              }
            }
            .id(controller.idPvEsv)
            .labelsHidden().frame(width: geometry.size.width * (2/20), height: 100).clipped()
            Text("\(controller.footerPvEsv)").font(.callout)
          }.frame(width: geometry.size.width * (2/20))
          
          // PV-EPC
          VStack(spacing: 0.0) {
            Text("EPC").font(.headline)
            Picker(selection: $controller.selectedEpc, label: Text("Label")) {
              ForEach(0 ..< controller.epcCodeList.count){ index in
                Text(controller.epcCodeList[index]).font(.title2)
              }
            }
            .id(controller.idPvEpc)
            .labelsHidden().frame(width: geometry.size.width * (5/20), height: 100).clipped()
            Text("\(controller.footerPvEpc)").font(.callout)
          }.frame(width: geometry.size.width * (5/20))
          
          // View-EDT
          VStack(spacing: 0.0) {
            // No View when ESV is "62"
            if !(controller.esvCodeList[controller.selectedEsv] == "62") {
              Text("EDT").font(.headline)
              if controller.edtDataType == .state {
                Picker(selection: $controller.selectedEdt, label: Text("Label")) {
                  ForEach(0 ..< controller.edtCodeList.count){ index in
                    Text(controller.edtCodeList[index]).font(.title2)
                  }
                }
                .id(controller.idPvEdt)
                .labelsHidden().frame(width: geometry.size.width * (5/20), height: 100).clipped()
                Text("\(controller.footerPvEdt)").font(.callout)
              } else if controller.edtDataType == .number {
                Spacer().frame(height: 10)
                Text("10進数 \(controller.edtNumberMultiple)").font(.callout)
                HStack {
                  TextField("28", text: $edtInputValue,
                            onEditingChanged: { begin in
                              if begin {
                                self.flagEditting = true
                              } else {
                                self.flagEditting = false
                              }
                            },
                            /// リターンキーが押された時の処理
                            onCommit: {
                              controller.edtValueFromTextField = "\(self.edtInputValue)"
                            }).keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle()) // 入力域を枠で囲む
                    // 編集フラグがONの時に枠に影を付ける
                    .shadow(color: flagEditting ? .blue : .clear, radius: 3)
                    .id(controller.idPvEdt)
                    .labelsHidden().frame(width: geometry.size.width * (3/20), height: 40).clipped()
                  Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    controller.edtValueFromTextField = "\(self.edtInputValue)"
                  }) {
                    Text("return").font(.callout)
                  }
                }
                Spacer().frame(height: 48)
              } else {  // data type is raw
                Spacer().frame(height: 10)
                if controller.elProp.size == 0 {
                  Text("16進数").font(.callout)
                } else {
                  Text("16進数 \(controller.elProp.size) Byte").font(.callout)
                }
                HStack {
                TextField("FFFF", text: $edtInputValue,
                          onEditingChanged: { begin in
                            if begin {
                              self.flagEditting = true
                            } else {
                              self.flagEditting = false
                            }
                          },
                          /// リターンキーが押された時の処理
                          onCommit: {
                            if controller.validateInputData(a: self.edtInputValue, n: controller.elProp.size) {
                              inputDataIscorrect = true
                              print("Input data is correct!")
                            } else {
                              inputDataIscorrect = false
                              print("Input data is wrong!")
                            }
                            controller.edtValueFromTextField = "\(self.edtInputValue)"
                          })
                  .foregroundColor(inputDataIscorrect ? .black : .red)
                  .textFieldStyle(RoundedBorderTextFieldStyle()) // 入力域を枠で囲む
                  .autocapitalization(UITextAutocapitalizationType.allCharacters)
                  .shadow(color: flagEditting ? .blue : .clear, radius: 3) // 編集フラグがONの時に枠に影を付ける
                  .id(controller.idPvEdt)
                  .labelsHidden().frame(width: geometry.size.width * (3/20), height: 40).clipped()
                  Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    controller.edtValueFromTextField = "\(self.edtInputValue)"
                  }) {
                    Text("return").font(.callout)
                  }
                }
                Spacer().frame(height: 48)
              }
            } else {
              Text("").font(.headline)
              Spacer().frame(height: 100)
              Text("").font(.callout)
            }
          }.frame(width: geometry.size.width * (5/20))
        }
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        
        HStack {
          List{
            Text("Tx: \(controller.txContents)")
            Text("Rx: \(controller.rxContents)")
            Text("\(controller.rxSubContents)")
            Text("\(controller.rxInfContents)")
          }.environment(\.defaultMinListRowHeight, 0).font(.callout)
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
