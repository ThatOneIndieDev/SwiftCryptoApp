//
//  CoinDataService.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 18/01/2025.
//

// So in this file we will get data from the coin gecko API and then decode the data from the JSON decoder then finally we can append the data if it is valid or throw an error. The following file also uses the concept of a publisher and a subsciber using the Combine library.

// API key: CG-KAV5aBihV5bJJ65hmXEyTwRw

import Foundation
import Combine


class CoinDataService {
    
    func getAPIKey() -> String? {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) {
            return dict["CoinGeckoAPIKey"] as? String
        }
        return nil
    }
    
    
    @Published var allCoins: [CoinModel] = []
    var coinSubscription: AnyCancellable?

    init() {
        getCoins()
    }

    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=pkr&sparkline=true") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "x-cg-demo-api-key": getAPIKey() ?? ""
        ]


//        coinSubscription = URLSession.shared.dataTaskPublisher(for: request)
//            .subscribe(on: DispatchQueue.global(qos: .default))
//            .tryMap { (output) -> Data in
//                guard let response = output.response as? HTTPURLResponse,
//                      response.statusCode >= 200 && response.statusCode < 300 else {
//                    throw URLError(.badServerResponse)
//                }
//                return output.data
//            }
//            .receive(on: DispatchQueue.main)
        
        coinSubscription = NetworkingManager.download(url: request) //This line replaces the commented code above
        
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {
                [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            }
            ) // This piece of code replaces the lines of code below.
        
        
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print("Error fetching coins: \(error.localizedDescription)")
//                }
//            } receiveValue: { [weak self] returnedResponse in
//                self?.allCoins = returnedResponse
//                self?.coinSubscription?.cancel()
//            }
    }
}

