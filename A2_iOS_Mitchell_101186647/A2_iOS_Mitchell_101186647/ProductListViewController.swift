//
//  ProductListViewController.swift
//  A2_iOS_Mitchell_101186647
//
//  Created by Mitchell Stevenson  on 2026-04-09.
//

import Foundation
import UIKit
import CoreData

class ProductListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var context: NSManagedObjectContext!
    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchProducts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProducts()
    }

    func fetchProducts() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "productID", ascending: true)]

        do {
            products = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error fetching all products: \(error)")
        }
    }

    
}
