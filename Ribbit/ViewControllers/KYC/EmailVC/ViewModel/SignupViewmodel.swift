//
//  SignupViewmodel.swift
//  Ribbit
//
//  Created by Ahsan Ali on 01/04/2021.
//

import Foundation
class SignupViewModel: BaseViewModel {
    // MARK: - Variables

    private(set) var success: Bool! {
        didSet {
            self.bindViewModelToController()
        }
    }
    // MARK: - Cycle
    override init() {
        super.init()
    }
    init(email: String, password: String, isLogin: Bool) {
        super.init()
        self.proxy = NetworkProxy()
        proxy.delegate = self
        if isLogin == false {
            proxy.requestForSignUp(email: email, password: password)
        } else {
            proxy.requestForLogin(email: email, password: password)
        }
    }
    // MARK: - Delegate
    override func requestDidBegin() {
        super.requestDidBegin()
    }

    override func requestDidFinishedWithData(data: Any, reqType: RequestType) {
        super.requestDidFinishedWithData(data: data, reqType: reqType)
        if let data = data as? Signup {
            USER.shared.saveUser(detail: data)
            self.success = true
        }
    }
    override func requestDidFailedWithError(error: String, reqType: RequestType) {
        super.requestDidFailedWithError(error: error, reqType: reqType)
        self.bindErrorViewModelToController(error) // If need error in View Controller
    }
}
