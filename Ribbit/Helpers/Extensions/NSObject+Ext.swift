//
//  NSObject+Ext.swift
//  Ribbit
//
//  Created by Adnan Asghar on 3/16/21.
//

import Foundation

extension NSObject {
    static var identifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }

    var stringFromInstance: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last ?? ""
    }
}
