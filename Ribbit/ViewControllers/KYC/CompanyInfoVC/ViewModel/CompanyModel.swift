//
//  CompanyModel.swift
//  Ribbit
//
//  Created by Rao Mudassar on 30/06/2021.
//

import UIKit

class CompanyModel: BaseViewModel {
    private(set) var success: Bool! {
        didSet {
            self.bindViewModelToController()
        }
    }
    init(companyName: String, stockSymbol: String) {
        super.init()

        proxy = NetworkProxy()
        proxy.delegate = self

        proxy.requestForUpdateProfile(param: ["shareholder_company_name": companyName, "stock_symbol": stockSymbol, "profile_completion": STEPS.shareholder.rawValue])
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
