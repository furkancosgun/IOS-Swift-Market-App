//
//  Comments.swift
//  MarketApp
//
//  Created by Furkan on 5.10.2022.
//

import Foundation

struct comments : Codable {
    let comments: [Comment]?
    let success: Int?
}

// MARK: - Product
struct Comment : Codable {
    let text,full_name: String?
}
