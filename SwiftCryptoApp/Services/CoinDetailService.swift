//
//  CoinDetailService.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 01/02/2025.
//

import Foundation
import Combine


class CoinDetailService {
    
    func getAPIKey() -> String? {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) {
            return dict["CoinGeckoAPIKey"] as? String
        }
        return nil
    }
    
    @Published var coinDetails: CoinDetailModel? = nil
    var coinDetailSubscription: AnyCancellable?
    let coin: CoinModel

    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetails()
    }

    func getCoinDetails() {
        
        
        let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "localization", value: "false"),
          URLQueryItem(name: "tickers", value: "false"),
          URLQueryItem(name: "market_data", value: "false"),
          URLQueryItem(name: "community_data", value: "false"),
          URLQueryItem(name: "developer_data", value: "false"),
          URLQueryItem(name: "sparkline", value: "false"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "x-cg-demo-api-key": getAPIKey() ?? ""
        ]
        
        coinDetailSubscription = NetworkingManager.download(url: request)
        
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {
                [weak self] (returnedCoinDetails) in
                self?.coinDetails = returnedCoinDetails
                self?.coinDetailSubscription?.cancel()
            }
            )

    }
}
