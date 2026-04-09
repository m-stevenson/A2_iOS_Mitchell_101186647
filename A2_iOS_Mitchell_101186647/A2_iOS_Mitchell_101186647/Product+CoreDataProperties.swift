//
//  Product+CoreDataProperties.swift
//  A2_iOS_Mitchell_101186647
//
//  Created by Mitchell Stevenson  on 2026-04-09.
//
//

import Foundation
import CoreData

extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var productID: Int64
    @NSManaged public var productName: String?
    @NSManaged public var productDescription: String?
    @NSManaged public var productPrice: Double
    @NSManaged public var productProvider: String?
}

extension Product: Identifiable {

}
