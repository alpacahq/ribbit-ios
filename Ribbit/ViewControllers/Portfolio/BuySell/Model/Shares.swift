//
//  Shares.swift
//  Ribbit
//
//  Created by Ahsan Ali on 14/06/2021.
//

import Foundation
struct Share: Codable {
    let o: Float
    let t: String
}
struct Bar: Codable {
    let bars: [Share]
}
