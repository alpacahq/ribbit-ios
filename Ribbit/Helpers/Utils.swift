//
//  Utils.swift
//  Ribbit
//
//  Created by Rao Mudassar on 12/08/2021.
//

import Foundation
import SwiftyRSA
import UIKit

class Utils {
    static func encryptPassword(string: String) -> String {
        var base64String = ""
       do {
           let pemPrivate = EndPoint.passwordPemKey
           let publicKey = try PublicKey(pemEncoded: pemPrivate)
           let clear = try ClearMessage(string: string, using: .utf8)
           let encrypted = try clear.encrypted(with: publicKey, padding: .PKCS1)

           // Then you can use:
          // let data = encrypted.data
        base64String = encrypted.base64String
       print(base64String)
       } catch {
           print(error)
       }
        return base64String
   }
}
