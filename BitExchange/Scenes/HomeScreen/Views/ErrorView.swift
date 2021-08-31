//
//  ErrorView.swift
//  NewsApp
//
//  Created by Vinsi on 01/08/2021.
//

import Foundation
import SwiftUI

struct ErrorView: View {
    
    typealias ErrorViewActionHandler = () -> Void
    
    let error: Error
    let handler: ErrorViewActionHandler
    
    init(error: Error, handler: @escaping ErrorView.ErrorViewActionHandler) {
        self.error = error
        self.handler = handler
    }
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.icloud.fill")
                .foregroundColor(.gray)
                .font(.system(size: 50, weight: .heavy))
            Text("Ooops")
                .foregroundColor(.black)
                .font(.system(size: 30, weight: .heavy))
            Button("Retry") {
                handler()
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: APIError.decodingError) {}
            .previewLayout(.sizeThatFits)
    }
}

struct BlockView: View {
    
    let tradingPair: TradingType?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4, content: {
                Text(tradingPair?.SYMBOL ?? "")
                    .foregroundColor(.black)
                    .font(.system(size: 14, weight: .semibold))
                Text("\(tradingPair?.LAST_PRICE ?? 0)")
                    .foregroundColor(.gray)
                    .font(.body)
                Text("\(tradingPair?.DAILY_CHANGE ?? 0)")
                    .foregroundColor(tradingPair?.DAILY_CHANGE ?? 0 < 0 ? .red : .green )
                    .font(.footnote)
                
            })
        }
    }
}


struct BlockItemView: View {
    
    struct Data {
        var title: String
        var value: String
        var valueColor: Color
    }
    let data: Data?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4, content: {
                Text(data?.title ?? "")
                    .foregroundColor(.black)
                    .font(.system(size: 14, weight: .semibold))
                Text(data?.value ?? "")
                    .foregroundColor(data!.valueColor)
                    .font(.footnote)
                
            })
        }
    }
}
