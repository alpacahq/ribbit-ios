//
//  ReferelViewModel.swift
//  Ribbit
//
//  Created by Ahsan Ali on 03/06/2021.
//

import UIKit

class ReferelViewModel: BaseViewModel {
    var refrelBinded: ((_ msg: String) -> Void)?

    override init() {
        super.init()
        proxy = NetworkProxy()
        proxy.delegate = self
    }

    func sendReferel(code: String) {
        proxy.sendReferel(code: code)
    }

    func skipReffrel() {
        proxy.requestForUpdateProfile(param: ["profile_completion": STEPS.referral.rawValue])
    }
    // MARK: - Delegate
    override func requestDidBegin() {
        super.requestDidBegin()
    }

    override func requestDidFinishedWithData(data: Any, reqType: RequestType) {
        super.requestDidFinishedWithData(data: data, reqType: reqType)
        switch reqType {
        case .referelCode:
            if let str = data as? String {
                refrelBinded!(str)
            }
        default:
            bindViewModelToController()
        }
    }
    override func requestDidFailedWithError(error: String, reqType: RequestType) {
        super.requestDidFailedWithError(error: error, reqType: reqType)
        self.bindErrorViewModelToController(error) // If need error in View Controller
    }
}
