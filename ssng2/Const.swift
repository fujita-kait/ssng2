//  SSNG:Const.swift
//
//  Created by Hiro Fujita on 2016.1.8, update on 2016.06.09
//  Copyright (c) 2016 Hiro Fujita. All rights reserved.

import Foundation

struct EL {
  static let defaultNode = Node(
    address: "224.0.23.0", makerCode: "xxx",
    eojs: [
      Eoj(d1: 0x01, d2: 0x30, d3: 0x01),
      Eoj(d1: 0x01, d2: 0x35, d3: 0x01),
      Eoj(d1: 0x02, d2: 0x60, d3: 0x01),
      Eoj(d1: 0x02, d2: 0x6B, d3: 0x01),
      Eoj(d1: 0x02, d2: 0x6F, d3: 0x01),
      Eoj(d1: 0x02, d2: 0x72, d3: 0x01),
      Eoj(d1: 0x02, d2: 0x73, d3: 0x01),
      Eoj(d1: 0x02, d2: 0x79, d3: 0x01),
      Eoj(d1: 0x02, d2: 0x88, d3: 0x01),
      Eoj(d1: 0x02, d2: 0x90, d3: 0x01)
    ]
  )
  
  // ESV
    static let esv:[UInt8:String] = [0x60:"SetI",0x61:"SetC",0x62:"Get",0x63:"Inf_Req"]
//    static let esv:[UInt8:String] = [0x50:"SetI_SNA",0x51:"SetC_SNA",0x52:"Get_SNA",0x53:"INF_SNA",0x5E:"SetGet_SNA",0x60:"SetI",0x61:"SetC",0x62:"Get",0x63:"Inf_Req",0x6E:"SetGet",0x71:"Set_Res",0x72:"Get_Res",0x73:"INF",0x74:"INFC"]
    
    // EL Objects
    static let objects:[UInt16:ElObj] = [0x0011:obj0011,0x0012:obj0012,0x002D:obj002D,0x0130:obj0130,0x0133:obj0133,0x0135:obj0135,0x0260:obj0260,0x026B:obj026B,0x026F:obj026F,0x0272:obj0272,0x0273:obj0273,0x0279:obj0279,0x027A:obj027A,0x027B:obj027B,0x027D:obj027D,0x0287:obj0287,0x0288:obj0288,0x0290:obj0290,0x0291:obj0291,0x03B7:obj03B7,0x05FF:obj05FF,0x0EF0:obj0EF0]

    // EL Object: Node Profile including Super Class
    static let obj0EF0 = ElObj(name: "Node Profile", properties: [0x80:epc80,0x82:epc82N,0x83:epc83N,0x88:epc88N,0x89:epc89,0x8A:epc8A,0x8B:epc8B,0x8C:epc8C,0x8D:epc8D,0x8E:epc8E,0x9D:epc9D,0x9E:epc9E,0x9F:epc9F,0xD3:epcD3N,0xD4:epcD4N,0xD5:epcD5N,0xD6:epcD6N,0xD7:epcD7N])

