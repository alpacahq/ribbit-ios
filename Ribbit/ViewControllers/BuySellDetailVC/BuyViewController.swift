//
//  BuyViewController.swift
//  Ribbit
//
//  Created by Rao Mudassar on 04/08/2021.

// MARK: - Buysell info and sale purchase interface

import InitialsImageView
import UIKit

class BuyViewController: BaseVC {
    // MARK: - IBOutlets
    @IBOutlet var lblCompanyname: UILabel!
    @IBOutlet var compimage: UIImageView!
    @IBOutlet var lblSymbol: UILabel!
    @IBOutlet var compPrice: UILabel!
    @IBOutlet var fundLbl: UILabel!
    @IBOutlet var lblQuantity: UITextField!
    @IBOutlet var txtPrice: UITextField!
    @IBOutlet var lblMarket: UILabel!
    @IBOutlet var lblLimt: UILabel!
    @IBOutlet var btnBuy: UIButton!
    @IBOutlet var btnSell: UIButton!
    @IBOutlet var buyline: UIView!
    @IBOutlet var sellLine: UIView!
    @IBOutlet var btnSwitch: UISwitch!
    @IBOutlet var fundView: UIView!
    @IBOutlet var btnBuyy: UIButton!
    private  let loader: Loader = .fromNib()
    private var vModel: BuySellViweModel!
    // MARK: - Variables
    var object: StockTicker?
    var symbol: String = "GOOG"
    var quantity: Double = 1
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.symbol = object?.symbol ?? "GOOG"
        self.lblSymbol.text = object?.symbol ?? "AAPL"
        self.lblCompanyname.text = object?.name ?? "Apple Inc"
        self.compimage.setImageForName(self.symbol, backgroundColor: nil, circular: true, textAttributes: nil)
        let price: String = object?.price ?? "0.0"
        self.compPrice.text = "$ " + price
        if UserDefaults.standard.string(forKey: "balance") == nil || UserDefaults.standard.string(forKey: "balance") == "" {
            self.fundLbl.text = "$" + "0"
        } else {
            let currentRatio: Double! = Double(UserDefaults.standard.string(forKey: "balance") ?? "0.0")
            if currentRatio != nil {
                let str = String(format: "%.2f", currentRatio)
                self.fundLbl.text = "$ \(str) USD"
            } else {
                self.fundLbl.text = UserDefaults.standard.string(forKey: "balance")
            }
        }
        self.lblQuantity.text = String(self.quantity)
        let morePrecisePI = Double(object?.price ?? "100") ?? 100
        let value: Double = self.quantity * morePrecisePI
        let str = String(format: "%.2f", value)
        self.txtPrice.text = str
        self.setNavigation()
    }
    private func setNavigation() {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = ._92ACB5
        let title = UserDefaults.standard.string(forKey: "Buy")
        if title == "Buy" {
            self.navigationItem.setTitle("Purchase Stock", subtitle: "")
            self.txtPrice.isUserInteractionEnabled = true
            self.fundView.alpha = 1
            self.btnBuyy.setTitle("Buy " + self.symbol, for: .normal)
            buyline.alpha = 1
            sellLine.alpha = 0
            btnBuy.backgroundColor = .white
            btnSell.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9725490196, blue: 0.9843137255, alpha: 1)
        } else {
            self.navigationItem.setTitle("Sell Stock", subtitle: "")
            self.fundView.alpha = 0
            self.btnBuyy.setTitle("Sell " + self.symbol, for: .normal)
            self.txtPrice.isUserInteractionEnabled = true
            btnBuy.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9725490196, blue: 0.9843137255, alpha: 1)
            btnSell.backgroundColor =  .white
            buyline.alpha = 0
            sellLine.alpha = 1
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    // MARK: - IBActions
    @IBAction func plus(_ sender: Any) {
        self.quantity += self.quantity + 1
        self.lblQuantity.text = String(self.quantity)
        let morePrecisePI = Double(object?.price ?? "100") ?? 100
        let value: Double = self.quantity * morePrecisePI
        let str = String(format: "%.2f", value)
        self.txtPrice.text = str
    }
    @IBAction func minus(_ sender: Any) {
        if self.quantity >= 1 {
            self.quantity += self.quantity - 1
            self.lblQuantity.text = String(self.quantity)
            let morePrecisePI = Double(object?.price ?? "100") ?? 100
            let value: Double = self.quantity * morePrecisePI
            let str = String(format: "%.2f", value)
            self.txtPrice.text = str
        }
    }
    @IBAction func addFunds(_ sender: Any) {
        if USER.shared.accountAdded {
            TransactionRouter().route(to: AddFundVC.identifier, from: self, parameters: nil, animated: true)
        } else {
            TransactionRouter().route(to: PlaidIntroVC.identifier, from: self, parameters: nil, animated: true)
        }
    }
    @IBAction func buyStock(_ sender: UIButton) {
        if sender.tag == 0 {
            self.navigationItem.setTitle("Purchase Stock", subtitle: "")
            self.fundView.alpha = 1
            self.btnBuyy.setTitle("Buy " + self.symbol, for: .normal)
            buyline.alpha = 1
            sellLine.alpha = 0
            btnBuy.backgroundColor = .white
            btnSell.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9725490196, blue: 0.9843137255, alpha: 1)
        } else {
            self.navigationItem.setTitle("Sell Stock", subtitle: "")
            self.fundView.alpha = 0
            self.btnBuyy.setTitle("Sell " + self.symbol, for: .normal)
            btnBuy.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9725490196, blue: 0.9843137255, alpha: 1)
            btnSell.backgroundColor =  .white
            buyline.alpha = 0
            sellLine.alpha = 1
        }
    }
    @IBAction func buyShare(_ sender: Any) {
        self.loader.setView(hasLoader: true)
        if btnBuyy.title(for: .normal) == "Buy " + self.symbol {
            self.callApi(side: "buy")
        } else {
            self.callApi(side: "sell")
        }
    }
    // MARK: - Call api layers
    func callApi(side: String) {
        let url = EndPoint.kServerBase + EndPoint.Order
        let params = ["symbol": self.symbol, "notional": self.txtPrice.text ?? "100", "side": side, "type": "market", "time_in_force": "day"] as [String: Any]
        print(url)
        print(params)
        NetworkUtil.request(apiMethod: url, parameters: params, requestType: .post, showProgress: true, view: self.view, onSuccess: { resp -> Void in
            self.loader.removeFromSuperview()
            print(resp!)
            if (resp as? [String: Any]) != nil {
                let dict = resp as? NSDictionary
                if let msg = dict?["message"] as? String {
                    self.view.makeToast(msg)
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                self.view.makeToast("Server Error")
            }
        }) { error in
            print(error)
            self.loader.removeFromSuperview()
            self.view.makeToast(error)
        }
    }

    @IBAction func changeSwitch(_ sender: UISwitch) {
        if sender.isOn == true {
            self.lblMarket.textColor = ._92ACB5
            self.lblLimt.textColor = UIColor.black
            self.txtPrice.isUserInteractionEnabled = true
        } else {
            self.lblMarket.textColor = .black
            self.lblLimt.textColor = ._92ACB5
            self.txtPrice.isUserInteractionEnabled = true
        }
    }
}
// MARK: - Textfield dalegate
extension BuyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPrice {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            if updatedText != "" || updatedText != "0" {
                if let cost = Double(updatedText) {
                    print("The user entered a value price of \(cost)")
                    let oneStock = Double(object?.price ?? "1") ?? 1.0
                    let result = cost / oneStock
                    self.lblQuantity.text = String(format: "%.2f", result)
                } else {
                    self.lblQuantity.text = ""
                    self.txtPrice.text = ""
                }
            } else {
                self.lblQuantity.text = ""
                self.txtPrice.text = ""
            }
            return true
        } else {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            if updatedText != "" || updatedText != "0" {
                if let cost = Double(updatedText) {
                    print("The user entered a value price of \(cost)")
                    let oneStock = Double(object?.price ?? "1") ?? 1.0
                    let result = cost * oneStock
                    self.txtPrice.text = String(format: "%.2f", result)
                } else {
                    self.txtPrice.text = ""
                    self.lblQuantity.text = ""
                }
            } else {
                self.lblQuantity.text = ""
                self.txtPrice.text = ""
            }
            return true
        }
    }
}
