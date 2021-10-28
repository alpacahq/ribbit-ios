//
//  StockerTickerViewController.swift
//  Ribbit
//
//  Created by Rao Mudassar on 08/07/2021.

// MARK: - Search assest screen

import Alamofire
import UIKit

class StockerTickerViewController: UIViewController {
    // MARK: - Datasoure
    var stocksArray: NSMutableArray = []
    // MARK: - Outlets
    @IBOutlet var searchText: UITextField!
    @IBOutlet var tableView: UITableView!
    private  let loader: Loader = .fromNib()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.searchText.text = ""
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        let yourBackImage = UIImage(named: "backGray")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.getStocks(str: self.searchText.text ?? "")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    // MARK: - IBActions
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - call api layers
    func getStocks(str: String) {
        let url = EndPoint.kServerBase + EndPoint.Assests + "/?q="+str
        print(url)
        NetworkUtil.request(apiMethod: url, parameters: nil, requestType: .get, showProgress: true, view: self.view, onSuccess: { resp -> Void in
            self.stocksArray = []
            print(resp!)

            if let jsonObject = resp as? [[String: Any]] {
                self.stocksArray = SwiftParseUtils.parseAssestsData(object: jsonObject, view: self.view)
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            } else {
                self.view.makeToast("Server Error")
            }
            print(self.stocksArray.count)
        }) { error in
            print(error)
            self.view.makeToast(error)
        }
    }
    func favStocks(isWatchlist: Bool, symbol: String, index: Int) {
        self.loader.setView(hasLoader: true)
        let indexPath = IndexPath(row: index, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? StockTickerCell ?? StockTickerCell()
        var httpMethod: HTTPMethod = .post
        var params = ["symbol": symbol] as [String: Any]
        var url = ""
        if cell.stockFav.currentBackgroundImage == UIImage(named: "favorite") {
            url = EndPoint.kServerBase + EndPoint.FavouriteAsset
            httpMethod = .post
        } else {
            url = EndPoint.kServerBase + EndPoint.unFavoutite
            url = url.replacingOccurrences(of: "{symbol}", with: symbol)
            httpMethod = .delete
            params = ["": ""]
        }
        print(url)
        print(params)
        NetworkUtil.request(apiMethod: url, parameters: params, requestType: httpMethod, showProgress: true, view: self.view, onSuccess: { resp -> Void in
            self.loader.removeFromSuperview()
            print(resp!)
            if cell.stockFav.currentBackgroundImage == UIImage(named: "favorite") {
                cell.stockFav.setBackgroundImage(UIImage(named: "heart"), for: .normal)
            } else {
                cell.stockFav.setBackgroundImage(UIImage(named: "favorite"), for: .normal)
            }
        }) { error in
            print(error)
            self.loader.removeFromSuperview()
            self.view.makeToast(error)
        }
    }
    @objc func connected(sender: UIButton) {
        let obj = self.stocksArray[sender.tag] as? StockTicker
        self.favStocks(isWatchlist: obj?.isWatchlisted ?? false, symbol: obj?.symbol ?? "", index: sender.tag)
    }
}
// MARK: - textfields delegate
extension StockerTickerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        self.getStocks(str: updatedText)
        return true
    }
}
// MARK: - Tableview delegates and datasource
extension StockerTickerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocksArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = stocksArray[indexPath.row] as? StockTicker
        let cell: StockTickerCell = self.tableView.dequeueReusableCell(withIdentifier: "cell01") as? StockTickerCell ?? StockTickerCell()
        cell.stockSymbol.text = obj?.symbol
        cell.stockOrg.text = obj?.name
        if obj?.isWatchlisted == false {
            cell.stockFav.setBackgroundImage(UIImage(named: "favorite"), for: .normal)
        } else {
            cell.stockFav.setBackgroundImage(UIImage(named: "heart"), for: .normal)
        }
        cell.stockFav.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        cell.stockFav.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = stocksArray[indexPath.row] as? StockTicker
        PortfolioRouter().route(to: BuySellVC.identifier, from: self, parameters: obj, animated: true)
    }
}
