//
//  FirebaseItems.swift
//  TealiumFirebase
//
//  Created by Christina S on 6/12/20.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation

struct FirebaseItemArray: Codable {
    var id: [String]
    var name: [String]?
    var quantity: [Int]?
    var category: [String]?
    var variant: [String]?
    var brand: [String]?
    var price: [Double]?

    enum CodingKeys: String, CodingKey {
        case id = "param_item_id"
        case name = "param_item_name"
        case quantity = "param_quantity"
        case category = "param_item_category"
        case variant = "param_item_variant"
        case brand = "param_item_brand"
        case price = "param_price"
    }
}

struct FirebaseItem: Codable {
    var id: String
    var name: String?
    var quantity: Int?
    var category: String?
    var variant: String?
    var brand: String?
    var price: Double?

    enum CodingKeys: String, CodingKey {
        case id = "item_id"
        case name = "item_name"
        case quantity = "quantity"
        case category = "item_category"
        case variant = "item_variant"
        case brand = "item_brand"
        case price = "price"
    }
}

extension Array where Element == FirebaseItem {
    init?(from dictionary: [String: Any]) {
        var items = [FirebaseItem]()
        guard
            let jsonData = try? JSONSerialization.data(withJSONObject: dictionary,
                options: .prettyPrinted),
            let decoded = try? JSONDecoder().decode(FirebaseItemArray.self,
                from: jsonData) else {
                return nil
        }
        for (index, _) in decoded.id.enumerated() {
            items.append(FirebaseItem(id: decoded.id[index],
                                      name: decoded.name?[index],
                                      quantity: decoded.quantity?[index],
                                      category: decoded.category?[index],
                                      variant: decoded.variant?[index],
                                      brand: decoded.brand?[index],
                                      price: decoded.price?[index]))
        }
        self = items
    }

    var dictionaryArray: [[String: Any]] {
        self.compactMap {
            $0.dictionary
        }
    }
}

fileprivate extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
