//
//  CategoryViewController.swift
//  TealiumFirebaseExample
//
//  Created by Christina S on 7/19/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import UIKit

// Image Credit: https://www.flaticon.com/authors/xnimrodx 🙏
class CategoryViewController: UIViewController {
    
    var products = [String]()
    var ids = [String]()
    var prices = Array(30...1000)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        products = ["1-blender","2-fan","3-iron","4-kettle","5-lamp",
                    "6-oven","7-fridge","8-scale","9-stove", "10-toaster",
                    "11-television","12-vacuum"]
        ids = ["6460808b-34fb-41b5-8e08-ea1276c7462f",
               "87fe51ff-8650-4534-bb23-41e8ed6f92b5",
               "05d43dec-e97b-49e2-90ee-cb43dd0d6188",
               "0fb35551-5188-4e3a-a231-5fe78c813fa8",
               "e5c80e01-028e-4681-9db8-b7a99ca5a269",
               "43a25f02-1327-4eda-aa4c-6d3553d5edf0",
               "3d053202-a50b-43f4-9ce7-0d154ad21a8e",
               "b83dea80-700c-4b3f-a526-db56a1a10e7b",
               "7fb6d145-e140-4d66-a4d4-a8c11e32ab40",
               "e9dd2464-35af-441e-aa95-91d819d0bd14",
               "2f26915c-b235-4d88-9d44-dedefd3eb6b7",
               "7f550f6e-a97b-4e33-b33b-120ef64e70de"]
        prices.shuffle()
    }
    
}

extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productImageName = products[indexPath.item]
        let productName = products[indexPath.item].split(separator: "-")[1].capitalized
        let productPrice = "$\(prices[indexPath.item])"
        let notification = Notification(name: Notification.Name(CategoryViewController.productClicked), object: self, userInfo: [CategoryViewController.productImageName: productImageName, CategoryViewController.productName: productName, CategoryViewController.productPrice: productPrice])
        NotificationCenter.default.post(notification)
    }
}

extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImage", for: indexPath) as? ProductCell else {
            fatalError("Unable to dequeue ProductCell")
        }
        let product = products[indexPath.item]
        let productName = product.split(separator: "-")[1].capitalized
        cell.imageView.image = UIImage(named: product)
        cell.name.text = productName
        cell.price.text = "$\(prices[indexPath.item])"
       
        return cell
    }
}

extension CategoryViewController {
    static let productClicked = "product_clicked"
    static let productImageName = "product_image_name"
    static let productName = "product_name"
    static let productPrice = "product_price"
    static let categoryName = "category_name"
    static let screenClass = "screen_class"
}
