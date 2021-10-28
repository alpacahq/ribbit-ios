//
//  Stocks.swift
//  Ribbit
//
//  Created by Ahsan Ali on 12/06/2021.
//

import Foundation
// MARK: - Stocks
struct Stocks: Codable {
    let accountID: String
    let assets: [Asset]?
    let createdAt, id, name, updatedAt: String?
    enum CodingKeys: String, CodingKey {
        case accountID = "account_id"
        case assets
        case createdAt = "created_at"
        case id, name
        case updatedAt = "updated_at"
    }
}
// MARK: - Asset
struct Asset: Codable {
    let id: String?
    let name: String?
    let status, symbol: String?
    enum CodingKeys: String, CodingKey {
        case id, name, status, symbol
    }
}
