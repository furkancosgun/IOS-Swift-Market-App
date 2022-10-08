//
//  Basket.swift
//  MarketApp
//
//  Created by Furkan on 8.10.2022.
//

import Foundation
// MARK: - Basket
struct Basket :Codable{
    let basket: [BasketElement]?
    let success: Int?
}

// MARK: - BasketElement
struct BasketElement:Codable {
    var id, name, price, piece,productId,img: String?
}
