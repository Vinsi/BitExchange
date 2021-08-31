//
//  BFXListRepository.swift
//  BitExchange
//
//  Created by Vinsi on 27/08/2021.
//

import Foundation
import Combine

struct BFXListRepository: RepositoryType {

   let bfxService: BFXServiceImpl
   func getAll() -> AnyPublisher<[TradingPair], RepoError> {
    bfxService.request(from: .init(parameter: .tickers(symbols: ["ALL"]))).compactMap({$0.toTickerPair}).mapError({RepoError.serverError(ApiError: $0)}).eraseToAnyPublisher()
   }
}

struct BFXSocketRepository: RepositoryType {

    let bfxSocketService = BFXSocketServiceManager.sharedInstance()
    
    func getAll() -> AnyPublisher<[Any], RepoError> {
        bfxSocketService.start(with: BFXSocketBuilder(parameter: .init(event: .subscribe, channel: .ticker, symbol: "tBTCUSD"))).mapError({RepoError.serverError(ApiError:$0)}).eraseToAnyPublisher()
    }
    
    func start(symbol: String, onRecieveData:@escaping([Any], RepoError?) ->()) {
        bfxSocketService.start(with: BFXSocketBuilder(parameter: .init(event: .subscribe, channel: .ticker, symbol: symbol))) { (data, error) in
            guard let error = error else {
                onRecieveData(data, nil)
                return
            }
            onRecieveData(data,RepoError.serverError(ApiError: error))
        }
    }
}

