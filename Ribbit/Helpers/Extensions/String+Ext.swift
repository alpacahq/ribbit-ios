//
//  String+Ext.swift
//  Ribbit
//
//  Created by Ahsan Ali on 31/03/2021.
//

import Foundation
extension String {
    var formattedDate: String {
        let inFormat = DateFormatter()
        let outFormat = DateFormatter()
        inFormat.timeZone = .current
        outFormat.timeZone = .current
        inFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        outFormat.dateFormat = "dd-MM-yyyy"
        let date = inFormat.date(from: self)
        return outFormat.string(from: date ?? Date())
    }

    var formattedDate1: String {
        let inFormat = DateFormatter()
        let outFormat = DateFormatter()
        inFormat.timeZone = .current
        outFormat.timeZone = .current
        inFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        outFormat.dateFormat = "HH:mm:ss"
        let date = inFormat.date(from: self)
        return outFormat.string(from: date ?? Date())
    }

    var formattedTime: String {
        let inFormat = DateFormatter()
        let outFormat = DateFormatter()
        inFormat.timeZone = .current
        outFormat.timeZone = .current
        inFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        outFormat.dateFormat = "HH:mm a"
        let date = inFormat.date(from: self)
        return outFormat.string(from: date ?? Date())
    }

    var formattedServerDate: String {
        let inFormat = DateFormatter()
        let outFormat = DateFormatter()
        inFormat.timeZone = .current
        outFormat.timeZone = .current
        inFormat.dateFormat = "MM/dd/yyyy"
        outFormat.dateFormat = "yyyy-MM-dd"
        let date = inFormat.date(from: self)
        return outFormat.string(from: date ?? Date())
    }

    var formattedServerToAppDate: String {
        let inFormat = DateFormatter()
        let outFormat = DateFormatter()
        inFormat.timeZone = .current
        outFormat.timeZone = .current
        inFormat.dateFormat = "yyyy-MM-dd"
        outFormat.dateFormat = "MM/dd/yyyy"
        let date = inFormat.date(from: self)
        return outFormat.string(from: date ?? Date())
    }
}

func consoleLog(_ items: Any...) {
    #if DEBUG
       print(items)
    #endif
}
extension String {
    func applyPatternOnNumbers(pattern: String, replacementCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }

    var encodeURL: String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    func addParams(params: [String]) -> String {
        var count = 1
        var newURL = self
        for param in params {
            newURL = newURL.replacingOccurrences(of: "*param\(count)*", with: param.encodeURL)
            count += 1
        }
        return newURL
    }
}
