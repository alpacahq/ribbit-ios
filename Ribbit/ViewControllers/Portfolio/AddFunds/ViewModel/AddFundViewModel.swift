//
//  AddFundViewModel.swift
//  Ribbit
//
//  Created by Ahsan Ali on 03/05/2021.
//

import UIKit

class AddFundViewModel: BaseViewModel {
    var bindAccountDetailViewModelToController: ((String, String) -> Void) = { _, _  in }
    var bindTimeViewModelToController: ((String, String) -> Void) = { _, _  in }
    var balance:((_ amount: String) -> Void)?
    private var bankid = ""

    override init() {
        super.init()
        proxy = NetworkProxy()
        proxy.delegate = self
    }
    func getTotalBalance() {
        proxy.requestForTotalAmountRem()
    }

    func deposit(amount: String) {
        proxy.requestForDeposit(bID: USER.shared.accountDetail?.id ?? "", amount: amount)
    }

    // MARK: - Delegate
    override func requestDidBegin() {
        super.requestDidBegin()
    }

    override func requestDidFinishedWithData(data: Any, reqType: RequestType) {
        super.requestDidFinishedWithData(data: data, reqType: reqType)
        switch reqType {
        //        case .recipientBanks:
        //            if let res =  Data as? [PlaidAccount] , let item = res.first{
        //                USER.shared.accountDetail = item
        //                bankid = item.id
        //                bindAccountDetailViewModelToController(item.nickname, item.bank_account_number)
        //            }
        case .tradingView :
            if let bal = data as? String {
                balance!(bal)
            }
        default:
            if let item = data as? DepositDetail {
                let time = item.updated_at.formattedTime
                let status = item.status
                bindTimeViewModelToController(time, status)
            }
        }
    }

    override func requestDidFailedWithError(error: String, reqType: RequestType) {
        super.requestDidFailedWithError(error: error, reqType: reqType)
        self.bindErrorViewModelToController(error) // If need error in View Controller
    }
}
