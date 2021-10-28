//
//  PortfolioViewModel.swift
//  Ribbit
//
//  Created by Ahsan Ali on 20/04/2021.
//

import Charts
import UIKit
class PortfolioViewModel: BaseViewModel {
    private(set) var items: [String]! {
        didSet {
            self.bindViewModelToController()
        }
    }
    override init() {
        super.init()
        proxy = NetworkProxy()
        proxy.delegate = self
        //
        self.items = ["", "", "", "", ""]
    }
    func myStocks() {
        proxy.requestForPositions()
    }
    // MARK: - Delegate
    override func requestDidBegin() {
        super.requestDidBegin()
    }

    override func requestDidFinishedWithData(data: Any, reqType: RequestType) {
        super.requestDidFinishedWithData(data: data, reqType: reqType)
    }

    override func requestDidFailedWithError(error: String, reqType: RequestType) {
        super.requestDidFailedWithError(error: error, reqType: reqType)
        self.bindErrorViewModelToController(error) // If need error in View Controller
    }

    // MARK: - Helepers
    func setPieChartView(chart: PieChartView) {
        chart.noDataText = ""
        let dd1: Double = 20
        let dd2: Double = 20
        let entry = PieChartDataEntry(value: dd1, label: "")
        let credLimit = PieChartDataEntry(value: dd2, label: "")
        let set = PieChartDataSet(entries: [entry, credLimit, entry, credLimit, entry])
        set.colors =
            [#colorLiteral(red: 0.9510702491, green: 0.9611786008, blue: 0.9694285989, alpha: 1), #colorLiteral(red: 0.9999838471, green: 0.9065440297, blue: 0, alpha: 1), #colorLiteral(red: 0.163855195, green: 0.8395599723, blue: 0.7601062655, alpha: 1), #colorLiteral(red: 0.5090016723, green: 0.4161711931, blue: 0.973647058, alpha: 1), #colorLiteral(red: 0.1760319769, green: 0.6006103158, blue: 1, alpha: 1)]
        set.selectionShift = 0
        let data = PieChartData(dataSet: set)
        data.setValueTextColor(.clear)
        chart.data = data
        chart.highlightValues(nil)
        chart.holeRadiusPercent = 0.7
        chart.transparentCircleRadiusPercent = 0
        chart.transparentCircleColor = UIColor.clear
        chart.drawEntryLabelsEnabled = false
        let index = chart.legend
        index.enabled = false
        chart.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
    }
}
