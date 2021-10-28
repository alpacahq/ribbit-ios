//
//  NameViewModel.swift
//  Ribbit
//
//  Created by Ahsan Ali on 02/04/2021.
//

import Foundation
class NameViewModel: BaseViewModel {
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
    init(firstName: String, lastName: String) {
        super.init()
        self.proxy = NetworkProxy()
        proxy.delegate = self
        proxy.requestForUpdateProfile(param: ["first_name": firstName, "last_name": lastName, "profile_completion": STEPS.name.rawValue])
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
