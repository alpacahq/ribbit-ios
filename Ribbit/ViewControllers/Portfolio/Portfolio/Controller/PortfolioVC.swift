//
//  PortfolioVC.swift
//  Ribbit
//
//  Created by Ahsan Ali on 20/04/2021.

// MARK: - show user's portfolio data and graph

import Charts
import DSFSparkline
import InitialsImageView
import SDWebImageSVGCoder
import UIKit

class PortfolioVC: BaseVC {
    // MARK: - IBOutlets
    @IBOutlet var myFunds: UILabel!
    @IBOutlet var noStocks: UILabel!
    @IBOutlet var piechartView: LineChartView!
    @IBOutlet var backView: UIView!
    @IBOutlet var iDay: UIButton!
    @IBOutlet var iMonth: UIButton!

    var equity = [Double]()

    @IBOutlet var iWeek: UIButton!

    @IBOutlet var portfolioTV: UITableView! {
        didSet {
            portfolioTV.delegate = self
            portfolioTV.tableFooterView = UIView()
        }
    }
    @IBOutlet var totalValue: UILabel!
    private  let loader: Loader = .fromNib()
    var stocksArray: NSMutableArray = []
    var count: Double = 0.0
    var graphSum: Double = 0.0
    private var portfolioViewModel: PortfolioViewModel!
    private var dataSource: PortfolioTableViewDataSource<StockCell, String>!
    private var router: PortfolioRouter!
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        portfolioViewModel = PortfolioViewModel()
        updateDataSource()
        noStocks.alpha = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // portfolioViewModel.myStocks()
        count = 0.0
        self.getPositions()

