//
//  AddFundVC.swift
//  Ribbit
//
//  Created by Ahsan Ali on 30/04/2021.
//

import SSSpinnerButton
import TweeTextField
import UIKit
class AddFundVC: BaseVC {
    // MARK: - Outlets
    @IBOutlet var txtAmount: TweeAttributedTextField!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblbalance: UILabel!
    @IBOutlet var lblAccountNumber: UILabel!
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }

    // MARK: - Vars
    private let funds = ["25", "50", "100", "500"]
    private var  VM = AddFundViewModel()
    private var time  = ""

    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = USER.shared.accountDetail?.nickname, let number = USER.shared.accountDetail?.bank_account_number {
            self.lblName.text = name
            let codedNum = "****\(String(number.suffix(4)))"
            self.lblAccountNumber.text = "Account \(codedNum)"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtAmount.text = ""
        VM.getTotalBalance()
        VM.balance = { amount in
            self.lblbalance.text = "Available $\(amount)"
        }
    }

    // MARK: - Actions

    @IBAction func AddFundsPressed(_ sender: SSSpinnerButton) {
        txtAmount.showInfo("")

        if let errorMsg = Validator().validate(text: txtAmount.text!, with: [.notEmpty]) {
            txtAmount.showInfo(errorMsg)
            return
        }

        self.VM.sender = sender
        sender.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: {
            self.VM.deposit(amount: self.txtAmount.text!)
            sender.stopAnimate(complete: nil)
            self.VM.bindTimeViewModelToController = { time, status in
                AddFundRouter().route(to: FundsAddedVC.identifier, from: self, parameters: ["amount": self.txtAmount.text!, "time": time, "status": status], animated: true)
            }
        })
    }

    @IBAction func Remove(_ sender: Any) {
        let popup: DeleteBankView = .fromNib()
        popup.setView()
        popup.removed = {
            self.view.makeToast("Account has been removed successfully!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.popViewController()
            }
        }
        UIApplication.shared.windows.first!.addSubview(popup)
    }
}

extension AddFundVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        funds.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FundsCell.identifier, for: indexPath) as? FundsCell else {
            return UICollectionViewCell()
        }
        cell.lblAmount.text = "+$\(funds[indexPath.row])"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        txtAmount.showInfo("")
        txtAmount.text = funds[indexPath.row]
    }
}

extension AddFundVC: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
