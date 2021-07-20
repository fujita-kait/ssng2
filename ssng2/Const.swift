// ssng2:Const.swift
//
// Created by Hiro Fujita on 2021.07.19
// Copyright (c) 2021 Hiro Fujita. All rights reserved.

import Foundation

struct EL {
  static let mcAddress = "224.0.23.0"
  static let portEL = 3610
//  static let portEL = 3611
  static let ehd = Ehd(d1: 0x10, d2: 0x81)
  static let defaultNode = Node(
    address:"224.0.23.0",makerCode:"000077",
    deviceObjs:[
      DeviceObj(eoj: Eoj(d1:0x00,d2:0x11,d3:0x01)),
      DeviceObj(eoj: Eoj(d1:0x00,d2:0x12,d3:0x01)),
      DeviceObj(eoj: Eoj(d1:0x00,d2:0x2D,d3:0x01)),
      DeviceObj(eoj: Eoj(d1:0x01,d2:0x30,d3:0x01)),
      DeviceObj(eoj: Eoj(d1:0x01,d2:0x33,d3:0x01)),
      DeviceObj(eoj: Eoj(d1:0x01,d2:0x35,d3:0x01)),
      DeviceObj(eoj: Eoj(d1:0x02,d2:0x60,d3:0x01)),
      DeviceObj(eoj: Eoj(d1:0x02,d2:0x6B,d3:0x01)),
      DeviceObj(eoj: Eoj(d1:0x02,d2:0x6F,d3:0x01)),
      DeviceObj(eoj: Eoj(d1:0x02,d2:0x72,d3:0x01)),
      DeviceObj(eoj: Eoj(d1:0x02,d2:0x73,d3:0x01)),
      DeviceObj(eoj: Eoj(d1:0x02,d2:0x79,d3:0x01)),
      DeviceObj(eoj: Eoj(d1:0x02,d2:0x7A,d3:0x01)),
      DeviceObj(eoj: Eoj(d1:0x02,d2:0x7B,d3:0x01)),
      DeviceObj(eoj: Eoj(d1:0x02,d2:0x7D,d3:0x01)),
      DeviceObj(eoj: Eoj(d1:0x02,d2:0x87,d3:0x01)),
      DeviceObj(eoj: Eoj(d1:0x02,d2:0x88,d3:0x01)),
      DeviceObj(eoj: Eoj(d1:0x02,d2:0x90,d3:0x01)),
      DeviceObj(eoj: Eoj(d1:0x02,d2:0x91,d3:0x01)),
      DeviceObj(eoj: Eoj(d1:0x03,d2:0xB7,d3:0x01)),
      DeviceObj(eoj: Eoj(d1:0x05,d2:0xFF,d3:0x01))
    ]
  )
  
  // ESV
//  static let esv:[String:String] = ["60":"SetI","61":"SetC","62":"Get","63":"Inf_Req","73":"Inf"]
  static let esv:[String:String] = ["61":"SetC","62":"Get"]

