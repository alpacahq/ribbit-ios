//
//  PlaidAccount.swift
//  Ribbit
//
//  Created by Ahsan Ali on 17/05/2021.
//

import Foundation
struct PlaidAccount: Codable {
    let account_id, account_owner_name, bank_account_number, bank_account_type, bank_routing_number, id, nickname, status: String
}
