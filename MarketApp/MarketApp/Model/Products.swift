//
//  Products.swift
//  MarketApp
//
//  Created by Furkan on 4.10.2022.
//

import Foundation

struct Products : Codable {
    let products: [Product]?
    let success: Int?
}

// MARK: - Product
struct Product : Codable {
    let id,name, price, img: String?
}
