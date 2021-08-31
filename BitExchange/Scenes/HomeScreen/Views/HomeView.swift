//
//  HomeView.swift
//  BitExchange
//
//  Created by Vinsi on 27/08/2021.
//

import SwiftUI

struct HomeView: View {
    
    @State private var isShowing = false
    @Environment(\.openURL) var openURL
    @StateObject var viewModel = HomeViewModel(bfxRepo: BFXListRepository(bfxService: BFXServiceImpl()))
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .failed(let error):
                ErrorView(error: error, handler: viewModel.getTradingPairsList)
            case .success(let items):
                NavigationView {
                    ScrollView {
                        LazyVGrid(columns: gridItemLayout, alignment: .center, spacing: 10) {
                            ForEach(items) { item in
                                NavigationLink(destination: DetailView(items: viewModel.tradingPairs, selectedItem: item)) {
                                    BlockView(tradingPair: item.getValue()).frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .leading)
                                }
                            }
                        }
                        .padding(.all, 10)
                    }
                    
                    // .navigationTitle("Bit exchange")
                }.navigationTitle("Bit ExChange").font(.title)
                 .navigationBarTitleDisplayMode(.inline)
            }
        }.onAppear {
            viewModel.getTradingPairsList()
        }
    }
}
