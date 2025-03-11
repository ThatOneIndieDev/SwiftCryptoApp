//
//  StatisticModel.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 27/01/2025.
//

import Foundation
import SwiftUI


struct StatisticModel: Identifiable { // Conformed to identifiable so that we can use the model inside a forEach loop.
    
    let id = UUID().uuidString // Creates a random id and assigns it to ever instance of the model.
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) { // setting nil by default in the init
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
    
}
