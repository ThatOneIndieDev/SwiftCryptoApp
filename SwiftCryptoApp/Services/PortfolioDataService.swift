//
//  PortfolioDataService.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 29/01/2025.
//

import Foundation
import CoreData

class PortfolioDataService{
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    @Published var savedEntites: [PortfolioEntity] = [] // saving place for our core data.
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error{
                print("Error loading data: \(error)")
            }
        }
        self.getPortfolio()
    }
    
    // MARK: PUBLIC SECTION
    
    func updatePortfolio(coin: CoinModel, amount: Double){
        
        
        // Check if coin is already in portfolio
        if let entity = savedEntites.first(where: {$0.coinID == coin.id}){ // both this and the if let below will do the same job
            
            if amount > 0{
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
                }
            } else{
                add(coin: coin, amount: amount)
            
        }
        
//        if let entity = savedEntites.first(where: { (savedEntity) -> Bool in
//            return savedEntity.coinID == coin.id
//        }){
//            
//        }
    }

    
    
    // MARK: PRIVATE SECTION
    
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName) // the less than and the greater than sign tells us the exact data type of the data we will need to return.
        
        do {
            savedEntites = try container.viewContext.fetch(request)
        } catch let error {
            print("Error in fetching portfolio entities: \(error)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double){
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double){
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save(){
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error in saving Core Data: \(error)")
        }
    }
    
    private func applyChanges(){
        save()
        getPortfolio()
    }
    
}
