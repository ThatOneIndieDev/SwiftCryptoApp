//
//  SettingsView.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 05/02/2025.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultURL = URL(string: "https://www.google.com")!
    let myspaceURL = URL(string: "https://www.myspace.com")!
    let writingURL = URL(string: "https://publicate2.wordpress.com/")!
    let coingeckoURL = URL(string: "https://www.coingecko.com")!
    let personalURL = URL(string: "https://www.github.com")!
    
    
    var body: some View {
        NavigationView {
            List{
                lèMe
                swiftfulThinking
                coingeckoSection
                application
            }
            .font(.headline)
            .accentColor(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
            }
        }
        .background(
            Color.theme.background
                .ignoresSafeArea()
        )
    }
}

struct SettingsView_Preview: PreviewProvider{
    static var previews: some View{
        SettingsView()
    }
}

extension SettingsView{
    
    private var lèMe : some View{
        Section(header: Text("Syed Abrar Shah")) {
            VStack(alignment: .leading){
                Image("Me") //MARK: ADD YOUR OWN IMAGE
                    .resizable()
                    .frame(height: 500)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("Hi I'm Abrar Shah: an up and coming app developer, AI engineer, physics enthusiast and writer. For more about me check out my github page and website!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            Link("My Github", destination: personalURL)
            Link("My personal writer's website",destination: writingURL)
        }
    }
    
    
    private var swiftfulThinking : some View{
        Section(header: Text("Swiftful Thinking")) {
            VStack(alignment: .leading){
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by following an online toutorial by the channel swiftful thinking. It uses the MVVM Architecture, Combine and CoreData. Additionally this app enifits from multi-threading, publishers/subscribers and data persistace. An AI sectioin using tensorflow and python is soon to come.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Swiftful Thinking", destination: defaultURL)
        }
    }
    
    private var coingeckoSection : some View{
        Section(header: Text("CoinGecko")) {
            VStack(alignment: .leading){
                Image("coingecko")
                    .resizable()
                    .frame(height: 100)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("CoinGecko offers a free API for cryptocurrency data. I used it in my iOS app to fetch real-time crypto prices and stats.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            Link("CoinGecko", destination: coingeckoURL)
        }
    }

    private var application : some View{
        Section(header: Text("CoinGecko")) {
            Link("Terms of Service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("Company Website", destination: defaultURL)
            Link("Learn More", destination: defaultURL)
        }
    }
    
}
