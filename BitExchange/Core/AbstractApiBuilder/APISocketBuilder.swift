//
//  APISocketBuilder.swift
//  BitExchange
//
//  Created by Vinsi on 28/08/2021.
//

import Foundation

protocol SocketBuildable {
    
    associatedtype PType: Codable
    var baseURL: String { get }
    var path: String { get }
    var parameter: PType { get}
}

extension SocketBuildable {
    
    var urlString: String {
        "wss://\(baseURL)/\(path)"
    }
    
    func urlRequest()-> URLRequest {
        URLRequest(url: URL(string: urlString)!)
    }
}

extension Encodable {
    
    var toJsonString: String {
        let jsonData = try! JSONEncoder().encode(self)
        return String(data: jsonData, encoding: .utf8)!
    }
}
