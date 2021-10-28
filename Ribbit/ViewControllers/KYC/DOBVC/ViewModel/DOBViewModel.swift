//
// DOBViewModel.swift
// Ribbit
//
// Created by Ahsan Ali on 04/04/2021.
//

import Foundation
class DOBViewModel: BaseViewModel {
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

    init(dob: String) {
        super.init()
        self.proxy = NetworkProxy()
        proxy.delegate = self
        proxy.requestForUpdateProfile(param: ["dob": dob, "profile_completion": STEPS.dob.rawValue])
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
