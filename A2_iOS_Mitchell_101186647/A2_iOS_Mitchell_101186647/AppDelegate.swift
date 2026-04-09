//
//  AppDelegate.swift
//  A2_iOS_Mitchell_101186647
//
//  Created by Mitchell Stevenson  on 2026-04-09.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        seedProducts()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        saveContext()
    }

    // MARK: Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "A2_iOS_Mitchell_101186647")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    // MARK: Seed products

    private func seedProducts() {

        let context = persistentContainer.viewContext
        let request: NSFetchRequest<Product> = Product.fetchRequest()

        do {
            let count = try context.count(for: request)

            if count == 0 {

                let sampleProducts: [(Int64,String,String,Double,String)] = [
                    (1,"Macbook","14-inch display",2499.99,"Apple"),
                    (2,"Desktop PC","Gaming PC",3499.99,"Acer"),
                    (3,"Keyboard","75% Gaming keyboard",69.99,"Corsair"),
                    (4,"Mouse","Ergonomic mouse for comfort",150.99,"Logitech"),
                    (5,"Monitor","27-inch display OLED",499.99,"Samsung"),
                    (6,"Laptop","17-inch display",300.00,"Lenovo"),
                    (7,"Chair","Ergonomic comfort chair",135.99,"Amazon"),
                    (8,"Desk","Large desk, 3 feet",149.99,"IKEA"),
                    (9,"Headphones","Balanced sound for great audio",499.99,"Bose"),
                    (10,"Socks","Comfort socks, 12 pack",39.99,"Adidas")
                ]

                for item in sampleProducts {
                    let product = Product(context: context)
                    product.productID = item.0
                    product.productName = item.1
                    product.productDescription = item.2
                    product.productPrice = item.3
                    product.productProvider = item.4
                }

                try context.save()
            }

        } catch {
            print("Error adding sample products: \(error)")
        }
    }
}
