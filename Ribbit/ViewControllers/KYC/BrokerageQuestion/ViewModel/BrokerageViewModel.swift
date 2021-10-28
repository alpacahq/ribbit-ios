//
//  BrokerageViewModel.swift
//  Ribbit
//
//  Created by Ahsan Ali on 09/04/2021.
//

import UIKit

class BrokerageViewModel: BaseViewModel {
    private(set) var success: Bool! {
        didSet {
            self.bindViewModelToController()
        }
    }
    override init() {
        super.init()
        proxy = NetworkProxy()
        proxy.delegate = self
    }
    func update(answere: String) {
        proxy.requestForUpdateProfile(param: ["another_brokerage": answere, "profile_completion": STEPS.brokerage.rawValue])
    }
    // MARK: - Delegate
    override func requestDidBegin() {
        super.requestDidBegin()
    }

    override func requestDidFinishedWithData(data: Any, reqType: RequestType) {
        super.requestDidFinishedWithData(data: data, reqType: reqType)
        success = true
    }

    override func requestDidFailedWithError(error: String, reqType: RequestType) {
        super.requestDidFailedWithError(error: error, reqType: reqType)
        self.bindErrorViewModelToController(error) // If need error in View Controller
    }
}
