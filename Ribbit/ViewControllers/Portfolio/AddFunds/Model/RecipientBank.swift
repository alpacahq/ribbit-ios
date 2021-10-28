//
//  RecipientBank.swift
//  Ribbit
//
//  Created by Ahsan Ali on 20/05/2021.
//

import Foundation
// MARK: - RecipientBankElement
struct RecipientBankElement: Codable {
    let id, name, nickname: String
    let status: String
    let routingNumber: String
    let  bankType, accountNumber, accountID: String
    enum CodingKeys: String, CodingKey {
        case id, nickname
        case routingNumber = "bank_routing_number"
        case bankType = "bank_account_type"
        case name = "account_owner_name"
        case status
        case accountNumber = "bank_account_number"
        case accountID = "account_id"
    }
}

typealias RecipientBank = [RecipientBankElement]
