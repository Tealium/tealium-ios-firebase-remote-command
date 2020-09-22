//
//  ProductViewController.swift
//  TealiumFirebaseExample
//
//  Created by Christina S on 7/19/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import UIKit

// Image Credit: https://www.flaticon.com/authors/xnimrodx 🙏
class ProductViewController: UIViewController {

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    var data = [String: Any]()
    var random: Int!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        random = Int.random(in: 0...1000)
        data[ProductViewController.productId] = ["PROD\(random!)"]
        data[ProductViewController.productCategory] = ["appliances"]
        NotificationCenter.default.addObserver(self, selector: #selector(showProduct(notification:)), name: Notification.Name(CategoryViewController.productClicked), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func changeQuantity(_ sender: UIStepper) {
        quantityLabel.text = String(Int(sender.value))
        data["product_quantity"] = [String(Int(sender.value))]
    }
    
    @IBAction func changeColor(_ sender: UISegmentedControl) {
        data["product_variant"] = ["\(String(describing: sender.titleForSegment(at: sender.selectedSegmentIndex)))-\(String(describing: random))"]
    }
    
    @IBAction func addToCart(_ sender: UIButton) {
        let ac = UIAlertController(title: "Added!", message: "\(String(describing: productName.text!)) was added to your cart", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.data[ProductViewController.productId] = "3d053202-a50b-43f4-9ce7-0d154ad21a8e"
            self.data[ProductViewController.productPrice] = 100
            self.data[ProductViewController.productName] = "Fridge"
            self.data[ProductViewController.productCategory] = "appliances"
            self.data[ProductViewController.productVariant] = "abc-123-xyz"
            self.data[ProductViewController.productBrand] = "acme"
            self.data[ProductViewController.productQuantity] = 1
            self.data["event_title"] = EventNames.lookup["cart_add"]!
            TealiumHelper.trackEvent(title: "cart_add", data: self.data)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(ac, animated: true)
    }
    
    @IBAction func AddToWishList(_ sender: UIButton) {
        let ac = UIAlertController(title: "Added!", message: "\(String(describing: productName.text!)) was added to your wishlist", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.data[ProductViewController.productId] = ["3d053202-a50b-43f4-9ce7-0d154ad21a8e"]
            self.data[ProductViewController.productPrice] = [100]
            self.data[ProductViewController.productName] = ["Fridge"]
            self.data[ProductViewController.productCategory] = ["appliances"]
            self.data[ProductViewController.productVariant] = ["abc-123-xyz"]
            self.data[ProductViewController.productBrand] = ["acme"]
            self.data[ProductViewController.productQuantity] = [1]
            self.data["event_title"] = EventNames.lookup["wishlist_add"]!
            TealiumHelper.trackEvent(title: "wishlist_add", data: self.data)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(ac, animated: true)
    }
    
    @objc func showProduct(notification: Notification) {
        guard let productData = notification.userInfo else {
            return
        }
        if let name = productData[CategoryViewController.productName] as? String {
           productName.text = name
        } else {
            productName.text = "Fridge"
        }
        if let image = productData[CategoryViewController.productImageName] as? String {
            productImage.image = UIImage(named: image)
        } else {
            productImage.image = UIImage(named: "7-fridge")
        }
        if let price = productData[CategoryViewController.productPrice] as? String {
            productPrice.text = price
        } else {
             productPrice.text = "$100"
        }
        data[ProductViewController.productId] = ["3d053202-a50b-43f4-9ce7-0d154ad21a8e"]
        data[ProductViewController.productPrice] = [100]
        data[ProductViewController.productName] = ["Fridge"]
        data[ProductViewController.productCategory] = ["appliances"]
        data[ProductViewController.productVariant] = ["abc-123-xyz"]
        data[ProductViewController.productBrand] = ["acme"]
        data["screen_class"] = "\(self.classForCoder)"
        data["event_title"] = EventNames.lookup["product"]!
        TealiumHelper.trackView(title: "product", data: data)
    }
    
    
    
}

extension ProductViewController {
    static let productId = "product_id"
    static let productName = "product_name"
    static let productQuantity = "product_quantity"
    static let productVariant = "product_variant"
    static let productPrice = "product_price"
    static let productCategory = "product_category"
    static let productBrand = "product_brand"
    static let screenClass = "screen_class"
}
