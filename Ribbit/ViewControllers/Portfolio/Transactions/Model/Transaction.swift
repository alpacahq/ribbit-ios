//
//  Transaction.swift
//  Ribbit
//
//  Created by Ahsan Ali on 20/05/2021.
//

import Foundation

struct Transaction: Codable {
        let account_id,
        amount,
        created_at,
        direction,
        id,
        relationship_id,
        status,
        type,
        updated_at: String
        let reason: String?

    var isCredit: Bool {
        return direction.uppercased() == "INCOMING"
    }

    var amountStr: String {
        return isCredit ? "+ \(amount) USD" :  "- \(amount) USD"
    }

    var subTitle: String {
        return isCredit ? "Funds Credited" :  "Funds Debited"
    }
}

typealias Transactions = [Transaction]
