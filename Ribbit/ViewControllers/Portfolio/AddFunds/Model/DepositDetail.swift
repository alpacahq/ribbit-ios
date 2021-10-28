//
//  DepositDetail.swift
//  Ribbit
//
//  Created by Ahsan Ali on 20/05/2021.
//

import Foundation
struct DepositDetail: Codable {
let account_id, direction, id, relationship_id, status, type, updated_at: String
let amount: String
}
