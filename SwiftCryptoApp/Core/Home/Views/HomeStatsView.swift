//
//  HomeStatsView.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 27/01/2025.
//

import SwiftUI

struct HomeStatsView: View {
    
    @ObservedObject var vm : HomeViewModel
    
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack{
            ForEach(vm.statistics){ stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width,
               alignment: showPortfolio ? .trailing : .leading
        )
    }
}

struct HomeStatsView_Preview: PreviewProvider{
    static var previews: some View{
        HomeStatsView(vm: dev.homeVM, showPortfolio: .constant(false))
    }
}
