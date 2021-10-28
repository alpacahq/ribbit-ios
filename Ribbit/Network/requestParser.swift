//
// requestParser.swift
// Ribbit
//
// Created by Ahsan Ali on 31/03/2021.
//
let serverError = "Server not responding"

import Foundation

class RequestParser: NSObject {
    // MARK: - Varibales
    private let newJSONDecoder = JSONDecoder()
    // MARK: - Helpers
    func parseResponse(response: Any, reqType: RequestType) -> Any? {
        var items: Any?
        switch reqType {
        case .signUp, .login, .magic:
            items = parseSignup(response: response)
        case .countryList, .stateList, .cityList:
            items = parseCountries(response: response)
        case .updateProfile, .sign:
            items = parseUpdate(response: response)
        case .createLinkToken:
            items = parseLinkToken(response: response)
        case .setAccessToken:
            items = parseSetAccessToken(response: response)
        case .transfer:
            items = parseTransactions(response: response)
        case .deposit:
            items = parseDeposit(response: response)
        case .recipientBanks:
            items = parseReceipientBank(response: response)
        case .detachBank:
            items = response
        case .stats:
            items = parseStats(response: response)
        case .shareableLink:
            items = parseShareableLink(response: response)
        case .assets:
            items = response
        case .referelCode:
            items = (response as? NSDictionary)?["referral_code"] as? String ?? ""
        case .bars:
            items = parseShares(response: response)
        case .tradingView:
            items = parseTotalBalance(response: response)
        case .order:
            items = parseStringError(response: response)
        case .markfav, .deleteFav:
            items = parseFav(response: response)
        case .watchList, .positions:
            items = parseStocks(response: response)
        }

        return items
    }

    // MARK: - Rest Api's
    // parsng of sign up api
    private func parseUpdate(response: Any) -> Any? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
            let model = try newJSONDecoder.decode(UpdatedUser.self, from: jsonData)
            USER.shared.merge(updated: model)
            USER.shared.updateUser()
            return model
        } catch {
            consoleLog("Model Not Mapped on Json Signup", error.localizedDescription)
            return parseResponse(response: response)
        }
    }

    private func parseSignup(response: Any) -> Signup? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
            let model = try newJSONDecoder.decode(Signup.self, from: jsonData)
            return model
        } catch {
            consoleLog("Model Not Mapped on Json Signup", error.localizedDescription)
            return nil
        }
    }

    private func parseCountries(response: Any) -> CountryModel? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
            let model = try newJSONDecoder.decode(CountryModel.self, from: jsonData)
            return model
        } catch {
            consoleLog("Model Not Mapped on Json CountryModel", error.localizedDescription)
            return nil
        }
    }

    private func parseSetAccessToken(response: Any) -> Any? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
            let model = try newJSONDecoder.decode(PlaidAccount.self, from: jsonData)
            USER.shared.saveAccount(detail: model)
            return model
        } catch {
            consoleLog("Model Not Mapped on Json PlaidAccount", error.localizedDescription)
            return  parseStringError(response: response)
        }
    }

    private func parseLinkToken(response: Any) -> String {
        if let res = response as? NSDictionary {
            return res["link_token"] as? String ?? serverError
        }
        return serverError
    }

    private func parseStringError(response: Any) -> String {
        if let res = response as? NSDictionary {
            return res["status"] as? String ?? res["message"] as? String ?? serverError
        }
        return serverError
    }

    private func parseReceipientBank(response: Any) -> [PlaidAccount]? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
            let model = try newJSONDecoder.decode([PlaidAccount].self, from: jsonData)
            return model
        } catch {
            consoleLog("Model Not Mapped on Json PlaidAccount", error.localizedDescription)
            return nil
        }
    }

    private func parseDeposit(response: Any) -> DepositDetail? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
            let model = try newJSONDecoder.decode(DepositDetail.self, from: jsonData)
            return model
        } catch {
            consoleLog("Model Not Mapped on Json DepositDetail", error.localizedDescription)
            return nil
        }
    }

    private func parseTransactions(response: Any) -> Transactions? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
            let model = try newJSONDecoder.decode(Transactions.self, from: jsonData)
            return model
        } catch {
            consoleLog("Model Not Mapped on Json Transactions", error.localizedDescription)
            return nil
        }
    }

    private func parseStats(response: Any) -> (Int, Int) {
        if let res = response as? NSDictionary {
            let rewards = (res["reward_earned"] as? Int ?? 0)
            let invite = (res["people_invited"] as? Int ?? 0)
            return(rewards, invite)
        }
        return(0, 0)
    }

    private func parseShareableLink(response: Any) -> (String?, String?) {
        if let res = response as? NSDictionary {
            let link = (res["url"] as? String ?? "")
            let code = (res["code"] as? String ?? "")
            return (link, code)
        }

        return (nil, nil)
    }

    private func parseTotalBalance(response: Any) -> String {
        if let res = response as? NSDictionary {
            let amount = (res["buying_power"] as? String ?? "")
            return amount
        }

        return "0"
    }
    private func parseFav(response: Any) -> (String?, String?) {
        if let res = response as? NSDictionary {
            let aid = (res["account_id"] as? String ?? "")
            let msg = (res["message"] as? String ?? "")
            return (aid, msg)
        }

        return (nil, nil)
    }

    private func parseShares(response: Any) -> Any? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
            let model = try newJSONDecoder.decode(Bar.self, from: jsonData)
            return model
        } catch {
            consoleLog("Model Not Mapped on Json Shares Bar Graph Data", error.localizedDescription)
            return  parseStringError(response: response)
        }
    }
    private func parseStocks(response: Any) -> Any? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
            let model = try newJSONDecoder.decode(Stocks.self, from: jsonData)
            return model
        } catch {
            consoleLog("Model Not Mapped on Json Stocks", error.localizedDescription)
            return  parseStringError(response: response)
        }
    }

    // MARK: - parse Error CASE
    // parse errors from api
    func parseResponse(response: Any) -> ErrorModel? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
            let error = try newJSONDecoder.decode(ErrorModel.self, from: jsonData)
            return error
        } catch {
            consoleLog("Model Not Mapped on Json ErrorModel", error.localizedDescription)
            return nil
        }
    }
}