  // Data type "state"
  static let stateLevelAndAuto:[String:String] = ["41":"Automatic","31":"1","32":"2","33":"3","34":"4","35":"5","36":"6","37":"7","38":"8"]
  static let stateL_H:[String:String] = ["41":"低","42":"中","43":"高い"]
  static let stateAutoManual:[String:String] = ["41":"Auto","42":"Manual"]
  static let state15Level:[String:String] = ["31":"1","32":"2","33":"3","34":"4","35":"5","36":"6","37":"7","38":"8","39":"9","3A":"10","3B":"11","3C":"12","3D":"13","3E":"14","3F":"15","41":"Automatic"]
  // Maker Code
  static let makerCode:[String:String] = [
    "000001":"日立製作所",
    "000005":"シャープ",
    "000006":"三菱電機",
    "000008":"ダイキン",
    "00000B":"パナソニック",
    "000016":"東芝",
    "000017":"東芝キヤリア",
    "00001B":"東芝ライテック",
    "000022":"日立アプライアンス",
    "000023":"NTTコムウェア",
    "000025":"LIXIL",
    "00002C":"AFT",
    "00002E":"四国計測工業",
    "00002F":"アイホン",
    "000034":"三菱電機エンジニアリング",
    "000035":"東光東芝メーターシステムズ",
    "000036":"日新システムズ",
    "000039":"サンデン",
    "00003B":"京セラ",
    "00004E":"富士通",
    "00004F":"大和ハウス工業",
    "000050":"ＴＯＴＯ",
    "000052":"大崎電気工業",
    "000053":"ユビキタス",
    "000054":"ノーリツ",
    "000057":"エリーパワー",
    "000058":"メディオテック",
    "000059":"リンナイ",
    "00005E":"GWソーラ",
    "000063":"河村電器",
    "000064":"オムロン",
    "000067":"コロナ",
    "000068":"アイシン精機",
    "000069":"東芝ライフスタイル",
    "00006A":"岡谷鋼機",
    "00006B":"アイ・エス・ビー",
    "00006C":"ニチコン",
    "00006F":"バッファロー",
    "000072":"エナリス",
    "000075":"リコー",
    "000076":"TSP",
    "000077":"神奈川工科大学",
    "000078":"日立マクセル",
    "00007D":"POWERTECH",
    "00007E":"SMK",
    "000081":"岩崎通信機",
    "000082":"パーパス",
    "000083":"メルコテクノ横浜",
    "000084":"ローム",
    "000085":"東光高岳",
    "000086":"NTT西日本",
    "000087":"アイ･オー･データ機器",
    "00008A":"富士通ゼネラル",
    "00008C":"九電テクノシステムズ",
    "000097":"未来技術研究所",
    "000099":"東京電力ホールディングス",
    "00009A":"関西電力",
    "00009E":"安川電機",
    "00009F":"GSユアサ",
    "0000A3":"中部電力",
    "0000A5":"ニチベイ",
    "0000AA":"テンフィートライト",
    "0000AC":"IDEC",
    "0000AD":"デルタ電子",
    "0000AE":"四国電力",
    "0000B0":"ナルテック",
    "0000B3":"TOPPERSプロジェクト",
    "0000B5":"中国電力",
    "0000B6":"文化シヤッター",
    "0000B8":"北海道電力",
    "0000BA":"三協立山",
    "0000BB":"北陸電力",
    "0000BC":"東北電力",
    "0000BE":"デンケン",
    "0000BF":"九州電力",
    "0000C2":"東北計器工業",
    "0000C5":"三和シヤッター工業",
    "0000CA":"ジェイエスピー",
    "0000CB":"富士電機",
    "0000CC":"日立ジョンソンコントロールズ空調",
    "0000CD":"トクラス",
    "0000D0":"椿本チエイン",
    "0000D4":"村田製作所",
    "0000DA":"パナソニック産機システムズ",
    "0000DB":"サンテックパワージャパン",
    "0000DC":"日本テクノ",
    "0000DD":"エナ・ストーン",
    "0000E2":"NextDrive",
    "0000E8":"コイズミ照明",
    "0000E9":"NTTスマイルエナジー"  ]

