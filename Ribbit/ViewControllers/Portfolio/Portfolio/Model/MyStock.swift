//
//  MyStock.swift
//  Ribbit
//
//  Created by Rao Mudassar on 13/07/2021.
//

import UIKit

class MyStock: NSObject {
    var assetId: String? = ""
    var symbol: String? = ""
    var unrealizedPlpc: String? = ""
    var unrealizedPl: String? = ""
    var marketValue: String? = ""
    var qty: String? = ""
    var avgEntryPrice: String? = ""
    var changeToday: String? = ""
    var costBasis: Bool? = false
    var exchange: String? = ""
    var open: String? = ""
    var high: String? = ""
    var low: String? = ""
    var volume: String? = ""

    init(assetId: String, symbol: String, unrealizedPlpc: String, unrealizedPl: String, marketValue: String, qty: String, avgEntryPrice: String, changeToday: String, costBasis: Bool, exchange: String, open: String, high: String, low: String, volume: String) {
        self.assetId = assetId
        self.symbol = symbol
        self.unrealizedPlpc = unrealizedPlpc
        self.unrealizedPl = unrealizedPl
        self.marketValue = marketValue
        self.qty = qty
        self.avgEntryPrice = avgEntryPrice
        self.changeToday = changeToday
        self.costBasis = costBasis
        self.exchange = exchange
        self.open = open
        self.high = high
        self.low = low
        self.volume = volume
    }
}
