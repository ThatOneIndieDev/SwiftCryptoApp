//
//  NetworkingManager.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 20/01/2025.
//

// In this file we will make a class that will return us some resuable code to download data from the internet.

// This code can be used whenever we would like to download any data from the internet.

import Foundation
import Combine

class NetworkingManager{
    
    // The following enum contains the 2 types of errors our downloading of data can throw when we are trying to recieve it.
    enum NetworkingError: LocalizedError { // Conforming to LocalizedError is a protocol.
        case badURLResponse(url: URLRequest)
        case unknown
        
        var errorDescription: String?{
            switch self{ // Switch self refers to a switch on the items on the enum it self.
            case .badURLResponse(url: let url): return "Bad Response From URL: \(url)"
            case .unknown: return "Unknown Error Occoured"
            }
        }
    }
    
    static func download(url: URLRequest) -> AnyPublisher<Data, Error> {
        
        return URLSession.shared.dataTaskPublisher(for: url) // THIS URL SESSION WILL AUTOMATICALY SUBSCIBE TO THE BACKGROUND THREAD AUTOMATICALLY SO THE LINE BELOW CAN BE COMMENTED OUT.
//            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap ({ try handleURLResponse(output: $0, url: url)
//                guard let response = output.response as? HTTPURLResponse,
//                      response.statusCode >= 200 && response.statusCode < 300 else {
//                    throw URLError(.badServerResponse)
//                }
//                return output.data
                // The above code is replaced by the function that is names handleURLResponse.
            })
            //.receive(on: DispatchQueue.main) commented out as we are reciving each of the items coming separatly on background threads.
            .retry(3) // retry 3 times if the url response fails
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URLRequest) throws -> Data{
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>){
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print("Error fetching coins: \(error.localizedDescription)")
        }
    }
    
}
