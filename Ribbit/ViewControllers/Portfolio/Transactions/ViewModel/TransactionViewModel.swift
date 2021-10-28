//
//  TransactionViewModel.swift
//  Ribbit
//
//  Created by Ahsan Ali on 20/05/2021.

import UIKit

class TransactionViewModel: BaseViewModel {
    var transactions = Transactions()
    var bindTransactionViewModelToController : (() -> Void) = {}
    var balance:((_ amount: String) -> Void)?

    override init() {
        super.init()
        proxy = NetworkProxy()
        proxy.delegate = self
    }

    func getTotalBalance() {
        proxy.requestForTotalAmountRem()
    }

    func getTransactions() {
        proxy.requestForTransfer()
    }

    func detachBank() {
        proxy.detachBank(bID: USER.shared.accountDetail?.id ?? "")
    }

    // MARK: - Delegate
    override func requestDidBegin() {
        super.requestDidBegin()
    }

    override func requestDidFinishedWithData(data: Any, reqType: RequestType) {
        super.requestDidFinishedWithData(data: data, reqType: reqType)

        switch reqType {
        case .detachBank:
            bindViewModelToController()
        case .tradingView :
            if let bal = data as? String {
                balance!(bal)
            }

        default:
            if let trans = data as? Transactions {
                self.transactions = trans
                bindTransactionViewModelToController()
            }
        }
    }

    override func requestDidFailedWithError(error: String, reqType: RequestType) {
        super.requestDidFailedWithError(error: error, reqType: reqType)
        self.bindErrorViewModelToController(error) // If need error in View Controller
    }
}