    // EL Object: Devices (excluding Superclass properties)
    static let obj0011 = ElObj(name: "温度センサー", properties: [0xE0:eoj0011epcE0])
    static let obj0012 = ElObj(name: "湿度センサー", properties: [0xE0:eoj0012epcE0])
    static let obj002D = ElObj(name: "気圧センサー", properties: [0xE0:eoj002DepcE0])
    static let obj0130 = ElObj(name: "エアコン", properties: [0xB0:eoj0130epcB0,0xB1:eoj0130epcB1,0xB3:eoj0130epcB3,0xB5:eoj0130epcB5,0xB6:eoj0130epcB6,0xBA:eoj0130epcBA,0xBB:eoj0130epcBB,0xBE:eoj0130epcBE,0xA0:eoj0130epcA0])
    static let obj0133 = ElObj(name: "換気扇", properties: [0xA0:eoj0133epcA0,0xBF:eoj0133epcBF])
    static let obj0135 = ElObj(name: "空気清浄機", properties: [0xA0:eoj0135epcA0])
    static let obj0260 = ElObj(name: "電動ブラインド", properties: [0xE0:eoj0260epcE0,0xE1:eoj0260epcE1,0xE2:eoj0260epcE2,0xE3:eoj0260epcE3])
    static let obj026B = ElObj(name: "温水器", properties: [0xB0:eoj026BepcB0,0xB3:eoj026BepcB3])
    static let obj026F = ElObj(name: "電気錠", properties: [0xE0:eoj026FepcE0])
    static let obj0272 = ElObj(name: "給湯器", properties: [0xD0:eoj0272epcD0,0xE2:eoj0272epcE2,0xE3:eoj0272epcE3])
    static let obj0273 = ElObj(name: "浴室暖房乾燥", properties: [0xB0:eoj0273epcB0,0xB2:eoj0273epcB2,0xB4:eoj0273epcB4])
    static let obj0279 = ElObj(name: "太陽光発電", properties: [0xE0:eoj0279epcE0,0xE1:eoj0279epcE1])
    static let obj027A = ElObj(name: "冷温水熱源機", properties: [0xE0:eoj027AepcE0,0xE1:eoj027AepcE1,0xE2:eoj027AepcE2])
    static let obj027B = ElObj(name: "床暖房", properties: [0xE0:eoj027BepcE0,0xE1:eoj027BepcE1])
    static let obj027D = ElObj(name: "蓄電池", properties: [0xCF:eoj027DepcCF,0xDA:eoj027DepcDA,0xE2:eoj027DepcE2,0xE3:eoj027DepcE3,0xE4:eoj027DepcE4,0xE6:eoj027DepcE6])
    static let obj0287 = ElObj(name: "分電盤", properties: [0xC0:eoj0287epcC0,0xC1:eoj0287epcC1,0xC2:eoj0287epcC2,0xC6:eoj0287epcC6,0xC7:eoj0287epcC7,0xD0:eoj0287epcD0,0xD1:eoj0287epcD1,0xD2:eoj0287epcD2,0xD3:eoj0287epcD3])
    static let obj0288 = ElObj(name: "スマートメータ", properties: [0xD7:eoj0288epcD7,0xE0:eoj0288epcE0,0xE1:eoj0288epcE1,0xE2:eoj0288epcE2,0xE3:eoj0288epcE3,0xE4:eoj0288epcE4,0xE5:eoj0288epcE5,0xE7:eoj0288epcE7,0xE8:eoj0288epcE8,0xEA:eoj0288epcEA,0xEB:eoj0288epcEB])
    static let obj0290 = ElObj(name: "一般照明", properties: [0xB0:eoj0290epcB0,0xB6:eoj0290epcB6,0xB7:eoj0290epcB7,0xC0:eoj0290epcC0])
    static let obj0291 = ElObj(name: "単機能照明", properties: [0xB0:eoj0290epcB0])
    static let obj03B7 = ElObj(name: "冷凍冷蔵庫", properties: [0xB0:eoj03B7epcB0,0xB1:eoj03B7epcB1,0xB2:eoj03B7epcB2,0xB3:eoj03B7epcB3,0xB4:eoj03B7epcB4,0xB5:eoj03B7epcB5,0xB6:eoj03B7epcB6])
//    static let obj03CB = ElObj(name: "電気掃除機", properties: nil)
    static let obj05FF = ElObj(name: "コントローラ", properties: [0xC0:eoj05FFepcC0])

    
    // Properties: Super Class for devices
    static let propertiesSC:[UInt8:ElProperty] =
        [0x80:epc80,0x81:epc81,0x82:epc82,0x83:epc83,0x84:epc84,0x85:epc85,0x86:epc86,0x87:epc87,0x88:epc88,0x89:epc89,0x8A:epc8A,0x8B:epc8B,0x8C:epc8C,0x8D:epc8D,0x8E:epc8E,0x8F:epc8F,0x93:epc93,0x97:epc97,0x98:epc98,0x99:epc99,0x9A:epc9A,0x9D:epc9D,0x9E:epc9E,0x9F:epc9F]
    
