//
//  Date+Ext.swift
//  Ribbit
//
//  Created by Ahsan Ali on 23/03/2021.
//

import Foundation
extension Date {
 var formattedDateStr: String {
    let outFormat = DateFormatter()
    outFormat.timeZone = .current
    outFormat.dateFormat = "dd-MM-yy"
    return outFormat.string(from: self)
    }
    var formattedfullDateStr: String {
       let outFormat = DateFormatter()
       outFormat.timeZone = .current
       outFormat.dateFormat = "yyyy-MM-dd"
       return outFormat.string(from: self)
       }
    var RFCFormat: String {
        let outFormat = DateFormatter()
        outFormat.timeZone = TimeZone(abbreviation: "UTC")
        outFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSS'Z'"
        return outFormat.string(from: self)
    }
}
extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}
