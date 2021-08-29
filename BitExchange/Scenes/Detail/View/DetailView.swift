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
                                VStack {
                                    Text("Ooops")
                                        .foregroundColor(.black)
                                        .font(.system(size: 30, weight: .heavy))
                                }
                            }
                        }
                        .padding(.all, 10)
                    }.navigationTitle("Bit exchange")
                }.navigationViewStyle(StackNavigationViewStyle())
            }
        }.onAppear {
            viewModel.getTradingPairsList()
        }
    }
}
 
