//
//  HapticManager.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 01/02/2025.
//

import Foundation
import SwiftUI

class HapticManager{
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notify(type: UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
    
    
}
