//
// DeleteBankView.swift
// Ribbit
//
// Created by Ahsan Ali on 01/06/2021.

import SSSpinnerButton
import UIKit
class DeleteBankView: UIView {
    @IBOutlet var lblbank: UILabel!
    @IBOutlet var lblAccountNo: UILabel!
    private var transactionViewModel: TransactionViewModel!

    var removed: (() -> Void)?
    override  func awakeFromNib() {
        super.awakeFromNib()
        transactionViewModel = TransactionViewModel()
    }

    @IBAction func dismissPopUp(_ sender: Any) {
        removeFromSuperview()
    }

    func setView() {
        frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        if let name = USER.shared.accountDetail?.nickname {
       if let number = USER.shared.accountDetail?.bank_account_number {
            self.lblbank.text = name
            let codedNum = "****\(String(number.suffix(4)))"
            self.lblAccountNo.text = "Account \(codedNum)"
        }
    }
}

    @IBAction func remove(_ sender: SSSpinnerButton) {
        sender.startAnimate(spinnerType: SpinnerType.circleStrokeSpin,
        spinnercolor: UIColor.white, spinnerSize: 20, complete: {
            self.transactionViewModel.sender = sender
            self.transactionViewModel.detachBank()
            self.transactionViewModel.bindViewModelToController = {
                DispatchQueue.main.async {
                    USER.shared.accountAdded = false
                    USER.shared.accountDetail = nil

                    NotificationCenter.default.post(name: Notification.bankDisConnected, object: nil)
                    self.removeFromSuperview()
                    self.removed!()
                }
            }
        })
    }
}
