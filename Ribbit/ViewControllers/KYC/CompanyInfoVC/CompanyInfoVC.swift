//
//  CompanyInfoVC.swift
//  Ribbit
//
//  Created by Rao Mudassar on 30/06/2021.
//

import SSSpinnerButton
import TweeTextField
import UIKit

class CompanyInfoVC: BaseVC {
    @IBOutlet var txtCompany: TweeAttributedTextField! {
        didSet {
            txtCompany.delegate = self
        }
    }
    @IBOutlet var txtStock: TweeAttributedTextField! {
        didSet {
            txtStock.delegate = self
        }
    }
    @IBOutlet var tablveiw: UITableView!
    private var companyViewModel: CompanyModel!
    @IBOutlet var btnContinue: SSSpinnerButton!
    var stocksArray: NSMutableArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataOnView()
    }
    @IBAction func continuePressed(_ sender: Any) {
        self.callToViewModelForUIUpdate(companyName: txtCompany.text!, stock: txtStock.text!)
    }
    private func callToViewModelForUIUpdate(companyName: String, stock: String) {
        btnContinue.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: nil)
        self.companyViewModel = CompanyModel(companyName: txtCompany.text!, stockSymbol: txtStock.text!)
        self.companyViewModel.bindViewModelToController = {
            self.btnContinue.stopAnimate(complete: nil)
            CompanyInfoRoute().route(to: BrokerageQuestionVC.identifier, from: self, parameters: nil, animated: true)
        }
        self.companyViewModel.bindErrorViewModelToController = { _ in
            self.btnContinue.stopAnimate(complete: nil)
        }
    }
    private func setDataOnView() {
        self.txtCompany.text = USER.shared.details?.user?.shareholderCompanyName
        self.txtStock.text = USER.shared.details?.user?.stockSymbol

        if !self.txtCompany.text!.isEmpty && !self.txtStock.text!.isEmpty {
            btnContinue.setBackground(enable: true)
        }
    }
    func getStocks(str: String) {
        let url = EndPoint.kServerBase + EndPoint.Assests + "/?q="+str
        print(url)
        NetworkUtil.request(apiMethod: url, parameters: nil, requestType: .get, showProgress: true, view: self.view, onSuccess: { resp -> Void in
            self.stocksArray = []
            print(resp!)
            if let jsonObject = resp as? [[String: Any]] {
                self.stocksArray = SwiftParseUtils.parseSearchStockData(object: jsonObject, view: self.view)
                self.tablveiw.delegate = self
                self.tablveiw.dataSource = self
                self.tablveiw.reloadData()
                if self.stocksArray.count >= 0 {
                    self.tablveiw.alpha = 1
                } else {
                    self.tablveiw.alpha = 0
                }
            } else {
                self.view.makeToast("Server Error")
            }
            print(self.stocksArray.count)
        }) { error in
            print(error)
            self.view.makeToast(error)
        }
    }
}
extension CompanyInfoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        let validator = Validator()
        if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty]) {
            txtStock.showInfo(errorMsg)
            btnContinue.setBackground(enable: false)
            if updatedText != "" {
                self.tablveiw.alpha = 1
                self.getStocks(str: updatedText)
            } else {
                self.getStocks(str: "0")
                self.tablveiw.alpha = 0
            }
        } else {
            btnContinue.setBackground(enable: true)
            txtStock.showInfo("")
            if updatedText != "" {
                self.tablveiw.alpha = 1
                self.getStocks(str: updatedText)
            } else {
                self.getStocks(str: "0")
                self.tablveiw.alpha = 0
            }
        }
        return true
    }
}
extension CompanyInfoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocksArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = stocksArray[indexPath.row] as? StockTicker
        let cell: UITableViewCell = self.tablveiw.dequeueReusableCell(withIdentifier: "cell01")!
        cell.textLabel?.text = obj?.symbol ?? "APPL"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = stocksArray[indexPath.row] as? StockTicker
        self.txtStock.text = obj?.symbol ?? "APPL"
        self.txtCompany.text = obj?.name ?? "Apple"
        self.tablveiw.alpha = 0
    }
}
