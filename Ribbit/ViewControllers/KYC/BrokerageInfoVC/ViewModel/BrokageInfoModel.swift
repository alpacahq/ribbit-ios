//
//  BrokageInfoModel.swift
//  Ribbit
//
//  Created by Rao Mudassar on 30/06/2021.
//

import UIKit

class BrokageInfoModel: BaseViewModel {
    private(set) var success: Bool! {
        didSet {
            self.bindViewModelToController()
        }
    }

    init(companyName: String, person: String, relation: String) {
        super.init()

        proxy = NetworkProxy()
        proxy.delegate = self

        proxy.requestForUpdateProfile(param: ["brokerage_firm_name": companyName, "brokerage_firm_employee_name": person, "brokerage_firm_employee_relationship": relation, "profile_completion": STEPS.brokerage.rawValue])
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