    // EPC: Super Class for Device Objects
    static let epc80 = ElProperty(name:"動作状態", size:1, set:true, required:true, anno:true, edt:[0x30:"ON",0x31:"OFF"])
    static let epc81 = ElProperty(name:"設置場所", size:1, set:true, required:true, anno:true,
        edt:[0x00:"未設定",0x08:"リビング",0x10:"ダイニング",0x18:"キッチン",0x20:"浴室",0x28:"トイレ",0x30:"洗面所",0x38:"廊下",0x40:"部屋",0x48:"階段",0x50:"玄関",0x58:"納戸",0x60:"庭",0x68:"車庫",0x70:"ベランダ",0x78:"その他",0xFF:"不定"])
    static let epc82 = ElProperty(name:"規格Version", size:4, set:false, required:true, anno:false, edt:[0x00004200:"B",0x00004300:"C",0x00004400:"D",0x00004500:"E",0x00004600:"F",0x00004700:"G",0x00004800:"H",0x00004900:"I",0x00004A00:"J",0x00004B00:"K"])
    static let epc83 = ElProperty(name:"識別番号", size:17, set:false, required:false, anno:false, edt:nil)
    static let epc84 = ElProperty(name:"瞬時消費電力計測値", size:2, set:false, required:false, anno:false, edt:nil)
    static let epc85 = ElProperty(name:"積算消費電力計測値", size:4, set:false, required:false, anno:false, edt:nil)
    static let epc86 = ElProperty(name:"メーカー異常コード", size:225, set:false, required:false, anno:false, edt:nil)
    static let epc87 = ElProperty(name:"電流制限設定", size:1, set:true, required:false, anno:false, edt:nil)
    static let epc88 = ElProperty(name:"異常発生状態", size:1, set:false, required:true, anno:true, edt:[0x41:"異常あり",0x42:"異常無し"])
    static let epc89 = ElProperty(name:"異常内容", size:2, set:false, required:false, anno:true, edt:nil)
    static let epc8A = ElProperty(name:"メーカコード", size:3, set:false, required:true, anno:false, edt:edtMakerCode)
    static let epc8B = ElProperty(name:"事業場コード", size:3, set:false, required:false, anno:false, edt:nil)
    static let epc8C = ElProperty(name:"商品コード", size:12, set:false, required:false, anno:false, edt:nil)
    static let epc8D = ElProperty(name:"製造番号", size:12, set:false, required:false, anno:false, edt:nil)
    static let epc8E = ElProperty(name:"製造年月日", size:4, set:false, required:false, anno:false, edt:nil)
    static let epc8F = ElProperty(name:"節電動作", size:1, set:true, required:false, anno:false, edt:[0x41:"節電",0x42:"通常"])
    static let epc93 = ElProperty(name:"遠隔操作設定", size:1, set:true, required:false, anno:false, edt:[0x41:"公衆回線未経由",0x42:"公衆回線経由"])
    static let epc97 = ElProperty(name:"現在時刻設定", size:2, set:true, required:false, anno:false, edt:nil)
    static let epc98 = ElProperty(name:"現在年月日設定", size:4, set:true, required:false, anno:false, edt:nil)
    static let epc99 = ElProperty(name:"電力制限設定", size:2, set:true, required:false, anno:false, edt:nil)
    static let epc9A = ElProperty(name:"積算運転時間", size:5, set:false, required:false, anno:false, edt:nil)
    static let epc9D = ElProperty(name:"状変アナウンス", size:17, set:false, required:true, anno:false, edt:nil)
    static let epc9E = ElProperty(name:"Setプロパティ", size:17, set:false, required:true, anno:false, edt:nil)
    static let epc9F = ElProperty(name:"Getプロパティ", size:17, set:false, required:true, anno:false, edt:nil)
    
