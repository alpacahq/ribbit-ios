//
//  ShareHolderViewModel.swift
//  Ribbit
//
//  Created by Ahsan Ali on 08/04/2021.
//

import UIKit

class ShareHolderViewModel: BaseViewModel {
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
        proxy.requestForUpdateProfile(param: ["public_shareholder": answere, "profile_completion": STEPS.shareholder.rawValue])
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
