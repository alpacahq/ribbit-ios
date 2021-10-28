//
//  BuySellVC.swift
//  Ribbit
//
//  Created by Ahsan Ali on 30/03/2021.

// MARK: - show buy sell data and graph with market trending

import Charts
import InitialsImageView
import SDWebImageSVGCoder
import SSSpinnerButton
import UIKit
class BuySellVC: BaseVC {
    // MARK: - variables

    // MARK: - Outlets
    @IBOutlet var txtinput: UITextField!
    @IBOutlet var backview: UIView!
    @IBOutlet var buyline: UIView!
    @IBOutlet var sellLine: UIView!
    @IBOutlet var btnBuy: UIButton!
    @IBOutlet var btnSell: UIButton!
    @IBOutlet var btnBuySell: UIButton!
    @IBOutlet var orgIcon: UIImageView!
    @IBOutlet var plpicon: UIImageView!
    @IBOutlet var price: UILabel!
    @IBOutlet var plppercent: UILabel!
    @IBOutlet var lblBuySellTitle: UILabel!
    @IBOutlet var sparkLineView: LineChartView!
    @IBOutlet var btn1Day: UIButton!
    private var lastfilter: UIButton!
    var symbol: String! = "AAPL"
    var object: StockTicker?
    @IBOutlet var btnOpen: UIButton!
    @IBOutlet var btnHigh: UIButton!
    @IBOutlet var btnVol: UIButton!
    @IBOutlet var btnLow: UIButton!
    @IBOutlet var lblTotla: UILabel!
    var value: String = "1D"
    private let DE = Calendar.current.date(byAdding: .hour, value: -1, to: Date())
    private var lastSelected: UIButton!
    private var VM: BuySellViweModel!
    private let morebutton = UIButton()
    private  let loader: Loader = .fromNib()
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.symbol = object?.symbol ?? "AAPL"
        if UserDefaults.standard.string(forKey: "totalValue") == nil || UserDefaults.standard.string(forKey: "totalValue") == ""{
            self.lblTotla.text = "$" + "0"
        } else {
            let currentRatio: Double! = Double(UserDefaults.standard.string(forKey: "totalValue") ?? "0.0")
            if currentRatio != nil {
                let str = String(format: "%.2f", currentRatio)
                self.lblTotla.text  = "$ \(str) USD"
            } else {
                self.lblTotla.text  = UserDefaults.standard.string(forKey: "totalValue")
            }
        }

        self.btnOpen.setTitle(object?.open, for: .normal)
        self.btnHigh.setTitle(object?.high, for: .normal)
        self.btnLow.setTitle(object?.low, for: .normal)
        if let myNumber = NumberFormatter().number(from: object?.volume ?? "0.0") {
            let myInt = myNumber.intValue
            let val = myInt.roundedWithAbbreviations
            self.btnVol.setTitle(val, for: .normal)
            // do what you need to do with myInt
        } else {
            // what ever error code you need to write
        }

        self.orgIcon.setImageForName(self.symbol ?? "GOOG", backgroundColor: nil, circular: true, textAttributes: nil)

        VM = BuySellViweModel()
        lastfilter = btn1Day
        btn1Day.backgroundColor = #colorLiteral(red: 0.4470588235, green: 0.4392156863, blue: 1, alpha: 0.1159199089)
        VM.result = { msg in
            self.view.makeToast(msg)
            self.loader.removeFromSuperview()
        }
        VM.bindErrorViewModelToController = { _ in
            self.loader.removeFromSuperview()
        }
        let DS = Calendar.current.startOfDay(for: Date())
        VM.getBars(symbol: symbol, timeFrame: "1Min", start: DS.RFCFormat, end: DE!.RFCFormat)
        VM.bars = { bars in
            DispatchQueue.main.async {
                // self.setSparkLineGraph(items: bars)
                SwiftParseUtils.setSparkLineGraph(items: bars, sparkLineView: self.sparkLineView, value: self.value)
            }
        }
        setNavigation()
        if object?.price == "" {
            self.price.alpha = 0
            self.plpicon.alpha = 0
            self.plppercent.alpha = 0
        } else {
            self.price.alpha = 1
            self.plpicon.alpha = 1
            self.plppercent.alpha = 1
            self.price.text = "$" + (object?.price!)!
            if object?.plp == "" {
                self.plpicon.alpha = 0
                self.plppercent.alpha = 0
            } else {
                self.plpicon.alpha = 1
                self.plppercent.alpha = 1
            }
            if object?.plp?.contains("-") ?? true {
                self.plpicon.image = UIImage(named: "downArrow")
                self.plppercent.text = "$" + (object?.plp)!
                self.plppercent.textColor = UIColor(named: "DownColor")
            } else {
                self.plpicon.image = UIImage(named: "arrow_drop_up")
                self.plppercent.text = "$" + (object?.plp)!
                self.plppercent.textColor = UIColor.green
                self.plppercent.textColor = UIColor(named: "UpColor")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    @IBAction func BUYSELLActions(_ sender: UIButton) {
        if sender != lastSelected {
            lastSelected.isSelected.toggle()
            sender.isSelected.toggle()
            lastSelected = sender

            switch sender.tag {
            case 0:
                btnBuySell.tag = 0
                buyline.isHidden = false
                sellLine.isHidden = true
                lblBuySellTitle.text = "monthly"
                btnBuySell.setTitle("Buy Shares", for: .normal)
                btnBuy.backgroundColor = .white
                btnSell.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9725490196, blue: 0.9843137255, alpha: 1)

            default:// SELL
                btnBuySell.tag = 1
                btnBuy.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9725490196, blue: 0.9843137255, alpha: 1)
                btnSell.backgroundColor =  .white
                buyline.isHidden = true
                sellLine.isHidden = false
                lblBuySellTitle.text = "Total Value"
                btnBuySell.setTitle("Sell Shares", for: .normal)
            }
        }
    }