    // EPC:0EF0:Node Profile
    static let epc82N = ElProperty(name:"規格Version", size:4, set:false, required:true, anno:false, edt:[0x01010100:"V1.01",0x010A0100:"V1.10",0x010B0100:"V1.11",0x010C0100:"V1.12",0x010D0100:"V1.13",0x010E0100:"V1.14",0x010F0100:"V1.15"])
    static let epc83N = ElProperty(name:"識別番号", size:17, set:false, required:true, anno:false, edt:nil)
    static let epc88N = ElProperty(name:"異常発生状態", size:1, set:false, required:false, anno:true, edt:[0x41:"異常あり",0x42:"異常無し"])
    static let epcBFN = ElProperty(name:"個体識別情報",size:2, set:true, required:false, anno:false, edt:[0x0000:"0000",0x0001:"0001",0x0002:"0002",0x0003:"0003",0x0004:"0004",0x0005:"0005",0x0006:"0006",0x0007:"0007",0x0008:"0008",0x0009:"0009",0x000A:"000A"])
    static let epcD3N = ElProperty(name:"Instance 数",size:3, set:false, required:true, anno:false, edt:nil)
    static let epcD4N = ElProperty(name:"Class 数",size:2, set:false, required:true, anno:false, edt:nil)
    static let epcD5N = ElProperty(name:"Instance List",size:253, set:false, required:true, anno:true, edt:nil)
    static let epcD6N = ElProperty(name:"Instance ListS",size:253, set:false, required:true, anno:false, edt:nil)
    static let epcD7N = ElProperty(name:"Class ListS",size:17, set:false, required:true, anno:false, edt:nil)
    
