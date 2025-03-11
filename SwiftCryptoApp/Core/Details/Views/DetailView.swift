//
//  DetailView.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 01/02/2025.
//

import SwiftUI

struct DetailLoadingView: View{
    
    @Binding var coin: CoinModel?
    
    var body: some View {
        if let coin = coin{
            DetailView(coin: coin)
        }
    }
}
    
struct DetailView: View {
    
    @StateObject var vm: DetailViewModel
    @State var showFullDescription: Bool = false
    private let colums: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView{
            coinDetailBody
        }
        .navigationTitle(vm.coin.name)
        .padding(.leading)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingItems
            }
        }
    }
}
        
struct DetailView_Previews: PreviewProvider{
    static var previews: some View{
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}

extension DetailView{
    
    private var navigationBarTrailingItems: some View{
        HStack{
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var overviewTtile: some View{
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewColumns: some View{
        LazyVGrid(
            columns: colums,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(vm.additionalStatistics){ stat in
                    StatisticView(stat: stat)
                }
            }
    }
    
    private var additionalTitle: some View{
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalColumns: some View{
        LazyVGrid(
            columns: colums,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(vm.additionalStatistics){ stat in
                    StatisticView(stat: stat)
                }
            }
    }
    
    private var coinDetailBody :some View{
        
        VStack{
            ChartView(coin: vm.coin).padding(.vertical)
            VStack(spacing: 20){
                overviewTtile
                Divider()
                
                coinDescription
                
                overviewColumns
                
                additionalTitle
                Divider()
                additionalColumns
                
                websiteSections
            }
        }
    }
    
    private var coinDescription: some View{
        ZStack{
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading){
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Button( action:{
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    }, label: {
                        Text(showFullDescription ? "Less" : "Read More...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }).accentColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var websiteSections: some View{
        VStack(alignment: .leading, spacing: 20) {
            if let websiteString = vm.websiteURL,
               let url = URL(string: websiteString){
                Link("Website", destination: url)
            }
            
            if let redditString = vm.redditURL,
               let url = URL(string: redditString){
                Link("Reddit", destination: url)
            }
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
    
}
