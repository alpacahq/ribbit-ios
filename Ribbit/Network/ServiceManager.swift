//
// ServiceManager.swift
// Ribbit
//
// Created by Ahsan Ali on 31/03/2021.
//

import Alamofire
import Foundation
protocol ServiceManagerDelegate: AnyObject {
    func requestFinished(responseData: Any, reqType: RequestType)
    func requestFailed(data: Any?, error: String?, reqType: RequestType)
}
class ServiceManager: NSObject {
    // MARK: - Variables
    weak var delegate: ServiceManagerDelegate?

    // MARK: - Functions
    func prepareURLForResource(path: String) -> String {
        return String(format: "%@%@", EndPoint.kServerBase, path)
    }
    func postRestApi(postPath: String, parameters: Parameters, reqType: RequestType, encoding: ParameterEncoding? = JSONEncoding.default) {
        let postURL = prepareURLForResource(path: postPath)
        var token = USER.shared.details?.token ?? ""
        var param = parameters
        if reqType == .magic {
            token = param["token"] as? String ?? ""
            param.removeValue(forKey: "token")
        }
        let headers: HTTPHeaders? = [.authorization(bearerToken: token)]
        consoleLog("POST CALL : \(postURL)", parameters)
        AF.request(postURL, method: .post, parameters: param, encoding: encoding!, headers: headers)
            .responseJSON { response  in
                if (response.response?.allHeaderFields as? [String: Any]) != nil {
                    if let newToken = response.response?.allHeaderFields["New-Token"] as? String {
                        USER.shared.details?.token = newToken
                    }
                }
                if response.error == nil {
                    guard let value = response.value as? NSDictionary else {
                        return
                    }
                    consoleLog("POST RSULT : \(postURL)", value)

                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        // SUCCESS
                        case 403:
                            consoleLog("Un-Authorized User")
                            self.delegate?.requestFailed(data: nil, error: "Un-Authorized User", reqType: reqType)
                            USER.shared.logout()
                        case 200, 201, 204:
                            self.delegate?.requestFinished(responseData: value, reqType: reqType)
                        // FAIL
                        default:
                            self.delegate?.requestFailed(data: value, error: nil, reqType: reqType)
                        }
                    }
                } else {
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        // SUCCESS
                        case 403:
                            consoleLog("Un-Authorized User")
                            self.delegate?.requestFailed(data: nil, error: "Un-Authorized User", reqType: reqType)
                            USER.shared.logout()
                        default:
                            self.delegate?.requestFailed(data: response.value, error: nil, reqType: reqType)
                        }
                    }
                    let error = response.error?.localizedDescription ?? ""
                    consoleLog(error)
                    self.delegate?.requestFailed(data: nil, error: Constants.ServerError, reqType: reqType)
                }
            }
    }

    func getRestApi(getPath: String, reqType: RequestType, encoding: ParameterEncoding? = JSONEncoding.default, param: Parameters? = nil) {
        let getURL = prepareURLForResource(path: getPath)
        consoleLog("GET CALL : \(getURL)")

        let headers: HTTPHeaders? = [.authorization(bearerToken: USER.shared.details?.token ?? "")]
        consoleLog(USER.shared.details?.token ?? "")
        AF.request(getURL, method: .get, parameters: param, encoding: encoding!, headers: headers)
            .responseJSON { response in
                if (response.response?.allHeaderFields as? [String: Any]) != nil {
                    if let newToken = response.response?.allHeaderFields["New-Token"] as? String {
                        USER.shared.details?.token = newToken
                    }
                }

                if response.error == nil {
                    var value: Any?

                    if let valueT = response.value as? NSDictionary {
                        value = valueT
                    } else if let valueT = response.value as? [[String: Any]] {
                        value = valueT
                    }
                    if value != nil {
                        consoleLog("GET RESULt: \(getURL)", value!)
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            // SUCCESS
                            case 403:
                                consoleLog("Un-Authorized User")
                                self.delegate?.requestFailed(data: nil, error: "Un-Authorized User", reqType: reqType)
                                USER.shared.logout()
                            case 200, 201, 204:
                                self.delegate?.requestFinished(responseData: value!, reqType: reqType)

                            // FAIL
                            default:
                                self.delegate?.requestFailed(data: value, error: nil, reqType: reqType)
                            }
                        }
                    }
                } else {
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        // SUCCESS
                        case 403:
                            consoleLog("Un-Authorized User")
                            self.delegate?.requestFailed(data: nil, error: "Un-Authorized User", reqType: reqType)
                            USER.shared.logout()
                        default:
                            self.delegate?.requestFailed(data: response.value, error: nil, reqType: reqType)
                        }
                    }
                    let error = response.error?.localizedDescription ?? ""
                    consoleLog(error)
                    self.delegate?.requestFailed(data: nil, error: Constants.ServerError, reqType: reqType)
                }
            }
    }

    func patchRestApi(path: String, parameters: Parameters, reqType: RequestType) {
        let pURL = prepareURLForResource(path: path)
        let headers: HTTPHeaders? = [.authorization(bearerToken: USER.shared.details?.token ?? "")]

        consoleLog("PATCH CALL : \(pURL)", parameters)
        AF.request(pURL,
                   method: .patch, parameters: parameters, encoding: JSONEncoding.default,
                   headers: headers)
            .responseJSON { response in
                if (response.response?.allHeaderFields as? [String: Any]) != nil {
                    if let newToken = response.response?.allHeaderFields["New-Token"] as? String {
                        USER.shared.details?.token = newToken
                    }
                }

                if let httpStatusCode = response.response?.statusCode {
                    let value = response.value as? NSDictionary

                    switch httpStatusCode {
                    // SUCCESS
                    case 200, 201, 204:
                        consoleLog("PATCH RESULT : \(pURL)", value as Any)
                        self.delegate?.requestFinished(responseData: value as Any, reqType: reqType)
                    case 403:
                        consoleLog("Un-Authorized User")
                        self.delegate?.requestFailed(data: nil, error: "Un-Authorized User", reqType: reqType)
                        USER.shared.logout()
                    // FAIL
                    default:
                        self.delegate?.requestFailed(data: value, error: nil, reqType: reqType)
                    }
                }
            }
    }
    func deleteRestApi(path: String, reqType: RequestType) {
        let pURL = prepareURLForResource(path: path)
        let guestHeaders: HTTPHeaders? = [.authorization(bearerToken: USER.shared.details?.token ?? "")]

        consoleLog("Delete CALL : \(pURL)")
        AF.request(pURL,
                   method: .delete, encoding: URLEncoding.default,
                   headers: guestHeaders)
            .responseJSON { response in
                if (response.response?.allHeaderFields as? [String: Any]) != nil {
                    if let newToken = response.response?.allHeaderFields["New-Token"] as? String {
                        USER.shared.details?.token = newToken
                    }
                }

                if let httpStatusCode = response.response?.statusCode {
                    let value = response.value as? NSDictionary

                    switch httpStatusCode {
                    // SUCCESS

                    case 200, 201, 204:
                        consoleLog("PATCH RESULT : \(pURL)", value as Any)
                        self.delegate?.requestFinished(responseData: value as Any, reqType: reqType)
                    case 403:
                        consoleLog("Un-Authorized User")
                        self.delegate?.requestFailed(data: nil, error: "Un-Authorized User", reqType: reqType)
                        USER.shared.logout()
                    // FAIL
                    default:
                        self.delegate?.requestFailed(data: value, error: nil, reqType: reqType)
                }
            }
            }
    }
}
typealias Parameters = [String: Any]