  // Device Descriptions
  static let deviceDescriptions:[String:ElDevObj] = [
    "0011":ElDevObj(name:"温度センサー",
                    props:["E0":ElProp(name:"温度計測値",size:2,type:.number,multiple:0.1)]),
    "0012":ElDevObj(name:"湿度センサー",
                    props:["E0":ElProp(name:"湿度計測値",size:1,type:.number)]),
    "002D":ElDevObj(name:"気圧センサー",
                    props:["E0":ElProp(name:"気圧計測値",size:2,type:.number,multiple:0.1)]),
    "0130":ElDevObj(name:"エアコン",
                    props:[
                      "90":ElProp(name:"ONタイマ予約設定",size:1,type:.state,state:["41":"時刻予約、相対時間予約共に入","42":"予約切","43":"時刻予約のみ入","44":"相対時間予約のみ入"]),
                      "91":ElProp(name:"ONタイマ時刻設定値",size:2,type:.raw),
                      "92":ElProp(name:"ONタイマ相対時間設定値",size:2,type:.raw),
                      "94":ElProp(name:"OFFタイマ予約設定",size:1,type:.state,state:["41":"時刻予約、相対時間予約共に入","42":"予約切","43":"時刻予約のみ入","44":"相対時間予約のみ入"]),
                      "95":ElProp(name:"OFFタイマ時刻設定値",size:2,type:.raw),
                      "96":ElProp(name:"OFFタイマ相対時間設定値",size:2,type:.raw),
                      "B0":ElProp(name:"運転モード",size:1,type:.state,state:["41":"自動","42":"冷房","43":"暖房","44":"除湿","45":"送風","40":"その他"]),
                      "B1":ElProp(name:"温度自動設定",size:1,type:.state,state:["41":"AUTO","42":"MANUAL"]),
                      "B3":ElProp(name:"温度設定値",size:1,type:.number),
                      "B5":ElProp(name:"冷房温度設定値",size:1,type:.number),
                      "B6":ElProp(name:"暖房温度設定値",size:1,type:.number),
                      "BA":ElProp(name:"湿度計測値",size:1,type:.number),
                      "BB":ElProp(name:"温度計測値",size:1,type:.number),
                      "BE":ElProp(name:"外気温度計測値",size:1,type:.number),
                      "A0":ElProp(name:"風量設定",size:1,type:.state,state:stateLevelAndAuto)
                    ]),
    "0133":ElDevObj(name:"換気扇",
                    props:[
                      "A0":ElProp(name:"風量設定",size:1,type:.state,state:stateLevelAndAuto),
                      "BF":ElProp(name:"自動設定",size:1,type:.state,state:stateAutoManual)
                    ]),
    "0135":ElDevObj(name:"空気清浄機",
                    props:["A0":ElProp(name:"風量設定",size:1,type:.state,state:stateLevelAndAuto)]),
    "0260":ElDevObj(name:"電動ブラインド",
                    props:[
                      "E0":ElProp(name:"開閉動作設定",size:1,type:.state,state:["41":"開","42":"閉","43":"停止"]),
                      "E1":ElProp(name:"開度レベル設定",size:1,type:.number),
                      "E2":ElProp(name:"ブラインド角度設定値",size:1,type:.number),
                      "E3":ElProp(name:"開閉速度設定",size:1,type:.state,state:stateL_H)
                    ]),
    "026B":ElDevObj(name:"温水器",
                    props:[
                      "B0":ElProp(name:"沸上自動設定",size:1,type:.state,state:["41":"自動","42":"手動沸上","43":"手動沸上停止"]),
                      "B3":ElProp(name:"温度設定値",size:1,type:.number)]),
    "026F":ElDevObj(name:"電気錠",
                    props:["E0":ElProp(name:"施錠設定１",size:1,type:.state,state:["41":"施錠","42":"解錠"])]),
    "0272":ElDevObj(name:"給湯器",
                    props:[
                      "D0":ElProp(name:"給湯器燃焼状態",size:1,type:.state,state:["41":"有","42":"無"]),
                      "E2":ElProp(name:"風呂給湯器燃焼状態",size:1,type:.state,state:["41":"有","42":"無"]),
                      "E3":ElProp(name:"風呂自動モード設定",size:1,type:.state,state:["41":"入","42":"解除"])]),
    "0273":ElDevObj(name:"浴室暖房乾燥",
                    props:[
                      "B0":ElProp(name:"運転設定",size:1,type:.state,state:["00":"停止","10":"換気","20":"予備暖房","30":"暖房","40":"乾燥","50":"涼風"]),
                      "B2":ElProp(name:"予備暖房運転設定",size:1,type:.state,state:["41":"自動","42":"標準","31":"1","32":"2","33":"3","34":"4","35":"5","36":"6","37":"7","38":"8"]),
                      "B4":ElProp(name:"乾燥運転設定",size:1,type:.state,state:["41":"自動","42":"標準","31":"1","32":"2","33":"3","34":"4","35":"5","36":"6","37":"7","38":"8"])]),
    "0279":ElDevObj(name:"太陽光発電",
                    props:[
                      "E0":ElProp(name:"瞬時発電電力",size:2,type:.number),
                      "E1":ElProp(name:"積算発電電力量",size:4,type:.number,multiple:0.001)]),
    "027A":ElDevObj(name:"冷温水熱源機",
                    props:[
                      "E0":ElProp(name:"動作状態",size:1,type:.state,state:["41":"暖房","42":"冷房"]),
                      "E1":ElProp(name:"水温設定値",size:1,type:.number),
                      "E2":ElProp(name:"水温設定レベル",size:1,type:.state,state:["21":"C1","22":"C2","23":"C3","24":"C4","25":"C5","26":"C6","27":"C7","28":"C8","29":"C9","2A":"C10","2B":"C11","2C":"C12","2D":"C13","2E":"C14","2F":"C15","31":"H1","32":"H2","33":"H3","34":"H4","35":"H5","36":"H6","37":"H7","38":"H8","39":"H9","3A":"H10","3B":"H11","3C":"H12","3D":"H13","3E":"H14","3F":"H15","41":"AUTO"])
                    ]),
    "027B":ElDevObj(name:"床暖房",
                    props:[
                      "E0":ElProp(name:"温度設定値",size:1,type:.number),
                      "E1":ElProp(name:"温度レベル",size:1,type:.number,state:state15Level)
                    ]),
    "027D":ElDevObj(name:"蓄電池",
                    props:[
                      "CF":ElProp(name:"運転動作状態",size:1,type:.state,state:["41":"急速充電","42":"充電","43":"放電","44":"待機","45":"テスト","40":"その他"]),
                      "DA":ElProp(name:"運転モード設定",size:1,type:.state,state:["41":"急速充電","42":"充電","43":"放電","44":"待機","45":"テスト","40":"その他"]),
                      "E2":ElProp(name:"蓄電残量１",size:4,type:.number),
                      "E3":ElProp(name:"蓄電残量２",size:2,type:.number),
                      "E4":ElProp(name:"蓄電残量３",size:1,type:.number),
                      "E6":ElProp(name:"蓄電池タイプ",size:1,type:.state,state:["01":"鉛","02":"ニッケル水素","03":"NiCd","04":"リチウムイオン","05":"Zn","06":"充電式アルカリ"])
                    ]),
    "0287":ElDevObj(name:"分電盤",
                    props:[
                      "C0":ElProp(name:"積算電力量:正",size:4,type:.number),
                      "C1":ElProp(name:"積算電力量:逆",size:4,type:.number),
                      "C2":ElProp(name:"積算電力量単位",size:1,type:.number),
                      "C6":ElProp(name:"瞬時電力計測値",size:4,type:.number),
                      "C7":ElProp(name:"瞬時電流計測値",size:4,type:.number),
                      "D0":ElProp(name:"計測チャネル１",size:8,type:.number),
                      "D1":ElProp(name:"計測チャネル２",size:8,type:.number),
                      "D2":ElProp(name:"計測チャネル３",size:8,type:.number),
                      "D3":ElProp(name:"計測チャネル４",size:8,type:.number)
                    ]),
    "0288":ElDevObj(name:"スマートメータ",
                    props:[
                      "D7":ElProp(name:"積算電力量有効桁数",size:1,type:.number),
                      "E0":ElProp(name:"積算電力量計測値:正方向",size:4,type:.number),
                      "E1":ElProp(name:"積算電力量単位",size:1,type:.number),
                      "E2":ElProp(name:"積算電力量計測値履歴１:正方向",size:194,type:.raw),
                      "E3":ElProp(name:"積算電力量計測値:逆方向",size:4,type:.number),
                      "E4":ElProp(name:"積算電力量計測値履歴１:逆方向",size:194,type:.raw),
                      "E5":ElProp(name:"積算履歴収集日１",size:1,type:.state,state:["00":"当日","01":"1日前","02":"2日前","03":"3日前","04":"4日前","05":"5日前","06":"6日前","07":"7日前","63":"99日前"]),
                      "E7":ElProp(name:"瞬時電力計測値",size:4,type:.number),
                      "E8":ElProp(name:"瞬時電流計測値",size:4,type:.number),
                      "EA":ElProp(name:"定時積算電力量:正方向",size:11,type:.number),
                      "EB":ElProp(name:"定時積算電力量:逆方向",size:11,type:.number)
                    ]),
    "0290":ElDevObj(name:"一般照明",
                    props:[
                      "B0":ElProp(name:"照度レベル",size:1,type:.number),
                      "B6":ElProp(name:"点灯モード",size:1,type:.state,state:["41":"自動","42":"通常灯","43":"常夜灯","45":"カラー灯"]),
                      "B7":ElProp(name:"通常灯照度レベル",size:1,type:.number),
                      "C0":ElProp(name:"RGB設定",size:3,type:.raw)
                    ]),
    "0291":ElDevObj(name:"単機能照明",
                    props:["B0":ElProp(name:"照度レベル",size:1,type:.number)]),
    "03B7":ElDevObj(name:"冷凍冷蔵庫",
                    props:[
                      "B0":ElProp(name:"ドア開閉状態",size:1,type:.state,state:["41":"開:OPEN","42":"閉:CLOSE"]),
                      "B1":ElProp(name:"ドア開放警告状態",size:1,type:.state,state:["41":"警告有","42":"警告無"]),
                      "B2":ElProp(name:"冷蔵室ドア開閉状態",size:1,type:.state,state:["41":"開:OPEN","42":"閉:CLOSE"]),
                      "B3":ElProp(name:"冷凍室ドア開閉状態",size:1,type:.state,state:["41":"開:OPEN","42":"閉:CLOSE"]),
                      "B4":ElProp(name:"氷温室ドア開閉状態",size:1,type:.state,state:["41":"開:OPEN","42":"閉:CLOSE"]),
                      "B5":ElProp(name:"野菜室ドア開閉状態",size:1,type:.state,state:["41":"開:OPEN","42":"閉:CLOSE"]),
                      "B6":ElProp(name:"切替室ドア開閉状態",size:1,type:.state,state:["41":"開:OPEN","42":"閉:CLOSE"])
                    ]),
    "05FF":ElDevObj(name:"コントローラ",
                    props:["C0":ElProp(name:"コントローラID",size:40,type:.raw)])
  ]

