//
//  USER.swift
//  Ribbit
//
//  Created by Ahsan Ali on 02/04/2021.
//

import Foundation
import UIKit
// MARK: - User
class USER: NSObject {
    override private init() {}
    static let shared = USER()
    var details: UserData?
    var accountDetail: PlaidAccount?
    var sharelink = ""
    var code = ""
    var isLoggedin = false
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let defaults = UserDefaults.standard
    var accountAdded = false
    func updateUser() {
        if let encoded = try? encoder.encode(details) {
            defaults.set(encoded, forKey: "user")
            consoleLog("USER UPDATED")
        }
    }
    func saveUser(detail: UserData) {
        if let encoded = try? encoder.encode(details) {
            defaults.set(encoded, forKey: "user")
            consoleLog("USER SAVED")
            self.details = detail
        }
    }
    func saveAccount(detail: PlaidAccount) {
        if let encoded = try? encoder.encode(details) {
            defaults.set(encoded, forKey: "account")
            consoleLog("Account SAVED")
            self.accountDetail = detail
        }
    }
    private func loadAccount() {
        if let savedPerson = defaults.object(forKey: "account") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(PlaidAccount.self, from: savedPerson) {
                accountDetail = loadedPerson
                consoleLog("account LOADED")
            }
        }
    }
    func loadUser() {
        if let savedPerson = defaults.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserData.self, from: savedPerson) {
                details = loadedPerson
                consoleLog("USER LOADED")
                isLoggedin = true
                loadAccount()
            }
        }
    }
    func logout() {
        isLoggedin = false
        defaults.removeObject(forKey: "user")
        let viewContrl = UIStoryboard.main.instantiateViewController(withIdentifier: NavigationVC.identifier ) as? NavigationVC ?? NavigationVC()
        UIApplication.setRootView(viewContrl, options: UIApplication.logoutAnimation)
    }
}
struct User: Codable {
    var createdAt, updatedAt, firstName, lastName: String?
    var username, email, mobile, avatar, countryCode, bio, twitterUrl, instagramUrl, facebookUrl, publicPortfolio: String?
    var address, lastLogin, employmentStatus, apartment, zipCode: String?
    let role: Role?
    var accountID, accountNumber, accountCurrency, accountStatus: String?
    var dob, city, state, country, taxIDType: String?
    var taxID, fundingSource, investingExperience, employerName, occupation, publicShareholder, shareholderCompanyName, stockSymbol, brokerageFirmName, brokerageFirmEmployeeName, brokerageFirmEmployeeRelationship: String?
    var anotherBrokerage, deviceID, profileCompletion: String?
    let active: Bool?
    var fullName: String {
        return "\(self.firstName?.capitalized ?? "John") \(self.lastName?.capitalized ?? "Doe")"
    }
    var nameChars: String {
        return "\(self.firstName?.prefix(1) ?? "")\(self.lastName?.prefix(1) ?? "")"
    }
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case zipCode = "zip_code"
        case avatar = "avatar"
        case username, email, mobile, bio, twitterUrl, instagramUrl, facebookUrl, publicPortfolio
        case countryCode = "country_code"
        case address
        case lastLogin = "last_login"
        case role, active
        case accountID = "account_id"
        case accountNumber = "account_number"
        case accountCurrency = "account_currency"
        case accountStatus = "account_status"
        case dob, city, country, state, employmentStatus
        case taxIDType = "tax_id_type"
        case taxID = "tax_id"
        case fundingSource = "funding_source"
        case investingExperience = "investing_experience"
        case publicShareholder = "public_shareholder"
        case employerName = "employer_name"
        case occupation = "occupation"
        case anotherBrokerage = "another_brokerage"
        case deviceID = "device_id"
        case stockSymbol = "stock_symbol"
        case brokerageFirmName = "brokerage_firm_name"
        case brokerageFirmEmployeeName = "brokerage_firm_employee_name"
        case brokerageFirmEmployeeRelationship = "brokerage_firm_employee_relationship"
        case apartment = "unit_apt"
        case shareholderCompanyName = "shareholder_company_name"
        case profileCompletion = "profile_completion"
    }
}
extension USER {
    func merge(updated: UpdatedUser?) {
        details?.user?.firstName = updated?.firstName
        details?.user?.lastName = updated?.lastName
        details?.user?.mobile = updated?.mobile
        details?.user?.zipCode = updated?.zipCode
        details?.user?.country = updated?.country
        details?.user?.countryCode = updated?.countryCode
        details?.user?.address = updated?.address
        details?.user?.avatar = updated?.avatar
        details?.user?.dob = updated?.dob
        details?.user?.taxID = updated?.taxID
        details?.user?.taxIDType = updated?.taxIDType
        details?.user?.investingExperience = updated?.investingExperience
        details?.user?.fundingSource = updated?.fundingSource
        details?.user?.anotherBrokerage = updated?.anotherBrokerage
        details?.user?.accountStatus = updated?.accountStatus
        details?.user?.publicShareholder = updated?.publicShareholder
        details?.user?.profileCompletion = updated?.profileCompletion
        details?.user?.accountID = updated?.accountID
        details?.user?.accountNumber = updated?.accountNumber
        details?.user?.employmentStatus = updated?.employmentStatus
        details?.user?.city = updated?.city
        details?.user?.state = updated?.state
        details?.user?.bio = updated?.bio
        details?.user?.twitterUrl = updated?.twitterUrl
        details?.user?.instagramUrl = updated?.instagramUrl
        details?.user?.facebookUrl = updated?.facebookUrl
        details?.user?.employerName = updated?.employerName
        details?.user?.occupation = updated?.occupation
        details?.user?.username = updated?.username
        details?.user?.shareholderCompanyName = updated?.shareholderCompanyName
        details?.user?.stockSymbol = updated?.stockSymbol
        details?.user?.brokerageFirmName = updated?.brokerageFirmName
        details?.user?.brokerageFirmEmployeeName = updated?.brokerageFirmEmployeeName
        details?.user?.brokerageFirmEmployeeRelationship = updated?.brokerageFirmEmployeeRelationship
        details?.user?.publicPortfolio = updated?.publicPortfolio
        details?.user?.apartment = updated?.apartment
    }
}
// MARK: - UpdatedUser
struct UpdatedUser: Codable {
    let id: Int?
    let firstName, lastName, username, avatar, email, employmentStatus, apartment, zipCode: String
    let mobile, countryCode, address, bio, twitterUrl, instagramUrl, facebookUrl, publicPortfolio: String?
    let verified, active: Bool?
    let role: Role?
    let accountID, accountNumber, accountCurrency, accountStatus: String?
    let dob, city, country, taxIDType, state: String?
    let taxID, fundingSource, investingExperience, employerName, occupation, publicShareholder, shareholderCompanyName, stockSymbol, brokerageFirmName, brokerageFirmEmployeeName, brokerageFirmEmployeeRelationship: String?
    let anotherBrokerage, deviceID, profileCompletion: String?
    enum CodingKeys: String, CodingKey {
        case id, employmentStatus, state, bio, twitterUrl, instagramUrl, facebookUrl, publicPortfolio
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "avatar"
        case username, email, mobile
        case countryCode = "country_code"
        case zipCode = "zip_code"
        case address
        case verified, active, role
        case accountID = "account_id"
        case accountNumber = "account_number"
        case accountCurrency = "account_currency"
        case accountStatus = "account_status"
        case dob, city, country
        case taxIDType = "tax_id_type"
        case taxID = "tax_id"
        case fundingSource = "funding_source"
        case investingExperience = "investing_experience"
        case publicShareholder = "public_shareholder"
        case anotherBrokerage = "another_brokerage"
        case employerName = "employer_name"
        case occupation = "occupation"
        case deviceID = "device_id"
        case stockSymbol = "stock_symbol"
        case brokerageFirmName = "brokerage_firm_name"
        case brokerageFirmEmployeeName = "brokerage_firm_employee_name"
        case brokerageFirmEmployeeRelationship = "brokerage_firm_employee_relationship"
        case shareholderCompanyName = "shareholder_company_name"
        case profileCompletion = "profile_completion"
        case apartment = "unit_apt"
    }
}
