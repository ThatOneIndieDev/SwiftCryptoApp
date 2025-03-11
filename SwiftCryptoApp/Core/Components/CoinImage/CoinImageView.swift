//
//  CoinImageView.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 20/01/2025.
//

import SwiftUI


struct CoinImageView: View {
    
    @StateObject var vm: coinImageViewModel
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: coinImageViewModel(coin: coin)) // Using an underscore to refrence the stateObject of coinImageViewModel
    }
    
    var body: some View {
        ZStack{
            if let image = vm.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if vm.isLoading{
                ProgressView()
            } else{
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

struct CoinImageView_Previews: PreviewProvider{
    static var previews: some View{
        CoinImageView(coin: dev.coin)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
