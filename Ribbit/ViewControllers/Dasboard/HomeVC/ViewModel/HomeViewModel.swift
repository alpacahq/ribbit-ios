//
// HomeViewModel.swift
// Ribbit
//
// Created by Ahsan Ali on 24/05/2021.
//
import UIKit
class HomeViewModel: BaseViewModel {
    var bindStatsViewModelToController: ((Int, Int) -> Void) = { _, _  in }
    override init() {
        super.init()
        proxy = NetworkProxy()
        proxy.delegate = self
    }

    func recipientBank() {
        proxy.requestForRecipientBanks()
    }

    func shareableLink() {
        proxy.requestForShareableLink()
    }

    func stats() {
        proxy.requestForStats()
    }

    // MARK: - Delegate
    override func requestDidBegin() {
        super.requestDidBegin()
    }

    override func requestDidFinishedWithData(data: Any, reqType: RequestType) {
        super.requestDidFinishedWithData(data: data, reqType: reqType)

        switch reqType {
        case .shareableLink:

            if let item = data as? (String, String) {
                USER.shared.sharelink = item.0
                USER.shared.code = item.1
            }

        case .stats:
            if let res = data as? (Int, Int) {
                bindStatsViewModelToController(res.0, res.1)
            }

        default:
            if let res = data as? [PlaidAccount], let item = res.first {
                USER.shared.accountDetail = item
                bindViewModelToController()
            }
        }
    }
    override func requestDidFailedWithError(error: String, reqType: RequestType) {
        super.requestDidFailedWithError(error: error, reqType: reqType)
        self.bindErrorViewModelToController(error) // If need error in View Controller
    }
}
