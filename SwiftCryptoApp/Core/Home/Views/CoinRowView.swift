//
//  CoinRowView.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 17/01/2025.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHoldingsColumn: Bool
    
    var body: some View {
        row
    }
}

struct CoinRowView_Preview: PreviewProvider{
    static var previews: some View{
        Group{
            CoinRowView(coin: dev.coin, showHoldingsColumn: true) // dev.coin works becase of the fact that we made an extention for the coin model in our extentions folder. So we don't have to refrence the entire coin again and again.
            CoinRowView(coin: dev.coin, showHoldingsColumn: true)
                .preferredColorScheme(.dark)
            
        }
    }
}

extension CoinRowView{
    private var row: some View{
        HStack(spacing: 0){
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading,6)
                .foregroundColor(Color.theme.accent)
            Spacer()
            (showHoldingsColumn ?
             VStack(alignment: .trailing){
                Text((coin.currentHoldingsValue.asCurrencyWith6Decimals()))
                    .bold()
                    .foregroundColor(Color.theme.accent)
                Text("\(coin.currentHoldings?.asNumberString() ?? "")")
                    .foregroundColor(Color.theme.secondaryText)
            }: nil)
            Spacer()
            VStack(alignment: .trailing){
                Text(coin.currentPrice.asCurrencyWith6Decimals())
                    .bold()
                    .foregroundColor(Color.theme.accent)
                Text("\(coin.priceChangePercentage24H?.asPrecentString() ?? "0.0")")
                    .foregroundColor(
                        (coin.priceChangePercentage24H!) >= 0.0 ? Color.theme.green : Color.theme.red
                    )
            }
        }
        .font(.subheadline)
        .padding(.trailing)
        .background(
            Color.theme.background.opacity(0.001)
        )
    }
}
