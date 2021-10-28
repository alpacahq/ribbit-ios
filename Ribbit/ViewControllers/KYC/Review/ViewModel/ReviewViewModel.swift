//
//  ReviewViewModel.swift
//  Ribbit
//
//  Created by Ahsan Ali on 09/04/2021.
//

import UIKit

class ReviewViewModel: BaseViewModel {
    var bindStartOverViewModelToController: (() -> Void) = {}
    private(set) var success: Bool! {
        didSet {
            self.bindViewModelToController()
        }
    }
    private var startOverFlag = false

    override init() {
        super.init()
        proxy = NetworkProxy()
        proxy.delegate = self
    }

    func sign() {
        proxy.requestForSign()
    }

    private func complete() {
        proxy.requestForUpdateProfile(param: ["profile_completion": STEPS.complete.rawValue])
    }

    func startOver() {
        startOverFlag = true
        proxy.requestForUpdateProfile(param: ["profile_completion": ""])
    }
    // MARK: - Delegate
    override func requestDidBegin() {
        super.requestDidBegin()
    }

    override func requestDidFinishedWithData(data: Any, reqType: RequestType) {
        super.requestDidFinishedWithData(data: data, reqType: reqType)

        if startOverFlag {
            startOverFlag = false
            bindStartOverViewModelToController()
        } else {
            if reqType == .sign {
                if let model = data as? ErrorModel, let msg = model.message {
                    self.bindErrorViewModelToController(msg)
                } else {
                    complete()
                }
            } else {
                success = true
            }
        }
    }

    override func requestDidFailedWithError(error: String, reqType: RequestType) {
        super.requestDidFailedWithError(error: error, reqType: reqType)
        self.bindErrorViewModelToController(error) // If need error in View Controller
    }
}
