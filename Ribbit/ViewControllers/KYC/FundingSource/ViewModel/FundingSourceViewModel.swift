//
//  FundingSourceViewModel.swift
//  Ribbit
//
//  Created by Ahsan Ali on 04/05/2021.
//

import UIKit

class FundingSourceViewModel: BaseViewModel {
    private(set) var success: Bool! {
        didSet {
            self.bindViewModelToController()
        }
    }
    init(fundingSource: String) {
        super.init()
        print(fundingSource)
        proxy = NetworkProxy()
        proxy.delegate = self
        proxy.requestForUpdateProfile(param: ["funding_source": fundingSource, "profile_completion": STEPS.funding.rawValue])
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
