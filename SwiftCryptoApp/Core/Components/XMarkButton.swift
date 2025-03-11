//
//  XMarkButton.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 29/01/2025.
//

import SwiftUI

struct XMarkButton: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {presentationMode.wrappedValue.dismiss()},
               label: {Image(systemName: "xmark")
                .font(.headline)})

    }
}

struct XMarkButtonView_Previews: PreviewProvider{
    static var previews: some View{
        XMarkButton()
    }
}
