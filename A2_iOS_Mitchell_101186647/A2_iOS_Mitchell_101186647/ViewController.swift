//
//  ViewController.swift
//  A2_iOS_Mitchell_101186647
//
//  Created by Mitchell Stevenson  on 2026-04-09.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!

    var products: [Product] = []
    var currentIndex: Int = 0

    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProducts()
        displayCurrentProduct()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProducts()
        displayCurrentProduct()
    }

    func fetchProducts() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "productID", ascending: true)]

        do {
            products = try context.fetch(request)
            if currentIndex >= products.count {
                currentIndex = 0
            }
        } catch {
            print("Failed to fetch products: \(error)")
        }
    }

    func displayCurrentProduct() {
        guard !products.isEmpty else {
            idLabel.text = "ID: -"
            nameLabel.text = "Name: No Products"
            descLabel.text = "Description: -"
            priceLabel.text = "Price: -"
            providerLabel.text = "Provider: -"
            return
        }

        let product = products[currentIndex]
        idLabel.text = "Product ID: \(product.productID)"
        nameLabel.text = "Product Name: \(product.productName ?? "")"
        descLabel.text = "Description: \(product.productDescription ?? "")"
        priceLabel.text = String(format: "Price: $%.2f", product.productPrice)
        providerLabel.text = "Provider: \(product.productProvider ?? "")"
    }

    @IBAction func previousTapped(_ sender: UIButton) {
        guard !products.isEmpty else { return }
        currentIndex = (currentIndex - 1 + products.count) % products.count
        displayCurrentProduct()
    }

    @IBAction func nextTapped(_ sender: UIButton) {
        guard !products.isEmpty else { return }
        currentIndex = (currentIndex + 1) % products.count
        displayCurrentProduct()
    }

    @IBAction func searchTapped(_ sender: UIButton) {
        let text = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if text.isEmpty {
            fetchProducts()
            currentIndex = 0
            displayCurrentProduct()
            return
        }

        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.predicate = NSPredicate(
            format: "productName CONTAINS[cd] %@ OR productDescription CONTAINS[cd] %@",
            text, text
        )
        request.sortDescriptors = [NSSortDescriptor(key: "productID", ascending: true)]

        do {
            let results = try context.fetch(request)

            if results.isEmpty {
                let alert = UIAlertController(
                    title: "Not Found",
                    message: "No matching products found.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            } else {
                products = results
                currentIndex = 0
                displayCurrentProduct()
            }
        } catch {
            print("Search error: \(error)")
        }
    }

    @IBAction func showAllTapped(_ sender: UIButton) {
    }

    @IBAction func addProductTapped(_ sender: UIButton) {
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAllProductsSegue" {
            let destination = segue.destination as! ProductListViewController
            destination.context = context
        } else if segue.identifier == "showAddProductSegue" {
            let destination = segue.destination as! AddProductViewController
            destination.context = context
        }
    }
}

