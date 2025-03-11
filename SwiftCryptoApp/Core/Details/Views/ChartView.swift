//
//  ChartView.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 02/02/2025.
//
import Foundation
import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green: Color.theme.red
        
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60) // SparkLineIn7D meaning 7Days before our ending date.
    }
    
    var body: some View {
        
        VStack{
            geometryReader
                .frame(height: 200)
                .background(chartBackground)
                .overlay(chartLabels.padding(.horizontal, 4), alignment: .leading)
            
            chartDateLabels.padding(.horizontal, 4)
            }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                withAnimation(.linear(duration: 2.0)){
                    percentage = 1.0
                }
            }
        }
        }
    }

// THE xPos creates the x positions of the chart on the screen. SO basically if we had a screen of 300 points and 100 items in our data array so if we divided 300 by 100 we would have an xPos of 3 additional points. Then we take this and multiply it by the index + 1 since the index is starting from 0. So it would go like 1 * 3 = 3, 2 * 3 = 6, 3 * 3 = 9 and to the end which will be 3 * 100  = 300.

// In Xcode our data axes are reversed so even when we initially set up the graph we can see that on th data in the dev.coin the rpice should go  up but it goes down. This is again because (0,0) is at the top left. So we can do -1 in the yPos to reverse the chart.


struct ChartView_Previews: PreviewProvider{
    static var previews: some View{
        ChartView(coin: dev.coin)
    }
}

extension ChartView{
    
    
    private var geometryReader: some View{
        
        GeometryReader { geometry in // Added in so that our chart can be dynamic
            Path{ path in
                for index in data.indices{
                    let xPos = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY // setting Y axis
                    
                    let yPos = (1 - CGFloat((data[index] - minY)) / yAxis) * geometry.size.height
                    
                    if index  == 0{
                        path.move(to: CGPoint(x: xPos, y: yPos))
                    }
                    path.addLine(to: CGPoint(x: xPos, y: yPos))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0.0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0.0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0.0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0.0, y: 40)
        }
        
    }
    
    private var chartBackground: some View{
        VStack{
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartLabels: some View{
        VStack{
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            let price  = (maxY - minY) / 2
            Text("\(price.formattedWithAbbreviations())")
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var chartDateLabels: some View{
        HStack{
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
            }
    }
    
}
