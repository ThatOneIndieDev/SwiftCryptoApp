//
//  SearchBarView.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 20/01/2025.
//

import SwiftUI

struct SearchBarView: View {
    
    
    @Binding var searchText: String
    
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ?  Color.theme.secondaryText : Color.theme.accent

                )
                .padding(.leading)
            
            TextField("Seatch by name or symbol...", text: $searchText)
                .foregroundColor(Color.theme.accent)
                .disableAutocorrection(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.theme.accent)
                        .padding() // Added padding to incease tapable area for the button.
                        .offset(x: 10)
                        .opacity(searchText.isEmpty ? 0.0: 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        },
                    alignment: .trailing
                )
        }
                .font(.headline)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.theme.background)
                        .shadow(
                            color: Color.theme.accent.opacity(0.15),
                            radius: 10, x: 0, y: 0)
                )
                .padding()
        }
}

struct SearchBarView_Preview: PreviewProvider{
    static var previews: some View{
        SearchBarView(searchText: .constant(""))
    }
}
