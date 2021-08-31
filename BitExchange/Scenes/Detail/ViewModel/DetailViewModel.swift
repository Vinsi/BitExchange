//
//  DetailViewModel.swift
//  BitExchange
//
//  Created by Vinsi on 28/08/2021.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    
    private let bfxRepository: BFXSocketRepository
    private(set) var tradingPairs = [TickerChannelModel]()
    private var cancellables = Set<AnyCancellable>()
    var items: [TradingPair] = []
    var selectedItem: TradingPair?
    @Published private(set) var state: ResultState<[TickerChannelModel]> = .loading
    
    init(bfxRepo: BFXSocketRepository) {
        self.bfxRepository = bfxRepo
    }
    
    func moveNext() -> Bool {
        
        if let index = items.firstIndex(where: { $0.id == self.selectedItem!.id  }),
           index < (items.count - 1)  {
            let i = index + 1
            self.selectedItem = items[i]
            return true
        }
        return false
    }
    
    func movePrevious() -> Bool {
        
        if let index = items.firstIndex(where: { $0.id == self.selectedItem!.id  }),
           index > 0 {
            let i = index - 1
            self.selectedItem = items[i]
            return true
        }
        return false
    }
    
    func clean() {
        bfxRepository.bfxSocketService.socket?.disconnect()
    }
    
    func getTradingPairsList() {
        self.state = .loading
        self.tradingPairs.removeAll()
        bfxRepository.bfxSocketService.socket?.disconnect()
        bfxRepository.start(symbol: selectedItem?.getValue()?.SYMBOL ?? "tBTCUSD", onRecieveData: { [weak self](res, error) in
            guard let self = self else {
                return
            }
            guard let error = error else {
                if res.count == 10 {
                 self.tradingPairs += [TickerChannelModel(value: res)]
                 self.state = .success(content: self.tradingPairs)
                }
                return
            }
            self.state = .failed(error: error)
            })
    }
}

