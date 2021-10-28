//
// NetworkProxy.swift
// Ribbit
//
// Created by Ahsan Ali on 31/03/2021.
//
import Alamofire
import Foundation
import UIKit
protocol NetworkProxyDelegate: AnyObject {
    func requestDidBegin()
    func requestDidFinishedWithData(data: Any, reqType: RequestType)
    func requestDidFailedWithError(error: String, reqType: RequestType)
}

class NetworkProxy: NSObject, ServiceManagerDelegate {
    weak var delegate: NetworkProxyDelegate?
    var serviceManager: ServiceManager?
    var requestParser: RequestParser?

    override init() {
        super.init()
        serviceManager = ServiceManager()
        requestParser = RequestParser()
        serviceManager?.delegate = self
    }
    // MARK: - Rest Api's
    func requestForMagicLink(email: String, token: String) {
        let param = ["email": email, "token": token ]
        delegate?.requestDidBegin()
        serviceManager?.postRestApi(postPath: EndPoint.magic, parameters: param, reqType: .magic)
    }

    func requestForSignUp(email: String, password: String) {
        let param = ["email": email, "password": password ]
        delegate?.requestDidBegin()
        serviceManager?.postRestApi(postPath: EndPoint.signup, parameters: param, reqType: .signUp)
    }

    func requestForLogin(email: String, password: String) {
        let param = ["email": email, "password": password]
        delegate?.requestDidBegin()
        serviceManager?.postRestApi(postPath: EndPoint.login, parameters: param, reqType: .login)
    }

    func sendReferel(code: String) {
        delegate?.requestDidBegin()
        let path = EndPoint.referel.replacingOccurrences(of: "refCode", with: code)
        serviceManager?.getRestApi(getPath: path, reqType: .referelCode)
    }

    // PATCH API
    func requestForUpdateProfile(param: [String: String]) {
        delegate?.requestDidBegin()
        serviceManager?.patchRestApi(path: EndPoint.updateProfile, parameters: param, reqType: .updateProfile)
    }

    func requestForCountryList() {
        delegate?.requestDidBegin()
        serviceManager?.getRestApi(getPath: EndPoint.countries, reqType: .countryList)
    }

    func requestForLinkToken() {
        delegate?.requestDidBegin()
        serviceManager?.getRestApi(getPath: EndPoint.createLinkToken, reqType: .createLinkToken)
    }

    func requestForSetAccessToken(token: String, actID: String) {
        let param = ["public_token": token, "account_id": actID]
        delegate?.requestDidBegin()
        serviceManager?.postRestApi(postPath: EndPoint.setAccessToken, parameters: param, reqType: .setAccessToken)
    }

    func requestForStateList(code: String) {
        delegate?.requestDidBegin()
        let path = EndPoint.states.replacingOccurrences(of: "country_code", with: code)
        serviceManager?.getRestApi(getPath: path, reqType: .stateList)
    }
    func requestForCityList(code: String, state: String) {
        delegate?.requestDidBegin()
        let path = EndPoint.cities.replacingOccurrences(of: "country_code", with: code).replacingOccurrences(of: "state_code", with: state)
        serviceManager?.getRestApi(getPath: path, reqType: .cityList)
    }

    func requestForSign() {
        delegate?.requestDidBegin()
        serviceManager?.postRestApi(postPath: EndPoint.Sign, parameters: [:], reqType: .sign)
    }

    func requestForTransfer() {
        delegate?.requestDidBegin()
        serviceManager?.getRestApi(getPath: EndPoint.transfer, reqType: .transfer)
    }

    func requestForDeposit(bID: String, amount: String) {
        delegate?.requestDidBegin()
        let path = EndPoint.deposit.replacingOccurrences(of: "bank_id", with: bID)
        serviceManager?.postRestApi(postPath: path, parameters: ["amount": amount], reqType: .deposit, encoding: URLEncoding.default)
    }

    func requestForRecipientBanks() {
        delegate?.requestDidBegin()
        serviceManager?.getRestApi(getPath: EndPoint.recipientBanks, reqType: .recipientBanks)
    }

    func detachBank(bID: String) {
        delegate?.requestDidBegin()
        let path = EndPoint.detachBank.replacingOccurrences(of: "bank_id", with: bID)
        serviceManager?.deleteRestApi(path: path, reqType: .detachBank)
    }

    func requestForStats() {
        delegate?.requestDidBegin()
        serviceManager?.getRestApi(getPath: EndPoint.stats, reqType: .stats)
    }

    func requestForShareableLink() {
        delegate?.requestDidBegin()
        serviceManager?.getRestApi(getPath: EndPoint.shareableLink, reqType: .shareableLink)
    }

    func requestForAssets() {
        delegate?.requestDidBegin()
        serviceManager?.getRestApi(getPath: EndPoint.Assests, reqType: .assets)
    }

    func requestForWatchList() {
        delegate?.requestDidBegin()
        serviceManager?.getRestApi(getPath: EndPoint.watchList, reqType: .watchList)
    }

    func requestForPositions() {
        delegate?.requestDidBegin()
        serviceManager?.getRestApi(getPath: EndPoint.positions, reqType: .positions)
    }

    func requestForOrder(symbol: String, notional: String, side: String, type: String, time: String) {
        let param = ["symbol": symbol, "notional": notional, "side": side, "type": type, "time_in_force": time]
        delegate?.requestDidBegin()
        serviceManager?.postRestApi(postPath: EndPoint.Order, parameters: param, reqType: .order)
    }

    func requestForFav(symbol: String) {
        delegate?.requestDidBegin()
        serviceManager?.postRestApi(postPath: EndPoint.FavouriteAsset, parameters: ["symbol": symbol], reqType: .markfav)
    }

    func requestForBars(symbol: String, timeFrame: String, start: String, end: String) {
        delegate?.requestDidBegin()

        let path = EndPoint.Bars.replacingOccurrences(of: "{symbol}", with: symbol)
        let param = ["timeframe": timeFrame, "start": start, "end": end]

        serviceManager?.getRestApi(getPath: path, reqType: .bars, encoding: URLEncoding.default, param: param)
        consoleLog(param)
    }

    func requestForTotalAmountRem() {
        delegate?.requestDidBegin()
        serviceManager?.getRestApi(getPath: EndPoint.TradingView, reqType: .tradingView)
    }

    func removeFav(symbol: String) {
        delegate?.requestDidBegin()
        let path = EndPoint.unFavoutite.replacingOccurrences(of: "{symbol}", with: symbol)
        serviceManager?.deleteRestApi(path: path, reqType: .deleteFav)
    }

    // MARK: - Service Manager Delegate
    func requestFinished(responseData: Any, reqType: RequestType) {
        let response = requestParser?.parseResponse(response: responseData, reqType: reqType)
        delegate?.requestDidFinishedWithData(data: response as Any, reqType: reqType)
    }

    func requestFailed(data: Any?, error: String?, reqType: RequestType) {
        if error == nil {
            // FAILED CASED FROM API
            // returning error message to controller
            var msg = ""
            if data != nil {
                msg = requestParser?.parseResponse(response: data!)?.message ?? Constants.ServerError
            }
            delegate?.requestDidFailedWithError(error: msg, reqType: reqType)
        } else {
            // EXCEPTION CASE
            // returning error message to controller
            delegate?.requestDidFailedWithError(error: error!, reqType: reqType)
        }
    }
}