    // EPC:0011:温度センサ
    static let eoj0011epcE0 = ElProperty(name: "温度計測値", size: 2, set: false, required: true, anno: false, edt:edtTemp)
    // EPC:0012:湿度センサ
    static let eoj0012epcE0 = ElProperty(name: "湿度計測値", size: 1, set: false, required: true, anno: false, edt:edt0_100)
    // EPC:0012:気圧センサ
    static let eoj002DepcE0 = ElProperty(name: "気圧計測値", size: 2, set: false, required: true, anno: false, edt:edtAirPressure)
    // EPC:0130:エアコン
    static let eoj0130epcB0 = ElProperty(name: "運転モード", size: 1, set: true, required: true, anno: true, edt:[0x41:"自動",0x42:"冷房",0x43:"暖房",0x44:"除湿",0x45:"送風",0x40:"その他"])
    static let eoj0130epcB1 = ElProperty(name: "温度自動設定", size: 1, set: true, required: false, anno: false, edt:[0x41:"AUTO",0x42:"MANUAL"])
    static let eoj0130epcB3 = ElProperty(name: "温度設定値", size: 1, set: true, required: true, anno: false, edt:edt0_50)
    static let eoj0130epcB5 = ElProperty(name: "冷房温度設定値", size: 1, set: true, required: false, anno: false, edt:edt0_50)
    static let eoj0130epcB6 = ElProperty(name: "暖房温度設定値", size: 1, set: true, required: false, anno: false, edt:edt0_50)
    static let eoj0130epcBA = ElProperty(name: "湿度計測値", size: 1, set: false, required: false, anno: false, edt:edt0_100)
    static let eoj0130epcBB = ElProperty(name: "温度計測値", size: 1, set: false, required: false, anno: false, edt:edt0_50)
    static let eoj0130epcBE = ElProperty(name: "外気温度計測値", size: 1, set: false, required: false, anno: false, edt:edt0_50)
    static let eoj0130epcA0 = ElProperty(name: "風量設定", size: 1, set: true, required: false, anno: false, edt:edtWind)
    // EPC:0133:換気扇
    static let eoj0133epcA0 = ElProperty(name: "風量設定", size: 1, set: true, required: false, anno: false, edt:edtWind)
    static let eoj0133epcBF = ElProperty(name: "自動設定", size: 1, set: true, required: false, anno: false, edt:edtAutoManual)
    // EPC:0135:空気清浄機
    static let eoj0135epcA0 = ElProperty(name: "風量設定", size: 1, set: true, required: false, anno: false, edt:edtWind)
    // EPC:0260:ブラインド
    static let eoj0260epcE0 = ElProperty(name: "開閉動作設定", size: 1, set: true, required: true, anno: false, edt:[0x41:"開",0x42:"閉",0x43:"停止"])
    static let eoj0260epcE1 = ElProperty(name: "開度レベル設定", size: 1, set: true, required: false, anno: false, edt:edt0_100)
    static let eoj0260epcE2 = ElProperty(name: "ブラインド角度設定値", size: 1, set: true, required: false, anno: false, edt:edt0_180)
    static let eoj0260epcE3 = ElProperty(name: "開閉速度設定", size: 1, set: true, required: false, anno: false, edt:edtL_H)
    // EPC:026B:温水器
    static let eoj026BepcB0 = ElProperty(name:"沸上自動設定", size: 1, set: true, required: true, anno: false, edt:[0x41:"自動",0x42:"手動沸上",0x43:"手動沸上停止"])
    static let eoj026BepcB3 = ElProperty(name:"温度設定値", size: 1, set: true, required: false, anno: false, edt:edt0_100)
    // EPC:026F:電気錠
    static let eoj026FepcE0 = ElProperty(name:"施錠設定１", size: 1, set: true, required: true, anno: true, edt:[0x41:"施錠",0x42:"解錠"])
    // EPC:0272:給湯器
    static let eoj0272epcD0 = ElProperty(name:"給湯器燃焼状態", size: 1, set: false, required: true, anno: false, edt:[0x41:"有",0x42:"無"])
    static let eoj0272epcE2 = ElProperty(name:"風呂給湯器燃焼状態", size: 1, set: false, required: true, anno: false, edt:[0x41:"有",0x42:"無"])
    static let eoj0272epcE3 = ElProperty(name:"風呂自動モード設定", size: 1, set: true, required: true, anno: true, edt:[0x41:"入",0x42:"解除"])
    // EPC:0273:浴室暖房乾燥
    static let eoj0273epcB0 = ElProperty(name:"運転設定", size: 1, set: true, required: true, anno: false, edt:[0x00:"停止",0x10:"換気",0x20:"予備暖房",0x30:"暖房",0x40:"乾燥",0x50:"涼風"])
    static let eoj0273epcB2 = ElProperty(name:"予備暖房運転設定", size: 1, set: true, required: true, anno: false, edt:[0x41:"自動",0x42:"標準",0x31:"1",0x32:"2",0x33:"3",0x34:"4",0x35:"5",0x36:"6",0x37:"7",0x38:"8"])
    static let eoj0273epcB4 = ElProperty(name:"乾燥運転設定", size: 1, set: true, required: true, anno: false, edt:[0x41:"自動",0x42:"標準",0x31:"1",0x32:"2",0x33:"3",0x34:"4",0x35:"5",0x36:"6",0x37:"7",0x38:"8"])
    // EPC:0279:太陽光発電
    static let eoj0279epcE0 = ElProperty(name:"瞬時発電電力", size: 2, set: false, required: true, anno: false, edt:nil)
    static let eoj0279epcE1 = ElProperty(name:"積算発電電力量", size: 4, set: false, required: true, anno: false, edt:nil)
    // EPC:027A:冷温水熱源機
    static let eoj027AepcE0 = ElProperty(name:"動作状態", size: 1, set: true, required: false, anno: false, edt:[0x41:"暖房",0x42:"冷房"])
    static let eoj027AepcE1 = ElProperty(name:"水温設定値", size: 1, set: true, required: false, anno: false, edt:edt0_100A)
    static let eoj027AepcE2 = ElProperty(name:"水温設定レベル", size: 1, set: true, required: false, anno: false, edt:[0x21:"C1",0x22:"C2",0x23:"C3",0x24:"C4",0x25:"C5",0x26:"C6",0x27:"C7",0x28:"C8",0x29:"C9",0x2A:"C10",0x2B:"C11",0x2C:"C12",0x2D:"C13",0x2E:"C14",0x2F:"C15",0x31:"H1",0x32:"H2",0x33:"H3",0x34:"H4",0x35:"H5",0x36:"H6",0x37:"H7",0x38:"H8",0x39:"H9",0x3A:"H10",0x3B:"H11",0x3C:"H12",0x3D:"H13",0x3E:"H14",0x3F:"H15",0x41:"AUTO"])
    // EPC:027B:床暖房
    static let eoj027BepcE0 = ElProperty(name:"温度設定値", size: 1, set: true, required: true, anno: false, edt:edt0_50)
    static let eoj027BepcE1 = ElProperty(name:"温度レベル", size: 1, set: true, required: true, anno: false, edt:edt15Level)
    // EPC:027D:蓄電池
    static let eoj027DepcCF = ElProperty(name:"運転動作状態", size: 1, set: false, required: true, anno: false, edt:[0x41:"急速充電",0x42:"充電",0x43:"放電",0x44:"待機",0x45:"テスト",0x40:"その他"])
    static let eoj027DepcDA = ElProperty(name:"運転モード設定", size: 1, set: true, required: true, anno: false, edt:[0x41:"急速充電",0x42:"充電",0x43:"放電",0x44:"待機",0x45:"テスト",0x40:"その他"])
    static let eoj027DepcE2 = ElProperty(name:"蓄電残量１", size: 4, set: false, required: true, anno: false, edt:nil)
    static let eoj027DepcE3 = ElProperty(name:"蓄電残量２", size: 2, set: false, required: true, anno: false, edt:nil)
    static let eoj027DepcE4 = ElProperty(name:"蓄電残量３", size: 1, set: false, required: true, anno: false, edt:nil)
    static let eoj027DepcE6 = ElProperty(name:"蓄電池タイプ", size: 1, set: false, required: true, anno: false, edt:[0x01:"鉛",0x02:"ニッケル水素",0x03:"NiCd",0x04:"リチウムイオン",0x05:"Zn",0x06:"充電式アルカリ"])
    // EPC:0287:分電盤
    static let eoj0287epcC0 = ElProperty(name:"積算電力量:正", size: 4, set: false, required: true, anno: false, edt:nil)
    static let eoj0287epcC1 = ElProperty(name:"積算電力量:逆", size: 4, set: false, required: true, anno: false, edt:nil)
    static let eoj0287epcC2 = ElProperty(name:"積算電力量単位", size: 1, set: false, required: true, anno: false, edt:nil)
    static let eoj0287epcC6 = ElProperty(name:"瞬時電力計測値", size: 4, set: false, required: false, anno: false, edt:nil)
    static let eoj0287epcC7 = ElProperty(name:"瞬時電流計測値", size: 4, set: false, required: false, anno: false, edt:nil)
    static let eoj0287epcD0 = ElProperty(name:"計測チャネル１", size: 8, set: false, required: false, anno: false, edt:nil)
    static let eoj0287epcD1 = ElProperty(name:"計測チャネル２", size: 8, set: false, required: false, anno: false, edt:nil)
    static let eoj0287epcD2 = ElProperty(name:"計測チャネル３", size: 8, set: false, required: false, anno: false, edt:nil)
    static let eoj0287epcD3 = ElProperty(name:"計測チャネル４", size: 8, set: false, required: false, anno: false, edt:nil)
    // EPC:0288:スマートメータ
    static let eoj0288epcD7 = ElProperty(name:"積算電力量有効桁数", size: 1, set: false, required: true, anno: false, edt:nil)
    static let eoj0288epcE0 = ElProperty(name:"積算電力量計測値:正方向", size: 4, set: false, required: true, anno: false, edt:nil)
    static let eoj0288epcE1 = ElProperty(name:"積算電力量単位", size: 1, set: false, required: true, anno: false, edt:nil)
    static let eoj0288epcE2 = ElProperty(name:"積算電力量計測値履歴１:正方向", size: 194, set: false, required: true, anno: false, edt:nil)
    static let eoj0288epcE3 = ElProperty(name:"積算電力量計測値:逆方向", size: 4, set: false, required: true, anno: false, edt:nil)
    static let eoj0288epcE4 = ElProperty(name:"積算電力量計測値履歴１:逆方向", size: 194, set: false, required: true, anno: false, edt:nil)
    static let eoj0288epcE5 = ElProperty(name:"積算履歴収集日１", size: 1, set: true, required: true, anno: false, edt:[0x00:"当日",0x01:"1日前",0x02:"2日前",0x03:"3日前",0x04:"4日前",0x05:"5日前",0x06:"6日前",0x07:"7日前",0x63:"99日前"])
    static let eoj0288epcE7 = ElProperty(name:"瞬時電力計測値", size: 4, set: false, required: true, anno: false, edt:nil)
    static let eoj0288epcE8 = ElProperty(name:"瞬時電流計測値", size: 4, set: false, required: true, anno: false, edt:nil)
    static let eoj0288epcEA = ElProperty(name:"定時積算電力量:正方向", size: 11, set: false, required: true, anno: false, edt:nil)
    static let eoj0288epcEB = ElProperty(name:"定時積算電力量:逆方向", size: 11, set: false, required: true, anno: false, edt:nil)
    // EPC:0290:一般照明
    static let eoj0290epcB0 = ElProperty(name:"照度レベル", size: 1, set: true, required: false, anno: false, edt:edt0_100)
    static let eoj0290epcB6 = ElProperty(name:"点灯モード", size: 1, set: true, required: true, anno: false, edt:[0x41:"自動",0x42:"通常灯",0x43:"常夜灯",0x45:"カラー灯"])
    static let eoj0290epcB7 = ElProperty(name:"通常灯照度レベル", size: 1, set: true, required: false, anno: false, edt:edt0_100)
    static let eoj0290epcC0 = ElProperty(name:"RGB設定", size: 3, set: true, required: false, anno: false, edt:[0x000000:"Black",0xFF0000:"Red",0x00FF00:"Green",0x0000FF:"Blue",0xFFFF00:"Yellow",0xFF00FF:"Mazenta",0x00FFFF:"Cyan",0xFFFFFF:"White"])
   
