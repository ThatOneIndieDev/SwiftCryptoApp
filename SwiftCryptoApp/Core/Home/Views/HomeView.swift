//
//  HomeView.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 17/01/2025.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio: Bool = false
    @State private var showPortfolioView: Bool = false
    
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    @State private var showSettingsView: Bool = false
    
    var body: some View {
        ZStack(){
            //background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView()
                        .environmentObject(vm)
                })
            //content layer
            
            // You cannot have 2 sheets in one hiarchy so to add a sheet to the info button to go to the settings section we can add a sheet to the Vstack below since its on a different level than the Zstack above.
            
            VStack(){
                homeHeader
                
                HomeStatsView(vm: vm, showPortfolio: $showPortfolio)
                
                SearchBarView(searchText: $vm.searchText)
                
                coinHeadingCaptions
                
                if !showPortfolio{
                    allCoinsList
                    .transition(.move(edge: .leading))
                }
                
                if showPortfolio{
                    
                    ZStack(alignment: .top){
                        if vm.portfolio.isEmpty && vm.searchText.isEmpty{
                            portfolioEmptyText
                        } else{
                            portfolioCoinsList
                        }
                    }
                    
                    .transition(.move(edge: .trailing))
                }
                
                
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showSettingsView, content: {
                SettingsView().environmentObject(vm)
            })
        }
        .background(
            NavigationLink(destination: DetailLoadingView(coin: $selectedCoin), isActive: $showDetailView, label: {
                EmptyView()
            })
        )
    }
}

struct HomeView_Preview: PreviewProvider{
    static var previews: some View{
        NavigationView{
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
    }
}



extension HomeView{
    private var homeHeader: some View{
        HStack(){
            CircleButtonView(iconName: showPortfolio ? "plus":"info")
                .onTapGesture {
                    if showPortfolio{
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
                .background{
                    CircleButtonAnimationView(animate: $showPortfolio)
                }
                .animation(nil, value: showPortfolio)
            Spacer()
            Text(showPortfolio ? "Portfolio": "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(nil, value: showPortfolio)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180:0))
                .onTapGesture {
                withAnimation(.spring()){
                    showPortfolio.toggle() //Toggeling showProtfolio from False to true to rotate button
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View{
        List{
            ForEach(vm.allCoins){ coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                    .onTapGesture {
                        segue(coin: coin)
                    }
                    .listRowBackground(Color.theme.background) // added because the allCoinsList was using the default dark background and not our own black color.
            }
        }
        .listStyle(PlainListStyle())
        .refreshable {
            vm.reloadData()
        }

    }
    
    private var portfolioEmptyText: some View{
        Text("You haven't added any coins to your portfolio yet! Click the + item to get started.")
            .font(.callout)
            .foregroundColor(Color.theme.accent)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(50)
    }
    
    private var portfolioCoinsList: some View{
        List{
            ForEach(vm.portfolio){ coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())

    }
    
    private func segue(coin: CoinModel){
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var coinHeadingCaptions: some View{
        HStack{
            
            HStack(spacing: 4){
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0: 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            
            Spacer()
            
            HStack(spacing: 4){
                if showPortfolio{
                    Text("Headings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .hoildingsReversed) ? 1.0: 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
            }
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .holdings ? .hoildingsReversed : .holdings
                }
            }
            
            Spacer()
            
            HStack(spacing: 4){
                Text("Price")
                    .frame(width: UIScreen.main.bounds.width / 3.5 , alignment: .trailing)
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0: 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            
            Button( action: {
                withAnimation(.linear(duration: 2.0)) {
                    vm.reloadData()
                }

            }, label: {
                Image(systemName: "goforward")
            })
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)

        }
        .padding([.trailing,.leading])
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
    }

}
