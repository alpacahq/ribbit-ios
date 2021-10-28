//
//  ErrorModel.swift
//  Ribbit
//
//  Created by Ahsan Ali on 31/03/2021.
//

import Foundation
// MARK: - ErrorModel
struct ErrorModel: Codable {
    let message: String?
    let errors: Errors?
}

// MARK: - Errors
struct Errors: Codable {
}
