//
//  HomeViewModel.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 18/01/2025.
//

import Foundation
import Combine


class HomeViewModel: ObservableObject{ // Conforming to ObservableObject so that we can view it from our HomeView.
    
    
    @Published var statistics: [StatisticModel] = []
    
    @Published var allCoins: [CoinModel] = [] // creating published  vars so that changes can talk with the observableObject protocol.
        // The following array of allCoins will subscibe to our publisher in CoinDataService.
    
    @Published var portfolio: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    @Published var isLoading: Bool = false
    
    @Published var sortOption: SortOption = .holdings
    
    private let coindataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
    case rank, rankReversed, holdings, hoildingsReversed, price, priceReversed
    }
    
    init() {
        addSubscibers()
    }
    
    func addSubscibers(){
//        coindataService.$allCoins
//            .sink { [weak self](returnedCoins) in
//                self?.allCoins = returnedCoins
//            }//The $ before the all Coins is refrencing the publisher allCoins in the CoinDataService.
//            .store(in: &cancellables)
        
        // THE ABOVE CODE IS COMMENTED DUE TO THE FACT THAT THE PUBLISHER BELOW FULFILS BOTH THE OPERATIONS IN A SINGLE SUBSCRIBER
        
        $searchText
            .combineLatest(coindataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // Going to wait for 0.5 seconds after stop texting to filter.
            .map(filterAndSortCoins)
//            .map { (text,startingCoins) -> [CoinModel] in // Mapping th data we will get from the search result in a string and an array that will contain all the coins
//                guard !text.isEmpty else {
//                    return startingCoins // If searchbar is empty return all the coins
//                }
//                
//                let lowerCaseText = text.lowercased() // case sensitive search
//                
//                return startingCoins.filter { (coin) -> Bool in // Trying to see if the symbol, name or id is in the searchbar.
//                    return coin.name.lowercased().contains(lowerCaseText) ||
//                        coin.symbol.lowercased().contains(lowerCaseText) ||
//                        coin.id.lowercased().contains(lowerCaseText)
//                }
            //}
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // update portfolio
        $allCoins // We will take the filtered array of coinModels so that once we start typing the display coins will also be filtered.
        // WE ALSO WANT TO UPDATE ALL COINS AND SORT THEM BUT WE CANNOT WITH $sortOption SINCE THAT WILL CAUSE THIS FUNCTION TO RUN TWICE AND WEHEN UPDATING ONLY allCoins AND NOT EVEN portfolio
            .combineLatest(portfolioDataService.$savedEntites) // We are combining 2 subscibers here (the filtered allCoins array and the portfolio)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.portfolio = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        // Updates Market Data
        marketDataService.$marketData
            .combineLatest($portfolio)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)


        
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    
    // FUNCTION THAT WILL HELP OUR RELOADING OF DATA IN OUR HOMEVIEW TOP TRAILING BUTTON
    func reloadData(){
        isLoading = true
        coindataService.getCoins()
        marketDataService.getMarketData()
        HapticManager.notify(type: .success) // THE TYPE .success MEANS THAT RELOADING THE DATA WAS A SUCCESS
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) ->[CoinModel]{
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]){ // Since we were taking a CoinModel array and returning a new coin model array what we can do is use the inout operation that makes our function more efficeint. Now we sort th array in place as it is passed an never return anything.
        switch sort {
        case .rank, .holdings:
             coins.sort { coin1, coin2 in // THIS FUNCTION WILL SORT THE CPOINS WHILE COMPARING THEM AND RETURN A SORTED COIN LIST THAT WILL BE BASED ON OUR CONDITIONS.
                 coin1.rank < coin2.rank
            }
            
        case .rankReversed, .hoildingsReversed:
             coins.sort { coin1, coin2 in //
                 coin1.rank > coin2.rank
            }
            
        case .price:
             coins.sort { coin1, coin2 in //
                 coin1.currentPrice > coin2.currentPrice
            }
            
        case .priceReversed:
             coins.sort { coin1, coin2 in //
                 coin1.currentPrice < coin2.currentPrice
            }
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel]{
        // will only sort by holdings or reveredHoldings if needed
        
        switch sortOption {
        case .holdings:
            return coins.sorted { coin1, coin2 in
                return coin1.currentHoldingsValue > coin2.currentHoldingsValue
            }
        case .hoildingsReversed:
            return coins.sorted { coin1, coin2 in
                return coin1.currentHoldingsValue < coin2.currentHoldingsValue
            }
        default:
            return coins
        }
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel]{
        guard !text.isEmpty else {
            return coins // If searchbar is empty return all the coins
        }
        
        let lowerCaseText = text.lowercased() // case sensitive search
        
        return coins.filter { (coin) -> Bool in // Trying to see if the symbol, name or id is in the searchbar.
            return coin.name.lowercased().contains(lowerCaseText) ||
                coin.symbol.lowercased().contains(lowerCaseText) ||
                coin.id.lowercased().contains(lowerCaseText)
        }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        
        guard let data = marketDataModel else{
            return stats
        }
        
        let marketCap = StatisticModel(title: "MarketCap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24h Volume", value: data.volume)

        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
                
        let portfolioValue = portfolioCoins.map({ $0.currentHoldingsValue}).reduce(0, +) // The reduce function sums up the double array that the map would have returned us without the reduce function.
        
        let previousValue = portfolioCoins
            .map{(coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)
        
        let precentageChange = ((portfolioValue - previousValue) / previousValue)
        
        let portfolio = StatisticModel(title: "Portfolio Change", value: portfolioValue.asCurrencyWith6Decimals(), percentageChange: precentageChange)

        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        
        allCoins
            .compactMap { (coin) -> CoinModel? in // Using compact map so that we can only search for the coins that are in our portfolioEntities and any other coins can be set to nil.
                guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id}) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
        
    }
    
}
