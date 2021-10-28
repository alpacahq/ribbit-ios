//
// HomeVC.swift
// Ribbit
//
// Created by Adnan Asghar on 3/22/21.

// MARK: - overview of portfolio,profile and watchlist data

import Charts
import InitialsImageView
import SDWebImage
import UIKit
class HomeVC: UIViewController {
    // MARK: - IBOutlets

    private  let loader: Loader = .fromNib()
    var stocksArray: NSMutableArray = []
    var equity = [Double]()
    var graphSum: Double = 0.0

    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }

    // MARK: - Variables

    var cellTypes: [CellType] = [.welcome, .bank, .favStockCell]
    private let viewModel = HomeViewModel()
    private var coinsInvite: (Int, Int)?

    private var bankConnected = false {
        didSet {
            DispatchQueue.main.async {
                if self.bankConnected {
                    USER.shared.accountAdded = true
                    self.cellTypes.remove(at: 1)
                    self.tableView.reloadData()
                }
            }
        }
    }
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        setupNavTitle()
        setupTab()
        viewModel.shareableLink()
        viewModel.recipientBank()
        viewModel.stats()
        viewModel.bindStatsViewModelToController = { rewards, inviteCount in
            self.coinsInvite = (rewards, inviteCount)
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
        viewModel.bindViewModelToController = {
            self.bankConnected = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.getportValue()
    }

    @IBAction func notifications(_ sender: Any) {
        HomeRouter().route(to: NotificationsVC.identifier, from: self, parameters: nil, animated: true)
    }

    // MARK: - Helpers
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.bankConnectedFunc),
            name: Notification.bankConnected,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.bankDisConnectedFunc),
            name: Notification.bankDisConnected,
            object: nil)
    }

    @objc func bankDisConnectedFunc() {
        USER.shared.accountAdded = false
        self.bankConnected = false
        cellTypes.insert(.bank, at: 1)
        tableView.reloadData()
    }

    @objc func bankConnectedFunc() {
        self.bankConnected = true
    }

    func setupNavTitle() {
        let yourBackImage = UIImage(named: "backGray")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        let navigationTitleView: NavigationTitleView = .fromNib()
        self.navigationItem.titleView = navigationTitleView
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    func setupTab() {
        self.tabBarController?.tabBar.unselectedItemTintColor = ._92ACB5
        self.tabBarController?.tabBar.backgroundImage = UIImage()
        self.tabBarController?.tabBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.backgroundColor = .white
    }

    @objc func connected(sender: UIButton) {
        HomeRouter().routeToSearch(to: HomeVC.identifier, from: self, parameters: nil, animated: true)
    }

    @IBAction func search(_ sender: Any) {
        HomeRouter().routeToSearch(to: HomeVC.identifier, from: self, parameters: nil, animated: true)
    }

    // MARK: - call api layers

    func getStocks() {
        loader.setView(hasLoader: true)
        let url = EndPoint.kServerBase + EndPoint.watchList
        print(url)
        NetworkUtil.request(apiMethod: url, parameters: nil, requestType: .get, showProgress: true, view: self.view, onSuccess: { resp -> Void in
            self.stocksArray = []
            self.loader.removeFromSuperview()
            print(resp!)

            if let jsonObject = resp as? [String: Any] {
                self.stocksArray = SwiftParseUtils.parseWatchListData(object: jsonObject, view: self.view)
            } else {
                self.view.makeToast("Server Error")
            }
            self.tableView.reloadData()
            print(self.stocksArray.count)
        }) { error in
            print(error)
            self.view.makeToast(error)
            self.loader.removeFromSuperview()
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
    }
    func getportValue() {
        loader.setView(hasLoader: true)

        let url = EndPoint.kServerBase + EndPoint.TradingView
        print(url)
        NetworkUtil.request(apiMethod: url, parameters: nil, requestType: .get, showProgress: true, view: self.view, onSuccess: { resp -> Void in
            self.loader.removeFromSuperview()
            print(resp!)
            if let jsonObject = resp as? [String: Any] {
                UserDefaults.standard.setValue(SwiftParseUtils.parsePortfolioData(object: jsonObject, view: self.view), forKey: "totalValue")
            } else {
                self.view.makeToast("Server Error")
            }
            self.tableView.reloadData()
            self.getStocks()
        }) { error in
            print(error)

            self.view.makeToast(error)
            self.loader.removeFromSuperview()
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
            self.getStocks()
        }
    }

    func callApiPortFolioGraph(period: String, timeframe: String
    ) {
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
                    let errorMessage = message["message"] as? String
                    self.view.makeToast(errorMessage)
                }
            }
            if self.graphSum > 0 {
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath) as? WelcomeCell
                SwiftParseUtils.parsePortfolioGraphData(object: self.equity, view: self.view, cell: cell!)
            }
        }) { error in
            print(error)
            self.loader.removeFromSuperview()
            self.view.makeToast(error)
        }
    }
}

