//
//  Validation.swift
//  Ribbit
//
//  Created by Ahsan Ali on 23/03/2021.
//

import Foundation

class Validator {
    func validate(text: String, with rules: [Rule]) -> String? {
        return rules.compactMap({ $0.check(text) }).first
    }
}

struct Rule {
    let check: (String) -> String?

    static let notEmpty = Rule(check: {
        return $0.isEmpty ? "Must not be empty" : nil
    })

    static let validateEmail = Rule(check: {
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: $0) ? nil: "Invalid Email"
    })
    static let validateFirstName = Rule(check: {
        return NSPredicate(format: "SELF MATCHES %@", "[a-zA-Z]").evaluate(with: $0) ? nil: "Invalid First Name"
    })
    static let validateLastName = Rule(check: {
        return NSPredicate(format: "SELF MATCHES %@", "[a-zA-Z]").evaluate(with: $0) ? nil: "Invalid Last Name"
    })

    static let validatePhone = Rule(check: {
        return NSPredicate(format: "SELF MATCHES %@", "[0-9]{10,11}$").evaluate(with: $0) ? nil: "Invalid Phone Number"
    })

    static let validateSSN = Rule(check: {
        return $0.count == 9 ? nil: "Invalid SSN Number"
    })

    static let validateBio = Rule(check: {
        return NSPredicate(format: "SELF MATCHES %@", "[a-z A-Z]+").evaluate(with: $0) ? nil: "Invalid Bio"
    })

    static let validateURL = Rule(check: {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: $0) ? nil: "Invalid URL"
    })
    static let validatePassword = Rule(check: {
        let passwordRegex = "^[A-Za-z\\d$@$#!%*?&]{8,16}"

        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: $0) ? nil: "Password must contain at least 8-16 characters"
    })
    static let validateZip = Rule(check: {
        let passwordRegex = "^[0-9]{5}(-[0-9]{4})?$"

        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: $0) ? nil: "Zip Code should contain 5 digits"
    })
}
