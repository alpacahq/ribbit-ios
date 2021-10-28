//
// ProfileVC.swift
// Ribbit
//
// Created by Ahsan Ali on 26/04/2021.

// MARK: - Interface of user's info

import InitialsImageView
import SDWebImageSVGCoder
import UIKit

class ProfileVC: BaseVC {
    // MARK: - IBOutlets
    @IBOutlet var showProfileToggle: UISwitch!
    @IBOutlet var popupView: UIView!
    private  let loader: Loader = .fromNib()
    var stocksArray: NSMutableArray = []
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }
    // MARK: - Variables
    private var viewModel: ProfileViewModel!
    // MARK: - Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getStocks()
    }
    // MARK: - Actions
    @IBAction func toggleSwitch(_ sender: UISwitch) {
    }
    @IBAction func settings(_ sender: Any) {
        ProfileRouter().route(to: EditProfileVC.identifier, from: self, parameters: nil, animated: true)
    }
    // MARK: - call api layers
    func getStocks() {
        let url = EndPoint.kServerBase + EndPoint.watchList
        print(url)
        NetworkUtil.request(apiMethod: url, parameters: nil, requestType: .get, showProgress: true, view: self.view, onSuccess: { resp -> Void in
            self.stocksArray = []
            print(resp!)

            if let jsonObject = resp as? [String: Any] {
                self.stocksArray = SwiftParseUtils.parseStockData(object: jsonObject, view: self.view)
            } else {
                self.view.makeToast("Server Error")
            }
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
            print(self.stocksArray.count)
        }) { error in
            print(error)
            self.view.makeToast(error)
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
    }
}
// MARK: - tableview delegates and datasource
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocksArray.count + 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: ProfileHeaderCell = self.tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell") as? ProfileHeaderCell ?? ProfileHeaderCell()
            cell.profileImage.setImageForName(USER.shared.details?.user!.firstName?.capitalized ?? "GGOG", backgroundColor: nil, circular: true, textAttributes: nil)
            cell.lblBio.text = USER.shared.details?.user?.bio
            cell.profileImage.setImageForName(USER.shared.details?.user?.fullName ?? "Rao", backgroundColor: nil, circular: true, textAttributes: nil)
            let avatar = USER.shared.details?.user?.avatar ?? ""
            cell.profileImage.getImage(url: EndPoint.kServerBase + "file/users/"+avatar, placeholderImage: nil) { _ in
                cell.profileImage.contentMode = .scaleAspectFill
            } failer: { _ in
                cell.profileImage.setImageForName(USER.shared.details?.user!.firstName?.capitalized ?? "GGOG", backgroundColor: nil, circular: true, textAttributes: nil)
            }
            return cell
        } else if indexPath.row == 1 {
            let cell: StockHeadCell = self.tableView.dequeueReusableCell(withIdentifier: "StockHeadCell")! as? StockHeadCell ?? StockHeadCell()
            return cell
        } else {
            let obj = stocksArray[indexPath.row - 2] as? StockTicker
            let cell: StockCell = self.tableView.dequeueReusableCell(withIdentifier: "StockCell")! as? StockCell ?? StockCell()
            cell.stockSymbol.text = obj?.symbol
            cell.stockCompany.text = obj?.name
            cell.stockImg.setImageForName(obj?.symbol ?? "GOOG", backgroundColor: nil, circular: true, textAttributes: nil)
            cell.stockPrice.text = "$" + (obj?.price)!
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 133
        } else if indexPath.row == 1 {
            return 54
        } else {
            return 60
        }
    }
}