// MARK: - tableview delegate and datasource

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = cellTypes[indexPath.row]

        if item == .welcome {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WelcomeCell.identifier, for: indexPath) as? WelcomeCell else { return UITableViewCell() }

            if UserDefaults.standard.string(forKey: "totalValue") == nil || UserDefaults.standard.string(forKey: "totalValue") == "" {
                cell.lblPrice.text = "$" + "0"
            } else {
                let currentRatio: Double! = Double(UserDefaults.standard.string(forKey: "totalValue") ?? "0.0")
                if currentRatio != nil {
                    let str = String(format: "%.2f", currentRatio)
                    cell.lblPrice.text = "$ \(str) USD"
                } else {
                    cell.lblPrice.text = UserDefaults.standard.string(forKey: "totalValue")
                }
            }

            let avatar = USER.shared.details?.user?.avatar ?? ""

            cell.userImage.getImage(url: EndPoint.kServerBase + "file/users/"+avatar, placeholderImage: nil) { _ in
                cell.userImage.contentMode = .scaleAspectFill
            } failer: { _ in
                cell.userImage.setImageForName(USER.shared.details?.user!.firstName?.capitalized ?? "GGOG", backgroundColor: nil, circular: true, textAttributes: nil)
            }

            self.callApiPortFolioGraph(period: "1D", timeframe: "1Min")
            cell.day.setTitleColor(._715AFF, for: .normal)
            cell.week.setTitleColor(._92ACB5, for: .normal)
            cell.month.setTitleColor(._92ACB5, for: .normal)

            cell.IDayBlock = {
                self.callApiPortFolioGraph(period: "1D", timeframe: "1Min")
            }
            cell.IWeekBlock = {
                self.callApiPortFolioGraph(period: "1W", timeframe: "1H")
            }
            cell.IMonthBlock = {
                self.callApiPortFolioGraph(period: "1M", timeframe: "1D")
            }

            return cell
        } else if item == .bank {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeBankCell.identifier, for: indexPath) as? HomeBankCell else { return UITableViewCell() }

            let ticketView: TicketView = .fromNib()
            ticketView.backgroundTint = ._357ED4
            ticketView.titleTint = .white
            ticketView.starTint = .white
            ticketView.titleText = "23"
            cell.ticketView.addSubview(ticketView)

            return cell
        } else if item == .invite {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InviteCell.identifier, for: indexPath) as? InviteCell else { return UITableViewCell() }

            let ticketView: TicketView = .fromNib()
            ticketView.backgroundTint = ._357ED4
            ticketView.titleTint = .white
            ticketView.starTint = .white
            ticketView.titleText = "23"
            cell.ticketView.addSubview(ticketView)

            return cell
        } else if item == .favStockCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FavStockCell.identifier, for: indexPath) as? FavStockCell else { return UITableViewCell() }

            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.reloadData()

            cell.actionBlock = {
                self.tabBarController?.selectedIndex = 4
            }

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = cellTypes[indexPath.row]

        if item == .welcome {
            return 282
        } else if item == .bank {
            return 76
        } else if item == .favStockCell {
            return 161
        } else {
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if cellTypes[indexPath.row] == .bank && bankConnected == false {
            UnderRevRouter().route(to: PlaidIntroVC.identifier, from: self, parameters: nil, animated: true)
        }
        if cellTypes[indexPath.row] == .giveAway {
        } else if cellTypes[indexPath.row] == .invite {
            if let link = NSURL(string: USER.shared.sharelink) {
                let objectsToShare = ["Invite your Friends\nReferrel Code \(USER.shared.code)", link] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                currentController()?.present(activityVC, animated: true, completion: nil)
            }
        }
    }
}
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.stocksArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavCell", for: indexPath) as? FavCell ?? FavCell()
        let obj = stocksArray[indexPath.row] as? StockTicker

        cell.stockSymbol.text = obj?.symbol
        cell.stockCompany.text = obj?.name
        cell.stockIcon.setImageForName(obj?.symbol ?? "GOOG", backgroundColor: nil, circular: true, textAttributes: nil)
        let priceValue = obj?.price
        cell.stockPrice.text = "$" + priceValue!
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 165.0, height: 107.0)
    }
}
extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
extension UIImageView {
    func getImage(url: String, placeholderImage: UIImage?, success: @escaping (_ _result: Any? ) -> Void, failer: @escaping (_ _result: Any? ) -> Void) {
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: URL(string: url), placeholderImage: placeholderImage, options: SDWebImageOptions(rawValue: 0), completed: { image, error, _, _ in
            // your rest code
            if error == nil {
                self.image = image
                success(true)
            } else {
                failer(false)
            }
        })
    }
}
enum CellType {
    case welcome
    case bank
    case giveAway
    case invite
    case reward
    case scratch
    case stockHeader
    case stock
    case stockSubHeader
    case favStockCell
    case stockHeadCell
    case stockCell
}
