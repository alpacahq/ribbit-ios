//
// NetworkUtil.swift
// Created by Rao Mudassar on 18/06/2021.

import Alamofire
import Foundation
class NetworkUtil: NSObject {
    static let shared = NetworkUtil()
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }

    override private init() {}

    private func makeGetRequest(url: String) -> URLRequest? {
        guard let urlObj = URL(string: url) else { return nil }
        var request = URLRequest(url: urlObj)
        request.httpMethod = "GET"
        return request
    }
    private func makePOSTRequest(url: String, params: [String], paramURL: String) -> URLRequest? {
        guard let urlObj = URL(string: url) else { return nil }
        var request = URLRequest(url: urlObj)
        request.httpMethod = "POST"
        let paramString = paramURL.addParams(params: params)
        request.httpBody = paramString.data(using: String.Encoding.ascii, allowLossyConversion: false)
        return request
    }

    typealias SuccessHandler = ((Any?) -> Void)
    typealias ErrorHandler = (NSError?) -> Void

    class func request(apiMethod: String, parameters: Parameters?, requestType: HTTPMethod = .post, showProgress: Bool = false, encoding: ParameterEncoding = JSONEncoding.default, view: UIView? = nil, onSuccess: @escaping SuccessHandler, onFailure: @escaping (String) -> Void ) {
        let headers: HTTPHeaders? = [.authorization(bearerToken: USER.shared.details?.token ?? "")]
        consoleLog(USER.shared.details?.token ?? "")

        AF.request(apiMethod, method: requestType, parameters: parameters, encoding: encoding, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):

                if (response.response?.allHeaderFields as? [String: Any]) != nil {
                    if let newToken = response.response?.allHeaderFields["New-Token"] as? String {
                        USER.shared.details?.token = newToken
                    }
                }

                print(response.result)

                onSuccess(value)

            case .failure(let error):
                print(error)

                if let httpStatusCode = response.response?.statusCode {
                    switch httpStatusCode {
                    // SUCCESS
                    case 401, 403:
                        USER.shared.logout()
                    default:
                        print("No Expire")
                    }
                }

                if (response.response?.allHeaderFields as? [String: Any]) != nil {
                    if let newToken = response.response?.allHeaderFields["New-Token"] as? String {
                        USER.shared.details?.token = newToken
                    }
                }

                onFailure(error.localizedDescription)
            }
        }
    }

    class func requestWithOutHeaders(apiMethod: String, parameters: Parameters?, requestType: HTTPMethod = .post, showProgress: Bool = false, encoding: ParameterEncoding = JSONEncoding.default, view: UIView? = nil, onSuccess: @escaping SuccessHandler, onFailure: @escaping (String) -> Void ) {
        AF.request(apiMethod, method: requestType, parameters: parameters, encoding: encoding, headers: nil).responseJSON { response in
            switch response.result {
            case .success(let value):

                if (response.response?.allHeaderFields as? [String: Any]) != nil {
                    if let newToken = response.response?.allHeaderFields["New-Token"] as? String {
                        USER.shared.details?.token = newToken
                    }
                }
                onSuccess(value)

            case .failure(let error):
                print(error)

                if let httpStatusCode = response.response?.statusCode {
                    switch httpStatusCode {
                    // SUCCESS
                    case 401, 403:
                        USER.shared.logout()
                    default:
                        print("No Expire")
                    }
                }

                if (response.response?.allHeaderFields as? [String: Any]) != nil {
                    if let newToken = response.response?.allHeaderFields["New-Token"] as? String {
                        USER.shared.details?.token = newToken
                    }
                }
                onFailure(error.localizedDescription)
            }
        }
    }

    class func mulitiparts(apiMethod: String, serverImage: UIImage, parameters: [String: Any], requestType: HTTPMethod = .post, showProgress: Bool = false, encoding: ParameterEncoding = JSONEncoding.default, view: UIView? = nil, onSuccess: @escaping SuccessHandler, onFailure: @escaping (String) -> Void) {
        print(serverImage)
        let randomInt = Int.random(in: 1..<1_000)
        let headers: HTTPHeaders? = [.authorization(bearerToken: USER.shared.details?.token ?? "")]
        consoleLog(USER.shared.details?.token ?? "")

        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append((value as? String)?.data(using: String.Encoding.utf8) ?? Data(), withName: key)
            }

            guard let imgData = serverImage.jpegData(compressionQuality: 1) else { return }
            multipartFormData.append(imgData, withName: "file", fileName: "image" + String(randomInt) + ".jpeg", mimeType: "image/jpeg")
        }, to: URL(string: apiMethod)!, usingThreshold: UInt64(), method: .post, headers: headers).response { response in
            switch response.result {
            case .success(let value):

                if (response.response?.allHeaderFields as? [String: Any]) != nil {
                    if let newToken = response.response?.allHeaderFields["New-Token"] as? String {
                        USER.shared.details?.token = newToken
                    }
                }
                onSuccess(value)
            case .failure(let error):
                print(error)

                if let httpStatusCode = response.response?.statusCode {
                    switch httpStatusCode {
                    // SUCCESS
                    case 401, 403:
                        USER.shared.logout()
                    default:
                        print("No Expire")
                    }
                }

                if (response.response?.allHeaderFields as? [String: Any]) != nil {
                    if let newToken = response.response?.allHeaderFields["New-Token"] as? String {
                        USER.shared.details?.token = newToken
                    }
                }
                onFailure(error.localizedDescription)
            }
        }
    }
}
