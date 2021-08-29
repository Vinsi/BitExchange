//
//  APIBuilder.swift
//  NewsApp
//
//  Created by Vinsi on 03/08/2021.
//

import Foundation

enum HttpMethod: String {
    
    case get = "GET"
}

protocol APIBuilder {
    
    var urlRequest: URLRequest { get }
    var baseURL: String { get }
    var path: String { get }
    var query: [String: String] { get }
    var method: HttpMethod { get }
}

extension APIBuilder {
    
    var urlRequest: URLRequest {
        let param = queryString
        let url = "https://\(baseURL)/\(path)?\(param)"
        var request = URLRequest(url:  URL(string: url)!)
        request.httpMethod = method.rawValue
        return request
    }
    
    var queryString: String {
        query.reduce("", {
            "\($0)&\($1.key)=\($1.value)"
        })
    }
}
