//
//  LaunchView.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 05/02/2025.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var loadingText: [String] = "Loading your portfolio...".map{String($0)} // What this map function does is that it maps the string into an array of string so that we can animate each letter.
    @State private var showLoadingText: Bool = false
    
    @State private var counter: Int = 0
    
    @State private var loops: Int = 0
    
    @Binding var showLaunchView: Bool
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        ZStack{
            Color.launchTheme.background
                .ignoresSafeArea()
            
            Image("logo-transparent")
                .resizable()
                .frame(width: 100, height: 100) // We are setting this picture right in the middle so that when we transition from the launch screen to this launch View.
            
            ZStack{
                if showLoadingText{
                    HStack(spacing: 0){
                        ForEach(loadingText.indices){ index in
                            Text(loadingText[index])
                                .font(.headline)
                                .foregroundColor(Color.launchTheme.accent)
                                .offset(y: counter == index ? -5: 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
            }
            .offset(y: 70)

        }
        .onAppear{
            showLoadingText.toggle()
        }
        .onReceive(timer , perform: { _ in
            withAnimation(.spring()){
                
                let lastIndex = loadingText.count - 1
                if counter == lastIndex{
                    counter = 0
                    loops += 1
                    
                    if loops >= 3{
                        showLaunchView = false
                    }
                    
                } else {
                    counter += 1
                }
            
            }
        })
    }
}

struct LaunchView_Preview: PreviewProvider{
    static var previews: some View{
        LaunchView(showLaunchView: .constant(true))
    }
}
