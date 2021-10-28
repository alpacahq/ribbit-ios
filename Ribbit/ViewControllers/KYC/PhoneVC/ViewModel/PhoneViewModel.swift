//
//  PhoneViewModel.swift
//  Ribbit
//
//  Created by Ahsan Ali on 04/04/2021.
//

import Foundation
class PhoneViewModel: BaseViewModel {
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

    init(phone: String) {
        super.init()
        self.proxy = NetworkProxy()
        proxy.delegate = self
        proxy.requestForUpdateProfile(param: ["mobile": "+1\(phone)", "profile_completion": STEPS.phone.rawValue])
    }

    // MARK: - Delegate
    override func requestDidBegin() {
        super.requestDidBegin()
    }

    override func requestDidFinishedWithData(data: Any, reqType: RequestType) {
        super.requestDidFinishedWithData(data: data, reqType: reqType)
        self.success = true
    }

    override func requestDidFailedWithError(error: String, reqType: RequestType) {
        super.requestDidFailedWithError(error: error, reqType: reqType)
        self.bindErrorViewModelToController(error) // If need error in View Controller
    }
}
