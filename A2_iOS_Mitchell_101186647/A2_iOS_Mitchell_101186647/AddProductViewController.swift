//
//  AddProductViewController.swift
//  A2_iOS_Mitchell_101186647
//
//  Created by Mitchell Stevenson  on 2026-04-09.
//

import Foundation
import UIKit
import CoreData

class AddProductViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var providerTextField: UITextField!

    var context: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveTapped(_ sender: UIButton) {
        guard
            let idText = idTextField.text, let id = Int64(idText),
            let name = nameTextField.text, !name.isEmpty,
            let desc = descTextField.text, !desc.isEmpty,
            let priceText = priceTextField.text, let price = Double(priceText),
            let provider = providerTextField.text, !provider.isEmpty
        else {
            let alert = UIAlertController(
                title: "Invalid Input",
                message: "Please fill in all fields correctly.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.predicate = NSPredicate(format: "productID == %d", id)

        do {
            let existing = try context.fetch(request)
            if !existing.isEmpty {
                let alert = UIAlertController(
                    title: "Duplicate ID",
                    message: "A product with this ID already exists.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }
        } catch {
            print("Error checking duplicate ID: \(error)")
        }

        let product = Product(context: context)
        product.productID = id
        product.productName = name
        product.productDescription = desc
        product.productPrice = price
        product.productProvider = provider

        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            let alert = UIAlertController(
                title: "Error",
                message: "Could not save product.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            print("Save error: \(error)")
        }
    }
}
