//
//  UIApplication.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 20/01/2025.
//

import SwiftUI
import Foundation

extension UIApplication{
    
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