  // Super Class
  static let superClass:[String:ElProp] = [
    "80":ElProp(name:"動作状態",size:1,type:.state,state:["30":"ON","31":"OFF"]),
    "81":ElProp(name:"設置場所",size:1,type:.state,
                    state:["00":"未設定","08":"リビング","10":"ダイニング","18":"キッチン","20":"浴室","28":"トイレ","30":"洗面所","38":"廊下","40":"部屋","48":"階段","50":"玄関","58":"納戸","60":"庭","68":"車庫","70":"ベランダ","78":"その他","FF":"不定"]),
    "82":ElProp(name:"規格Version",size:4,type:.state,state:["00004200":"B","00004300":"C","00004400":"D","00004500":"E","00004600":"F","00004700":"G","00004800":"H","00004900":"I","00004A00":"J","00004B00":"K","00004C00":"L","00004D00":"M","00004E00":"N","00005000":"P","00005100":"Q"]),
    "83":ElProp(name:"識別番号",size:17,type:.raw),
    "84":ElProp(name:"瞬時消費電力計測値",size:2,type:.number),
    "85":ElProp(name:"積算消費電力計測値",size:4,type:.number),
    "86":ElProp(name:"メーカー異常コード",size:225,type:.raw),
    "87":ElProp(name:"電流制限設定",size:1,type:.number),
    "88":ElProp(name:"異常発生状態",size:1,type:.state,state:["41":"異常あり","42":"異常無し"]),
    "89":ElProp(name:"異常内容",size:2,type:.raw),
    "8A":ElProp(name:"メーカコード",size:3,type:.state,state:makerCode),
    "8B":ElProp(name:"事業場コード",size:3,type:.raw),
    "8C":ElProp(name:"商品コード",size:12,type:.raw),
    "8D":ElProp(name:"製造番号",size:12,type:.raw),
    "8E":ElProp(name:"製造年月日",size:4,type:.raw),
    "8F":ElProp(name:"節電動作",size:1,type:.state,state:["41":"節電","42":"通常"]),
    "93":ElProp(name:"遠隔操作設定",size:1,type:.state,state:["41":"公衆回線未経由","42":"公衆回線経由"]),
    "97":ElProp(name:"現在時刻設定",size:2,type:.raw),
    "98":ElProp(name:"現在年月日設定",size:4,type:.raw),
    "99":ElProp(name:"電力制限設定",size:2,type:.number),
    "9A":ElProp(name:"積算運転時間",size:5,type:.raw),
    "9D":ElProp(name:"状変アナウンス",size:17,type:.raw),
    "9E":ElProp(name:"Setプロパティ",size:17,type:.raw),
    "9F":ElProp(name:"Getプロパティ",size:17,type:.raw)
  ]

  // Node Profile
  static let nodeProfile:[String:ElProp] = [
    "82":ElProp(name:"規格Version",size:4,state:["01010100":"V1.01","010A0100":"V1.10","010B0100":"V1.11","010C0100":"V1.12","010D0100":"V1.13","010E0100":"V1.14","010F0100":"V1.15"]),
    "83":ElProp(name:"識別番号",size:17,type:.number),
    "88":ElProp(name:"異常発生状態",size:1,type:.state,state:["41":"異常あり","42":"異常無し"]),
    "D3":ElProp(name:"Instance 数",size:3,type:.number),
    "D4":ElProp(name:"Class 数",size:2,type:.number),
    "D5":ElProp(name:"Instance List",size:253,type:.raw),
    "D6":ElProp(name:"Instance ListS",size:253,type:.raw),
    "D7":ElProp(name:"Class ListS",size:17,type:.raw)
  ]

}
