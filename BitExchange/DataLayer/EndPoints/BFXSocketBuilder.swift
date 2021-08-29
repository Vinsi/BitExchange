//
//  BTNetworkService.swift
//  BitExchange
//
//  Created by Vinsi on 28/08/2021.
//

struct BFXSocketBuilder: SocketBuildable {
    
    struct TickerRequestModel: Codable {
        
        enum Channel: String, Codable {
            case ticker
            case trades
        }
        enum Event: String, Codable {
            case subscribe
        }
        let event: Event
        let channel: Channel
        let symbol: String
    }
    var path: String {"ws/\(version.rawValue)"}
    var parameter: TickerRequestModel
    enum Version: String {
        case v1 = "1"
        case v2 = "2"
    }
    
    let version = Version.v2
    let baseURL: String = Configuration.value(for: .BITFINEX_BASE_PUB_URL)!
}
