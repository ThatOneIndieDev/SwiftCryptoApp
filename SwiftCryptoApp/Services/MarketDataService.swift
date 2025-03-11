//
//  MarketDataService.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 29/01/2025.
//

import Foundation
import Combine

class MarketDataService{
    
    func getAPIKey() -> String? {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) {
            return dict["CoinGeckoAPIKey"] as? String
        }
        return nil
    }
    
    @Published var marketData: MarketDataModel? = nil
    var marketDataSubscription: AnyCancellable?

    init() {
        getMarketData()
    }

    func getMarketData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "x-cg-demo-api-key": getAPIKey() ?? ""
        ]
        
        marketDataSubscription = NetworkingManager.download(url: request)
        
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {
                [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
    }
}