        if UserDefaults.standard.string(forKey: "balance") == nil || UserDefaults.standard.string(forKey: "balance") == "" {
            self.myFunds.text = "$" + "0"
        } else {
            let currentRatio: Double! = Double(UserDefaults.standard.string(forKey: "balance") ?? "0.0")
            if currentRatio != nil {
                let str = String(format: "%.2f", currentRatio)
                self.myFunds.text = "$ \(str) USD"
            } else {
                self.myFunds.text = UserDefaults.standard.string(forKey: "balance")
            }
        }
        self.callApiPortFolioGraph(period: "1D", timeframe: "1Min")
        self.getportValue()
        self.iDay.setTitleColor(._715AFF, for: .normal)
        self.iWeek.setTitleColor(._92ACB5, for: .normal)
        self.iMonth.setTitleColor(._92ACB5, for: .normal)
    }

    // MARK: - Helpers
    func updateDataSource() {
        router = PortfolioRouter()
        self.totalValue.alpha = 0
    }
    private func setNavigation() {
        self.navigationController?.navigationBar.tintColor = ._92ACB5
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let yourBackImage = UIImage(named: "backGray")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    }

    @objc func transactionScreen() {
        router.route(to: TransactionsVC.identifier, from: self, parameters: nil, animated: true)
    }

    // MARK: - call api layers

    func getPositions() {
        self.portfolioTV.alpha = 1
        let url = EndPoint.kServerBase + EndPoint.positions
        print(url)
        NetworkUtil.request(apiMethod: url, parameters: nil, requestType: .get, showProgress: true, view: self.view, onSuccess: { resp -> Void in
            self.stocksArray = []
            self.loader.removeFromSuperview()
            print(resp!)
            if let jsonObject = resp as? [[String: Any]] {
                self.stocksArray = SwiftParseUtils.parsePositionListData(object: jsonObject, view: self.view)
            } else {
                self.noStocks.alpha = 1
                self.portfolioTV.alpha = 0
            }

            if self.stocksArray.count <= 0 {
                self.noStocks.alpha = 1
                self.portfolioTV.alpha = 0
            } else {
                self.noStocks.alpha = 0
                self.portfolioTV.alpha = 1
            }
            self.portfolioTV.delegate = self
            self.portfolioTV.dataSource = self
            self.portfolioTV.reloadData()
            print(self.stocksArray.count)
        }) { error in
            print(error)
            self.view.makeToast(error)
            self.loader.removeFromSuperview()
            self.noStocks.alpha = 1
            self.portfolioTV.alpha = 0
            self.portfolioTV.delegate = self
            self.portfolioTV.dataSource = self
            self.portfolioTV.reloadData()
        }
    }

    func getportValue() {
        loader.setView(hasLoader: true)
        let url = EndPoint.kServerBase + EndPoint.TradingView
        print(url)
        NetworkUtil.request(apiMethod: url, parameters: nil, requestType: .get, showProgress: true, view: self.view, onSuccess: { resp -> Void in
            self.stocksArray = []
            self.loader.removeFromSuperview()
            print(resp!)
            if let jsonObject = resp as? [String: Any] {
                let value = Double(jsonObject["portfolio_value"] as? String ?? "0000") ?? 0.0
                let str = String(format: "%.2f", value)
                let str1 = "$" + str
                if value <= 0 {
                    self.totalValue.alpha = 0
                    UserDefaults.standard.setValue("$0", forKey: "totalValue")
                } else {
                    self.totalValue.alpha = 1
                    self.totalValue.text = str1
                    UserDefaults.standard.setValue(self.totalValue.text, forKey: "totalValue")
                }
            } else {
                self.view.makeToast("Server Error")
            }
        }) { error in
            print(error)
            self.view.makeToast(error)
            self.loader.removeFromSuperview()
        }
    }
    @IBAction func addFunds(_ sender: Any) {
        if USER.shared.accountAdded {
            TransactionRouter().route(to: AddFundVC.identifier, from: self, parameters: nil, animated: true)
        } else {
            TransactionRouter().route(to: PlaidIntroVC.identifier, from: self, parameters: nil, animated: true)
        }
    }
    @IBAction func day(_ sender: Any) {
        self.iDay.setTitleColor(._715AFF, for: .normal)
        self.iWeek.setTitleColor(._92ACB5, for: .normal)
        self.iMonth.setTitleColor(._92ACB5, for: .normal)
        self.callApiPortFolioGraph(period: "1D", timeframe: "1Min")
    }

    @IBAction func week(_ sender: Any) {
        self.iDay.setTitleColor(._92ACB5, for: .normal)
        self.iWeek.setTitleColor(._715AFF, for: .normal)
        self.iMonth.setTitleColor(._92ACB5, for: .normal)
        self.callApiPortFolioGraph(period: "1W", timeframe: "1H")
    }

    @IBAction func month(_ sender: Any) {
        self.iDay.setTitleColor(._92ACB5, for: .normal)
        self.iWeek.setTitleColor(._92ACB5, for: .normal)
        self.iMonth.setTitleColor(._715AFF, for: .normal)
        self.callApiPortFolioGraph(period: "1M", timeframe: "1D")
    }

    func callApiPortFolioGraph(period: String, timeframe: String) {
        loader.setView(hasLoader: true)
        let url = EndPoint.kServerBase + EndPoint.ordrHistory + "?timeframe="+timeframe + "&period="+period
        let params = ["period": period, "timeframe": timeframe] as [String: Any]
        print(url)
        print(params)

        NetworkUtil.request(apiMethod: url, parameters: nil, requestType: .get, showProgress: true, view: self.view, onSuccess: { resp -> Void in
            self.loader.removeFromSuperview()
            print(resp!)
            self.equity.removeAll()
            self.graphSum = 0.0
            if let object = resp as? [String: Any] {
                if let equity = object["equity"] as? NSArray {
                    for index in 0..<equity.count {
                        let value = Double(exactly: equity[index] as? NSNumber ?? 0_000)
                        self.graphSum += self.graphSum + (value ?? 0.0)
                        self.equity.append(value ?? 0.0)
                    }
                }
            } else {
                if let message = resp as? NSDictionary {
                    let message1 = message["message"] as? String
                    self.view.makeToast(message1)
                }
            }
            print(self.equity.count)
            if self.graphSum > 0 {
                SwiftParseUtils.parsePortfolioSecondData(object: self.equity, view: self.view, graph: self.piechartView)
            }

            self.getPositions()
        }) { error in
            print(error)
            self.getPositions()
            self.loader.removeFromSuperview()
            self.view.makeToast(error)
        }
    }
}
// MARK: - tableview delegate and datasource
extension PortfolioVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocksArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = stocksArray[indexPath.row] as? MyStock

        let cell: StockCell = self.portfolioTV.dequeueReusableCell(withIdentifier: "StockCell")! as? StockCell ?? StockCell()
        let mve = Double(obj?.marketValue ?? "0.123456") ?? 0.123_456

        let doubleMV = String(format: "%.2f", mve)
        cell.stockPrice.text = "$" + doubleMV
        cell.stockSymbol.text = obj?.symbol
        cell.stockCompany.text = obj?.exchange

        let plpc = Double(obj?.unrealizedPlpc ?? "0.123456")
        let plp = Double(obj?.unrealizedPl ?? "0.123456")!

        if plpc! < 0 {
            cell.stockGraph.image = UIImage(named: "negativ")
            cell.arrowSign.image = UIImage(named: "downArrow")
            let doubleStr = String(format: "%.2f", plp)
            cell.stockPer.text = "$" + doubleStr
            cell.stockPer.textColor = UIColor(named: "DownColor")
        } else {
            cell.stockGraph.image = UIImage(named: "Vector-1")
            cell.arrowSign.image = UIImage(named: "arrow_drop_up")
            let doubleStr = String(format: "%.2f", plp)
            cell.stockPer.text = "$" + doubleStr
            cell.stockPer.textColor = UIColor.green
            cell.stockPer.textColor = UIColor(named: "UpColor")
        }

        cell.stockImg.setImageForName(obj?.symbol ?? "GOOG", backgroundColor: nil, circular: true, textAttributes: nil)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.stocksArray.count > 0 {
            let obj = stocksArray[indexPath.row] as? MyStock
            let mve = Double(obj?.marketValue ?? "0.123456") ?? 0.123_456
            let doubleMV = String(format: "%.2f", mve)
            let plp = Double(obj?.unrealizedPl ?? "0.123456")!
            let doublepl = String(format: "%.2f", plp)
            let object = StockTicker(ids: obj?.assetId ?? "", symbol: obj?.symbol ?? "", name: obj?.exchange ?? "", status: "", price: doubleMV, plp: doublepl, open: obj?.open ?? "0", high: obj?.high ?? "0", low: obj?.low ?? "0", volume: obj?.volume ?? "0", isWatchlisted: obj?.costBasis ?? false)
            PortfolioRouter().route(to: BuySellVC.identifier, from: self, parameters: object, animated: true)
        }
    }
}
