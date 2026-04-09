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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        let product = products[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = product.productName ?? "No Name"
        content.secondaryText = "ID: \(product.productID) | $\(String(format: "%.2f", product.productPrice)) | \(product.productProvider ?? "")"
        cell.contentConfiguration = content

        return cell
    }
}
