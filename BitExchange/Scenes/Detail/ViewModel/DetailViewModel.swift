//
//  DetailViewModel.swift
//  BitExchange
//
//  Created by Vinsi on 28/08/2021.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject, HomeViewModelType {
    
    private let bfxRepository: BFXSocketRepository
    private(set) var tradingPairs = [TickerChannelModel]()
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var state: ResultState<[TickerChannelModel]> = .loading
    
    init(bfxRepo: BFXSocketRepository) {
        self.bfxRepository = bfxRepo
    }
    
    func getTradingPairsList() {
        self.state = .loading
        self.tradingPairs.removeAll()
        let cancellable = bfxRepository.getAll()
            .sink { (res) in
                switch res {
                case .finished:
                    self.state = .success(content: self.tradingPairs)
                case .failure(let error):
                    self.state = .failed(error: error)
                }
            } receiveValue: { trading in
                if trading.count == 10 {
                 self.tradingPairs += [TickerChannelModel(value: trading)]
                }
            }
        self.cancellables.insert(cancellable)
    }
}

