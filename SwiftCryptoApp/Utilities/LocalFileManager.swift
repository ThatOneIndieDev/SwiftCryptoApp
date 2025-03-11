//
//  LocalFileManager.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 20/01/2025.
//

// In this file we are saving and getting our images from the file manager so that when our app loads up everytime it does not gvae to download and load  the images everytime we view them.

import Foundation
import SwiftUI


class LocalFileManager{
    
    static let instance = LocalFileManager()
    
    init(){ }
    
    
    // This function saves the images.
    func saveImage(image: UIImage, imageName: String, folderName: String){
        
        // Create Folder.
        createFolderIfNeeded(folderName: folderName)
        
        // get image path.
        guard let data = image.pngData(),
        let url  = URL(string: "")
        else {return}
        
        // save image to path.
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image. \(error)")
        }
        
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getURLFromImage(imageName: imageName, folderName: folderName),
        FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
        
    }
    
    // The following function creates the folder before the app can save anything in it.
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error in creating directory: \(error)")
            }
        }
    }
    
    // The following function will return what folder to save the images to.
    private func getURLForFolder(folderName: String) -> URL?{
        
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {return nil} // Saving our images in the cashesdirectory.
        return url.appendingPathComponent(folderName)
    }
    
    // Saving images (#more).
    private func getURLFromImage(imageName: String, folderName: String) -> URL?{
        guard let folderURL = getURLForFolder(folderName: folderName) else {return nil}
        return folderURL.appendingPathComponent(imageName + ".png")
    }
    
    
}
