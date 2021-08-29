//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Vinsi on 01/08/2021.
//

import Foundation
import Combine

protocol HomeViewModelType {
    func getTradingPairsList()
}

final class HomeViewModel: ObservableObject, HomeViewModelType {
    
    private let bfxRepository: BFXListRepository
    private(set) var tradingPairs = [TradingPair]()
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var state: ResultState<[TradingPair]> = .loading
    
    init(bfxRepo: BFXListRepository) {
        self.bfxRepository = bfxRepo
    }
    
    func getTradingPairsList() {
        self.state = .loading
        let cancellable = bfxRepository.getAll()
            .sink { (res) in
                switch res {
                case .finished:
                    self.state = .success(content: self.tradingPairs)
                case .failure(let error):
                    self.state = .failed(error: error)
                }
            } receiveValue: { trading in
                self.tradingPairs = trading
            }
        self.cancellables.insert(cancellable)
    }
}
