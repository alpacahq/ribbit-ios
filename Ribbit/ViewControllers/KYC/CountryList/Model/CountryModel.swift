//
//  CountryModel.swift
//  Ribbit
//
//  Created by Ahsan Ali on 07/04/2021.
//

import Foundation
// MARK: - CountryModel
struct CountryModelElement: Codable {
    let  name: String
    let  shortCode: String?

    enum CodingKeys: String, CodingKey {
        case  name
        case shortCode = "short_code"
    }
}
typealias CountryModel = [CountryModelElement]
