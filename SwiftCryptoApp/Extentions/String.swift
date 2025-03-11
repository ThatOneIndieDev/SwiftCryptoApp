//
//  String.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 05/02/2025.
//

import Foundation

extension String {
    
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
