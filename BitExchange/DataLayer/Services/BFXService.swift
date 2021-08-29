//
//  BFXService.swift
//  BitExchange
//
//  Created by Vinsi on 26/08/2021.
//
import Combine
import Foundation

struct BFXServiceImpl: Service {
    
    func request(from endpoint: BFXAPI) -> AnyPublisher<[Any], APIError> {
        requestForJsonObject(from: endpoint)
    }
}
