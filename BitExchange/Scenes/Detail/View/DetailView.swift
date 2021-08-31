//
//  DetailView.swift
//  BitExchange
//
//  Created by Vinsi on 28/08/2021.
//

import Foundation
import SwiftUI

struct DetailView: View {
    
    @State private var isShowing = false
    @StateObject var viewModel = DetailViewModel(bfxRepo: BFXSocketRepository())
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    let Items: [TradingPair]
    let selectedItem: TradingPair
    var item: TradingType? {
        self.viewModel.selectedItem?.getValue()
    }
   
    init(items: [TradingPair], selectedItem: TradingPair) {
        self.selectedItem = selectedItem
        self.Items = items
    }
    
    func getTradingPairsList() {
        viewModel.items = Items
        viewModel.selectedItem = selectedItem
        viewModel.getTradingPairsList()
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .failed(let error):
                ErrorView(error: error, handler: {viewModel.getTradingPairsList()})
            case .success(let items):
                NavigationView {
                    VStack {
                        HStack {
                            Button("Previous") {
                                if viewModel.movePrevious() {
                                    viewModel.getTradingPairsList()
                                }
                            }
                            Button("Next") {
                                if viewModel.moveNext() {
                                    viewModel.getTradingPairsList()
                                }
                            }
                        }
                        HStack {
                            BlockItemView(data: .init(title: "Bid Size", value: "\(item?.BID_SIZE ?? 0)", valueColor: item?.LAST_PRICE ?? 0 < 0 ? .red :.green)).frame(width: 100, height: 50, alignment: .leading)
                            BlockItemView(data: .init(title: "Last Price", value: "\(item?.LAST_PRICE ?? 0)", valueColor: item?.LAST_PRICE ?? 0 < 0 ? .red :.green)).frame(width: 100, height: 50, alignment: .leading)
                        }
                        HStack {
                            BlockItemView(data: .init(title: "Top BID", value: "\(item?.HIGH ?? 0)", valueColor: item?.HIGH ?? 0 < 0 ? .red :.green)).frame(width: 100, height: 50, alignment: .leading)
                            BlockItemView(data: .init(title: "Top ASK", value: "\(item?.ASK ?? 0)", valueColor: item?.ASK ?? 0 < 0 ? .red :.green)).frame(width: 100, height: 50, alignment: .leading)
                        }
                        ListHistoryView(data: .init(first: "Symbol", second: "change", third: "Date"))
                        List(items) { itemData in
                            
                            ListHistoryView(data: ListHistoryView.List(
                                first: item?.SYMBOL ?? "",
                                            second: "\(itemData.pair.getValue()?.DAILY_CHANGE ?? 0)",
                                third:"\(Date())",
                                secondColor: (itemData.pair.getValue()?.DAILY_CHANGE ?? 0) > 0 ? .green : .red
                            ))
                            
                        }
                    }
                }.navigationTitle("Details for \(item?.SYMBOL ?? "")").font(.title).navigationBarTitleDisplayMode(.inline)
            }
        }.onAppear {
            self.getTradingPairsList()
        }.onDisappear {
            self.viewModel.clean()
        }
    }
    
}

struct ListHistoryView: View {
    
    struct List {
        var first: String
        var second: String
        var third: String
        var secondColor: Color = .green
    }
    
    let data: List
    
    var body: some View {
        HStack {
            Text(data.first)
                .foregroundColor(.black)
                .font(.system(size: 18, weight: .semibold))
            Text(data.second)
                .foregroundColor(data.secondColor)
                .font(.footnote)
            Text(data.third)
                .foregroundColor(.gray)
                .font(.footnote)
        }
        
    }
}