    @IBAction func Filter(_ sender: UIButton) {
        if lastfilter != sender {
            sender.backgroundColor = #colorLiteral(red: 0.4470588235, green: 0.4392156863, blue: 1, alpha: 0.1159199089)
            lastfilter.backgroundColor = .white
            lastfilter = sender
            switch sender.tag {
            case 0:  // 1D
                self.value = "1D"
                let DS = Calendar.current.startOfDay(for: Date())
                VM.getBars(symbol: symbol, timeFrame: "10Min", start: DS.RFCFormat, end: DE!.RFCFormat)
            case 1: // 1W
                self.value = "1W"
                let DS = Calendar.current.date(byAdding: .day, value: -7, to: Date())
                VM.getBars(symbol: symbol, timeFrame: "1Hour", start: DS!.RFCFormat, end: DE!.RFCFormat)

            case 2: // 3M
                self.value = "1M"
                let DS = Calendar.current.date(byAdding: .month, value: -3, to: Date())
                VM.getBars(symbol: symbol, timeFrame: "1Day", start: DS!.RFCFormat, end: DE!.RFCFormat)
            case 3:// 6M
                self.value = "1M"
                let DS = Calendar.current.date(byAdding: .month, value: -6, to: Date())
                VM.getBars(symbol: symbol, timeFrame: "1Day", start: DS!.RFCFormat, end: DE!.RFCFormat)

            case 4:  // 1Y
                self.value = "1M"
                let DS = Calendar.current.date(byAdding: .year, value: -1, to: Date())
                VM.getBars(symbol: symbol, timeFrame: "1Day", start: DS!.RFCFormat, end: DE!.RFCFormat)

            default: // 5Y
                self.value = "1Y"
                let DS = Calendar.current.date(byAdding: .year, value: -5, to: Date())
                VM.getBars(symbol: symbol, timeFrame: "1Day", start: DS!.RFCFormat, end: DE!.RFCFormat)
            }
        }
    }
    private func setNavigation() {
        lastSelected = btnBuy
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        if object?.isWatchlisted == false {
            morebutton.setImage(UIImage(named: "favorite"), for: .normal)
        } else {
            morebutton.setImage(UIImage(named: "heart"), for: .normal)
        }
        morebutton.addTarget(self, action: #selector(favAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: morebutton)
        self.navigationController?.navigationBar.tintColor = ._92ACB5

        self.navigationItem.setTitle(object?.symbol ?? "$AAPL", subtitle: object?.name ?? "Apple Inc")

        backview.layer.cornerRadius = 25
        backview.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    @objc func favAction() {
        self.loader.setView(hasLoader: true)
        if morebutton.image(for: .normal) == UIImage(named: "favorite") {
            VM.makeFav(symbol: symbol)
            VM.fav = {
                self.loader.removeFromSuperview()
                self.morebutton.setImage(UIImage(named: "heart"), for: .normal)
            }
        } else {
            VM.removeFav(symbol: symbol)
            VM.unFav = {
                self.loader.removeFromSuperview()
                self.morebutton.setImage(UIImage(named: "favorite"), for: .normal)
            }
        }
    }

    @IBAction func buyAction(_ sender: Any) {
        UserDefaults.standard.set("Buy", forKey: "Buy")
        BuySellRouter().route(to: BuyViewController.identifier, from: self, parameters: object, animated: true)
    }
    @IBAction func sellAction(_ sender: Any) {
        UserDefaults.standard.set("Sell", forKey: "Buy")
        BuySellRouter().route(to: BuyViewController.identifier, from: self, parameters: object, animated: true)
    }
    @IBAction func BUYSELLACTION(_ sender: SSSpinnerButton) {
        if txtinput.text?.trimmingCharacters(in: CharacterSet(arrayLiteral: " ")) == "" {
            view.makeToast("Please enter amount")
            return
        }
        self.loader.setView(hasLoader: true)
    }
}

// MARK: - Integer places extention

extension Int {
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number / 1_000
        let million = number / 1_000_000
        if million >= 1.0 {
            return "\(round(million * 10) / 10)M"
        } else if thousand >= 1.0 {
            return "\(round(thousand * 10) / 10)K"
        } else {
            return "\(self)"
        }
    }
}
