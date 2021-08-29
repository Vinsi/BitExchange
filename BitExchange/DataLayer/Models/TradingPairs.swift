//
//  TradingPairs.swift
//  BitExchange
//
//  Created by Vinsi on 26/08/2021.
//

import Foundation

extension Optional where Wrapped == String {
    
    var toNonNullString: String {
        self ?? ""
    }
    
}

protocol TradingType {
    
    var SYMBOL: String? { get }
    var BID: Float? { get }
    var BID_SIZE: Double? { get }
    var ASK: Float? { get }
    var ASK_SIZE: Double? { get }
    var DAILY_CHANGE: Float? { get }
    var DAILY_CHANGE_RELATIVE: Double? { get }
    var LAST_PRICE: Double? { get }
    var VOLUME: Double? { get }
    var HIGH: Double? { get }
    var LOW: Double? { get }

}
struct Trading: TradingType {
    var ASK_SIZE: Double?
    
    var DAILY_CHANGE_RELATIVE: Double?
    
    var LAST_PRICE: Double?
    
    var VOLUME: Double?
    
    var HIGH: Double?
    
    var LOW: Double?
    
    var BID_SIZE: Double?
    
    var SYMBOL: String?
    
    var BID: Float?
    
    var ASK: Float?
    
    var DAILY_CHANGE: Float?
    
    
    init(value: [Any]) {
        SYMBOL = value[0] as? String
        BID = value[1] as? Float
        BID_SIZE = value[2] as? Double
        ASK = value[3] as? Float
        ASK_SIZE = value[4] as? Double
        DAILY_CHANGE = value[5] as? Float
        DAILY_CHANGE_RELATIVE = value[6] as? Double
        LAST_PRICE = value[7] as? Double
        VOLUME = value[8] as? Double
        HIGH = value[9] as? Double
        LOW = value[10] as? Double
    }
}

struct Funding: TradingType {
    var BID_SIZE: Double?
    
    var ASK_SIZE: Double?
    
    var DAILY_CHANGE_RELATIVE: Double?
    
    var LAST_PRICE: Double?
    
    var VOLUME: Double?
    
    var HIGH: Double?
    
    var LOW: Double?
    
    
    let SYMBOL: String?
    let FRR: Float?
    let BID: Float?
    let BID_PERIOD: Float?
    let ASK: Float?
    let ASK_PERIOD: Float?
    let DAILY_CHANGE: Float?
    let _PLACEHOLDER1: Float?
    let _PLACEHOLDER2: Float?
    let FRR_AMOUNT_AVAILABLE: Float?
    
    init(value: [Any]) {
        SYMBOL = value[0] as? String
        FRR = value[1] as? Float
           BID = value[2] as? Float
           BID_PERIOD = value[3] as? Float
           BID_SIZE = value[4] as? Double
           ASK = value[5] as? Float
           ASK_PERIOD = value[6] as? Float
           ASK_SIZE = value[7] as? Double
           DAILY_CHANGE = value[8] as? Float
           DAILY_CHANGE_RELATIVE = value[9] as? Double
           LAST_PRICE = value[10] as? Double
           VOLUME = value[11] as? Double
           HIGH = value[12] as? Double
           LOW = value[13] as? Double
           _PLACEHOLDER1 = value[14] as? Float
           _PLACEHOLDER2 = value[15] as? Float
           FRR_AMOUNT_AVAILABLE = value[16] as? Float
    }
}

struct TickerChannelModel: Identifiable {
    
    var id: UUID { pair.id }
    let pair: TradingPair
    init(value: [Any]) {
//        BID,
//         BID_SIZE,
//         ASK,
//         ASK_SIZE,
//         DAILY_CHANGE,
//         DAILY_CHANGE_RELATIVE,
//         LAST_PRICE,
//         VOLUME,
//         HIGH,
//         LOW
       
        if value.count == 10 {
            pair = TradingPair(trading:  Trading(value: [] + value))
        } else if value.count > 10 {
            pair = TradingPair(funding:  Funding(value: [] + value))
        } else {
            pair = TradingPair()
        }
    }
}

protocol Convertible {}

extension Optional where Wrapped == Double {
    var ifNullThenZero: Double {
        return self ?? 0
    }
}

extension Array where Element == Any {
    
    var toTickerPair:  [TradingPair] {
        
        compactMap {
            guard let item = $0 as? [Any] else {
                return nil
            }
            if item.count == 11 {
                return TradingPair(trading: Trading(value: item))
            } else if item.count > 11 {
                return TradingPair(funding: Funding(value: item))
            } else {
                return nil
            }
        }
    }
}

struct TradingPair: Identifiable {
    
    var funding: Funding?
    var trading: Trading?
    
    func getValue() -> TradingType? {
        trading ?? funding
    }
    var id = UUID()
}
