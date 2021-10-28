//
//  TransactionsVC.swift
//  Ribbit
//
//  Created by Ahsan Ali on 19/05/2021.

// MARK: - Show transactions list

import SSSpinnerButton
import UIKit
class TransactionsVC: BaseVC {
    // MARK: - Outlets
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var lblAccountNo: UILabel!
    @IBOutlet var lblBal: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblNoData: UILabel!
    @IBOutlet var changeBank: UIButton!
    // MARK: - Vars
    private var transactionViewModel: TransactionViewModel!
    private let transactionRouter = TransactionRouter()
    // MARK: - Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        Addobservers()
        setNavigation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTransactions()
        setNavigation()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    // MARK: - Actions
    @IBAction func DeleteBank(_ sender: Any) {
        let popup: DeleteBankView = .fromNib()
        popup.setView()
        popup.removed = {
            self.setView()
            self.view.makeToast("Account has been removed successfully!")
        }
        UIApplication.shared.windows.first!.addSubview(popup)
    }

    private func Addobservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.bankDisConnectedFunc),
            name: Notification.bankDisConnected,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.bankConnectedFunc),
            name: Notification.bankConnected,
            object: nil)
    }
    @objc func bankConnectedFunc() {
        setView()
    }

    @objc func bankDisConnectedFunc() {
        setView()
    }
    @IBAction func AddFunds(_ sender: Any) {
        if USER.shared.accountAdded {
            transactionRouter.route(to: AddFundVC.identifier, from: self, parameters: nil, animated: true)
        } else {
            transactionRouter.route(to: PlaidIntroVC.identifier, from: self, parameters: nil, animated: true)
        }
    }
    // MARK: - Helpers
    private func setView() {
        if let name = USER.shared.accountDetail?.nickname, let number = USER.shared.accountDetail?.bank_account_number, number != "" {
            let codedNum = "****\(String(number.suffix(4)))"
            self.lblAccountNo.text = codedNum
            lblName.text = name
            lblName.isHidden = false
            lblAccountNo.isHidden = false
            self.btnDelete.backgroundColor = UIColor(named: "ACAAFF")
            self.btnDelete.setTitleColor(UIColor(named: "715AFF"), for: .normal)
            btnDelete.isUserInteractionEnabled = true
        } else {
            lblName.isHidden = true
            lblAccountNo.isHidden = true
            self.btnDelete.backgroundColor = UIColor.lightGray
            self.btnDelete.setTitleColor(UIColor.gray, for: .normal)
            btnDelete.isUserInteractionEnabled = false
        }
    }
    private func getTransactions() {
        transactionViewModel = TransactionViewModel()
        let loader: Loader = .fromNib()
        loader.setView(hasLoader: true)
        transactionViewModel.getTransactions()
        transactionViewModel.getTotalBalance()
        UserDefaults.standard.setValue("$0", forKey: "balance")
        transactionViewModel.balance = { amount in
            let currentRatio: Double! = Double(amount)
            let str = String(format: "%.2f", currentRatio)
            self.lblBal.text = "$ \(str) USD"
            UserDefaults.standard.setValue(str, forKey: "balance")
        }
        transactionViewModel.bindTransactionViewModelToController = {
            loader.removeFromSuperview()
            self.lblNoData.isHidden = self.transactionViewModel.transactions.count > 0
            self.tableView.isHidden = !self.lblNoData.isHidden
            self.tableView.reloadData()
        }
    }
    private func setNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let yourBackImage = UIImage(named: "backGray")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    }
    func convertDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return  dateFormatter.string(from: date!)
    }
}

// MARK: - Tableview delegate and datasource

extension TransactionsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.transactionViewModel.transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.identifier, for: indexPath) as! TransactionCell
        let date = self.convertDateFormater(transactionViewModel.transactions[indexPath.row].created_at)
        cell.lblTitle.text = date
        cell.lblSubTitle.text = transactionViewModel.transactions[indexPath.row].subTitle
        cell.lblAmount.text = transactionViewModel.transactions[indexPath.row].amountStr
        let isCredit = transactionViewModel.transactions[indexPath.row].isCredit
        cell.icon.image = isCredit ?  #imageLiteral(resourceName: "credit") :  #imageLiteral(resourceName: "debit")
        if transactionViewModel.transactions[indexPath.row].status == "CANCELED"{
            cell.lblSubTitle.text = "Funds Canceled"
            cell.lblSubTitle.textColor = .red
        } else {
            cell.lblSubTitle.textColor = UIColor(red: 208 / 255, green: 210 / 255, blue: 211 / 255, alpha: 1.0)
            cell.lblSubTitle.text = transactionViewModel.transactions[indexPath.row].subTitle
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = transactionViewModel.transactions[indexPath.row]
        transactionRouter.route(to: FundsAddedVC.identifier, from: self, parameters: ["amount": item.amount, "time": item.created_at.formattedTime, "status": item.status], animated: true)
    }
}
