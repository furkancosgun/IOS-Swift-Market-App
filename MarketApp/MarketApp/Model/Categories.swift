//
//  Categories.swift
//  MarketApp
//
//  Created by Furkan on 5.10.2022.
//

import Foundation

// MARK: - Welcome
struct Categories : Codable{
    let categories: [Category]?
    let success: Int?
}

// MARK: - Category
struct Category : Codable{
    let id, name , img: String?
}
