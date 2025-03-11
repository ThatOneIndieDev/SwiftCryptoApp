//
//  CoinImageService.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 20/01/2025.
//

import Foundation
import Combine
import SwiftUI


class CoinImageService {
    
    func getAPIKey() -> String? {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) {
            return dict["CoinGeckoAPIKey"] as? String
        }
        return nil
    }
    
    @Published var image: UIImage? = nil
    var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_imager"
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName){
            image = savedImage
            print("Retrived Image from File Manager.")
        } else{
            donwloadCoinImage()
            print("Downloading image now.")
        }
    }
    
    private func donwloadCoinImage(){
        
        guard let url = URL(string: coin.image) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "x-cg-demo-api-key": getAPIKey() ?? ""
        ]

        imageSubscription = NetworkingManager.download(url: request)
        
            
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {
                [weak self] (returnedImage) in
                guard let self = self, let downloadedImage = returnedImage else {return} // made so that the self is no longer optional.
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            }
            )
        
        
    }
    
}
