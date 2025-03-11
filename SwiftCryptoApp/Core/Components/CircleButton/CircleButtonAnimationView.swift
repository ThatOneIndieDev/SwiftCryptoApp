//
//  CircleButtonAnimationView.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 17/01/2025.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    
    @Binding var animate: Bool //Making animate a binding variable so that we can have it connected to HomeView. NOTE: Binding variables cannot be private.
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? .easeOut(duration: 1.0) : nil, value: animate)
    }
}

#Preview {
    CircleButtonAnimationView(animate: .constant(false))
        .foregroundColor(.red)
        .frame(width: 100, height: 100)
}