    // EPC:03B7:冷凍冷蔵庫
    static let eoj03B7epcB0 = ElProperty(name:"ドア開閉状態", size: 1, set: false, required: true, anno: false, edt:[0x41:"開:OPEN", 0x42:"閉:CLOSE"])
    static let eoj03B7epcB1 = ElProperty(name:"ドア開放警告状態", size: 1, set: false, required: false, anno: true, edt:[0x41:"警告有", 0x42:"警告無"])
    static let eoj03B7epcB2 = ElProperty(name:"冷蔵室ドア開閉状態", size: 1, set: false, required: false, anno: false, edt:[0x41:"開:OPEN", 0x42:"閉:CLOSE"])
    static let eoj03B7epcB3 = ElProperty(name:"冷凍室ドア開閉状態", size: 1, set: false, required: false, anno: false, edt:[0x41:"開:OPEN", 0x42:"閉:CLOSE"])
    static let eoj03B7epcB4 = ElProperty(name:"氷温室ドア開閉状態", size: 1, set: false, required: false, anno: false, edt:[0x41:"開:OPEN", 0x42:"閉:CLOSE"])
    static let eoj03B7epcB5 = ElProperty(name:"野菜室ドア開閉状態", size: 1, set: false, required: false, anno: false, edt:[0x41:"開:OPEN", 0x42:"閉:CLOSE"])
    static let eoj03B7epcB6 = ElProperty(name:"切替室ドア開閉状態", size: 1, set: false, required: false, anno: false, edt:[0x41:"開:OPEN", 0x42:"閉:CLOSE"])
    // EPC:03CB:電気掃除機
    
