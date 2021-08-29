//
//  BFXAPIBuilder.swift
//  BitExchange
//
//  Created by Vinsi on 26/08/2021.
//

import Foundation

struct BFXAPI: APIBuilder {

    var method: HttpMethod = .get
    var query: [String: String] {
        parameter.params
    }
    var version: Version = .v2
    var type: ResponseType = .json
    var parameter: Parameter
    let baseURL: String = Configuration.value(for: .BITFINEX_BASE_PUB_URL)!
    
    var path: String {
        switch parameter {
        case .tickers:
            return [
                     version.rawValue,
                     parameter.path
            ].joined(separator: "/")
        }
    }
}

// MARK:- Types
extension BFXAPI {
    
    enum Version: String {
        
        case v1
        case v2
    }
    
    enum Parameter {
        
        case tickers(symbols: [String])
        var path: String {
            "tickers"
        }
        
        var params: [String:String] {
            switch self {
            case .tickers(let symbols):
                return ["symbols": symbols.joined(separator: ",")]
            }
        }
    }
    
    enum ResponseType: String {
        case json
    }
}