    // EPC:05FF:コントローラ
    static let eoj05FFepcC0 = ElProperty(name: "コントローラID", size: 40, set: false, required: false, anno: false, edt:nil)
  
    // EDT:
    static let edtMakerCode:[UInt:String] = [0x000001:"日立製作所",0x000005:"シャープ",0x000006:"三菱電機",0x000008:"ダイキン",0x00000B:"パナソニック",0x000016:"東芝",0x00001B:"東芝ライテック",0x000023:"NTTコムウェア",0x00002C:"AFT",0x000036:"日新システムズ",0x000039:"サンデン",0x00004E:"富士通",0x000053:"ユビキタス",0x00005E:"GWソーラ",0x000063:"河村電器",0x000064:"オムロン",0x000069:"東芝ライフスタイル",0x00006F:"バッファロー",0x000072:"エナリス",0x000077:"神奈川工科大学",0x00007D:"POWERTECH",0x000078:"日立マクセル",0x000081:"岩崎通信機",0x000086:"NTT西日本",0x00008A:"富士通ゼネラル",0x000097:"未来技術研究所",0x0000A3:"中部電力",0x0000A5:"ニチベイ",0x0000AA:"テンフィートライト"]
    static let edtTemp:[UInt:String] = [0x7fff:"Over Flow",0x8000:"Under Flow",0xFF9C:"-10.0",0x0000:"0.0",0x0032:"5.0",0x0064:"10.0",0x0096:"15.0",0x00C8:"20.0",0x012C:"30.0",0x0190:"40.0"]
    static let edt0_50:[UInt:String] = [0x00:"0",0x0A:"10",0x14:"20",0x16:"22",0x18:"24",0x1A:"26",0x1C:"28",0x1E:"30",0x28:"40",0x32:"50"]
    static let edt0_100:[UInt:String] = [0x00:"0",0x0A:"10",0x14:"20",0x1E:"30",0x28:"40",0x32:"50",0x3C:"60",0x46:"70",0x50:"80",0x5A:"90",0x64:"100"]
    static let edt0_100A:[UInt:String] = [0x00:"0",0x0A:"10",0x14:"20",0x1E:"30",0x28:"40",0x32:"50",0x3C:"60",0x46:"70",0x50:"80",0x5A:"90",0x64:"100",0x71:"AUTO"]
    static let edt0_180:[UInt:String] = [0x00:"0",0x2D:"45",0x5A:"90",0x87:"135",0xB4:"180"]
    static let edtL_H:[UInt:String] = [0x41:"低",0x42:"中",0x43:"高い"]
    static let edtAutoManual:[UInt:String] = [0x41:"Auto",0x42:"Manual"]
    static let edt15Level:[UInt:String] = [0x31:"1",0x32:"2",0x33:"3",0x34:"4",0x35:"5",0x36:"6",0x37:"7",0x38:"8",0x39:"9",0x3A:"10",0x3B:"11",0x3C:"12",0x3D:"13",0x3E:"14",0x3F:"15",0x41:"AUTO"]
    static let edtWind:[UInt:String] = [0x41:"自動",0x31:"1",0x32:"2",0x33:"3",0x34:"4",0x35:"5",0x36:"6",0x37:"7",0x38:"8"]
    static let edtAirPressure:[UInt:String] = [0x2648:"980.0",0x6AC:"990.0",0x2710:"1000.0",0x2774:"1010.0",0x27D8:"1020.0"]
}
