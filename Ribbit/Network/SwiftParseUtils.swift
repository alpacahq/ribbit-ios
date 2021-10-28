//
// SwiftParseUtils.swift
// Ribbit
//
// Created by Rao Mudassar on 27/08/2021.
//
import Charts
import Foundation
import SwiftyRSA
import UIKit

class SwiftParseUtils {
    // MARK: - Parse forgot password Api

    static func parseForgotPasswordData(object: [String: Any], view: UIView) -> String {
        var message: String = ""
        message = object["message"] as? String ?? ""
        return message
    }

    // MARK: - Parse Watchlist Api

    static func parseWatchListData(object: [String: Any], view: UIView) -> NSMutableArray {
        let stocksArray: NSMutableArray = []
        var ids: String? = ""
        var symbol: String? = ""
        var name: String? = ""
        var status: String? = ""
        var price: String? = ""
        let plp: String? = ""
        var isWatchlisted: Bool? = false
        if let object = object["assets"] as? [[String: Any]] {
            for dict in object {
                name = dict["name"] as? String
                name = name?.replacingOccurrences(of: "Class A Common Stock", with: "")
                name = name?.replacingOccurrences(of: "Common Stock", with: "")
                name = name?.replacingOccurrences(of: "Class C Capital Stock", with: "")
                symbol = dict["symbol"] as? String
                ids = dict["id"] as? String
                status = dict["status"] as? String
                isWatchlisted = dict["is_watchlisted"] as? Bool
                if let ticker = dict["ticker"] as? [String: Any] {
                    if let latestTrade = ticker["latestTrade"] as? [String: Any] {
                        let pri = latestTrade["p"] as? Double
                        price = String(format: "%.2f", pri ?? 100.00)
                    } else {
                        price = "100"
                    }
                } else {
                    price = "100"
                }
                let obj = StockTicker(ids: ids ?? "", symbol: symbol ?? "", name: name ?? "", status: status ?? "", price: price ?? "", plp: plp ?? "", open: "0", high: "0", low: "0", volume: "0", isWatchlisted: isWatchlisted ?? false)

                stocksArray.add(obj)
            }
        } else {
            view.makeToast("Server Error")
        }
        return stocksArray
    }

    // MARK: - Parse portfolio Api

    static func parsePortfolioData(object: [String: Any], view: UIView) -> String {
        let doubleValue = Double(object["portfolio_value"] as? String ?? "0000") ?? 0.0
        let stringValue = String(format: "%.2f", doubleValue)
        let finalValue = "$" + stringValue
        return finalValue
    }

    // MARK: - Parse portfolio graph Api

    static func parsePortfolioGraphData(object: [Double], view: UIView, cell: WelcomeCell) {
        cell.graph.isUserInteractionEnabled = false
        cell.graph.drawBordersEnabled = false
        cell.graph.drawGridBackgroundEnabled = false
        cell.graph.legend.enabled = false
        cell.graph.leftAxis.drawGridLinesEnabled = false
        cell.graph.leftAxis.drawLabelsEnabled = false
        cell.graph.leftAxis.drawAxisLineEnabled = false
        cell.graph.xAxis.drawGridLinesEnabled = true
        cell.graph.xAxis.gridColor = UIColor.lightGray.withAlphaComponent(0.5)
        cell.graph.xAxis.axisLineColor = UIColor.lightGray.withAlphaComponent(0.5)
        cell.graph.xAxis.gridLineWidth = 0.5
        cell.graph.xAxis.gridLineDashPhase = 3
        cell.graph.xAxis.gridLineDashLengths = [3, 3]
        cell.graph.xAxis.drawLabelsEnabled = false
        cell.graph.xAxis.drawAxisLineEnabled = false
        cell.graph.rightAxis.drawGridLinesEnabled = false
        cell.graph.rightAxis.drawLabelsEnabled = false
        cell.graph.rightAxis.drawAxisLineEnabled = false
        cell.graph.xAxis.drawLabelsEnabled = false
        cell.graph.xAxis.labelTextColor = ._92ACB5
        cell.graph.xAxis.labelPosition = .bottom
        var dataEntries: [ChartDataEntry] = []
        for index in 0..<object.count {
            let dataEntry = ChartDataEntry(x: Double(index), y: Double(object[index]))
            dataEntries.append(dataEntry)
        }
        let yaxis = cell.graph.getAxis(YAxis.AxisDependency.right)
        yaxis.drawLabelsEnabled = true
        yaxis.labelTextColor = ._92ACB5
        cell.graph.xAxis.granularity = 1
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "credit_score")
        var  colors: [UIColor] = []
        colors.append(UIColor(named: "715AFF") ?? .lightGray)
        lineChartDataSet.colors = colors
        lineChartDataSet.lineWidth = 3
        lineChartDataSet.mode = .horizontalBezier
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.drawCirclesEnabled = false
        let gradientColors = [UIColor(named: "715AFF")?.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
        let colorLocations: [CGFloat] = [1.0, 1.0] // Positioning of the gradient
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) //
        lineChartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        lineChartDataSet.drawFilledEnabled = true
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        cell.graph.data = lineChartData
    }

    // MARK: - Parse postion Api

    static func parsePositionListData(object: [[String: Any]], view: UIView) -> NSMutableArray {
        let stocksArray: NSMutableArray = []
        var assetId: String? = ""
        var symbol: String? = ""
        var unrealizedPlpc: String? = ""
        var unrealizedPl: String? = ""
        var marketValue: String? = ""
        var qty: String? = ""
        var avgEntryPrice: String? = ""
        var changeToday: String? = ""
        var costBasis: Bool? = false
        var exchange: String? = ""
        var open: String? = "0"
        var high: String? = "0"
        var low: String? = "0"
        var volume: String? = "0"
        for dict in object {
            assetId = dict["asset_id"] as? String
            symbol = dict["symbol"] as? String
            unrealizedPlpc = dict["unrealized_plpc"] as? String
            unrealizedPl = dict["unrealized_pl"] as? String
            marketValue = dict["market_value"] as? String
            qty = dict["qty"] as? String
            avgEntryPrice = dict["current_price"] as? String
            changeToday = dict["change_today"] as? String
            costBasis = dict["is_watchlisted"] as? Bool
            exchange = dict["name"] as? String
            exchange = exchange?.replacingOccurrences(of: "Class A Common Stock", with: "")
            exchange = exchange?.replacingOccurrences(of: "Common Stock", with: "")
            exchange = exchange?.replacingOccurrences(of: "Class C Capital Stock", with: "")
            if let ticker = dict["ticker"] as? [String: Any] {
                if let dailyBar = ticker["dailyBar"] as? [String: Any] {
                    let ope = dailyBar["o"] as? Double
                    let hig = dailyBar["h"] as? Double
                    let lowwer = dailyBar["l"] as? Double
                    let vol = dailyBar["v"] as? Double
                    open = String(format: "%.2f", ope ?? 100.00)
                    high = String(format: "%.2f", hig ?? 100.00)
                    low = String(format: "%.2f", lowwer ?? 100.00)
                    volume = String(format: "%.2f", vol ?? 100.00)
                } else {
                    open = "100"
                    high = "100"
                    low = "100"
                    volume = "100"
                }
            } else {
                open = "100"
                high = "100"
                low = "100"
                volume = "100"
            }

            let obj = MyStock(assetId: assetId ?? "", symbol: symbol ?? "", unrealizedPlpc: unrealizedPlpc ?? "", unrealizedPl: unrealizedPl ?? "", marketValue: marketValue ?? "", qty: qty ?? "", avgEntryPrice: avgEntryPrice ?? "", changeToday: changeToday ?? "", costBasis: costBasis ?? false, exchange: exchange ?? "", open: open ?? "", high: high ?? "", low: low ?? "", volume: volume ?? "")

            stocksArray.add(obj)
        }
        return stocksArray
    }

    // MARK: - Parse Home graph Api

    static func parsePortfolioSecondData(object: [Double], view: UIView, graph: LineChartView) {
        graph.isUserInteractionEnabled = false
        graph.drawBordersEnabled = false
        graph.drawGridBackgroundEnabled = false
        graph.legend.enabled = false
        graph.leftAxis.drawGridLinesEnabled = false
        graph.leftAxis.drawLabelsEnabled = false
        graph.leftAxis.drawAxisLineEnabled = false
        graph.xAxis.drawGridLinesEnabled = true
        graph.xAxis.gridColor = UIColor.lightGray.withAlphaComponent(0.5)
        graph.xAxis.axisLineColor = UIColor.lightGray.withAlphaComponent(0.5)
        graph.xAxis.gridLineWidth = 0.5
        graph.xAxis.gridLineDashPhase = 3
        graph.xAxis.gridLineDashLengths = [3, 3]
        graph.xAxis.drawLabelsEnabled = false
        graph.xAxis.drawAxisLineEnabled = false
        graph.rightAxis.drawGridLinesEnabled = false
        graph.rightAxis.drawLabelsEnabled = false
        graph.rightAxis.drawAxisLineEnabled = false
        graph.xAxis.drawLabelsEnabled = false
        graph.xAxis.labelTextColor = ._92ACB5
        graph.xAxis.labelPosition = .bottom
        var dataEntries: [ChartDataEntry] = []
        for index in 0..<object.count {
            let dataEntry = ChartDataEntry(x: Double(index), y: Double(object[index]))
            dataEntries.append(dataEntry)
        }
        let yaxis = graph.getAxis(YAxis.AxisDependency.right)
        yaxis.drawLabelsEnabled = true
        yaxis.labelTextColor = ._92ACB5
        graph.xAxis.granularity = 1
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "credit_score")
        var  colors: [UIColor] = []
        colors.append(UIColor(named: "715AFF") ?? .lightGray)
        lineChartDataSet.colors = colors
        lineChartDataSet.lineWidth = 3
        lineChartDataSet.mode = .horizontalBezier
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.drawCirclesEnabled = false
        let gradientColors = [UIColor(named: "715AFF")?.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
        let colorLocations: [CGFloat] = [1.0, 1.0] // Positioning of the gradient
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) //
        lineChartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        lineChartDataSet.drawFilledEnabled = true
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        graph.data = lineChartData
    }

    // MARK: - Parse BuyCell graph Api

    static func setSparkLineGraph(items: Bar, sparkLineView: LineChartView, value: String) {
        sparkLineView.isUserInteractionEnabled = false
        sparkLineView.drawBordersEnabled = false
        sparkLineView.drawGridBackgroundEnabled = false
        sparkLineView.legend.enabled = false
        sparkLineView.leftAxis.drawGridLinesEnabled = false
        sparkLineView.leftAxis.drawLabelsEnabled = false
        sparkLineView.leftAxis.drawAxisLineEnabled = false
        sparkLineView.xAxis.drawGridLinesEnabled = true
        sparkLineView.xAxis.gridColor = UIColor.lightGray.withAlphaComponent(0.5)
        sparkLineView.xAxis.axisLineColor = UIColor.lightGray.withAlphaComponent(0.5)
        sparkLineView.xAxis.gridLineWidth = 0.5
        sparkLineView.xAxis.gridLineDashPhase = 3
        sparkLineView.xAxis.gridLineDashLengths = [3, 3]
        sparkLineView.xAxis.drawLabelsEnabled = false
        sparkLineView.xAxis.drawAxisLineEnabled = false
        sparkLineView.rightAxis.drawGridLinesEnabled = false
        sparkLineView.rightAxis.drawLabelsEnabled = false
        sparkLineView.rightAxis.drawAxisLineEnabled = false
        sparkLineView.xAxis.drawLabelsEnabled = true
        sparkLineView.xAxis.labelTextColor = ._92ACB5
        sparkLineView.xAxis.labelPosition = .bottom
        sparkLineView.xAxis.avoidFirstLastClippingEnabled = false
        let dataPoints = items.bars.map({ $0.o })
        let dataesPoints = items.bars.map({ $0.t })
        let values = items.bars.map({ $0.o })
        var dataEntries: [ChartDataEntry] = []
        sparkLineView.xAxis.granularityEnabled = true
        sparkLineView.xAxis.granularity = 1
        for index in 0..<dataPoints.count {
            if value == "1D" {
                let mydate = dataesPoints[index]
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date = dateFormatter.date(from: mydate)
                let dataEntry = ChartDataEntry(x: date?.timeIntervalSince1970 ?? 0_000, y: Double(values[index]), data: dataPoints[index])
                dataEntries.append(dataEntry)
                sparkLineView.xAxis.valueFormatter = ChartXAxisFormatter()
            } else if value == "1W" {
                let mydate = dataesPoints[index]
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date = dateFormatter.date(from: mydate)
                let dataEntry = ChartDataEntry(x: date?.timeIntervalSince1970 ?? 0_000, y: Double(values[index]), data: dataPoints[index])
                dataEntries.append(dataEntry)
                sparkLineView.xAxis.valueFormatter = DaysXAxisFormatter()
            } else if value == "1M" {
                let mydate = dataesPoints[index]
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date = dateFormatter.date(from: mydate)
                let dataEntry = ChartDataEntry(x: date?.timeIntervalSince1970 ?? 0_000, y: Double(values[index]), data: dataPoints[index])
                dataEntries.append(dataEntry)
                sparkLineView.xAxis.valueFormatter = MonthsxAxisFormatter()
            } else if value == "1Y" {
                let mydate = dataesPoints[index]
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date = dateFormatter.date(from: mydate)
                let dataEntry = ChartDataEntry(x: date?.timeIntervalSince1970 ?? 0_000, y: Double(values[index]), data: dataPoints[index])
                dataEntries.append(dataEntry)
                sparkLineView.xAxis.valueFormatter = YearxAxisFormatter()
            }
        }
        let yaxis = sparkLineView.getAxis(YAxis.AxisDependency.right)
        yaxis.drawLabelsEnabled = true
        yaxis.labelTextColor = ._92ACB5
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "credit_score")
        var  colors: [UIColor] = []
        colors.append(UIColor(named: "715AFF") ?? .lightGray)
        lineChartDataSet.colors = colors
        lineChartDataSet.lineWidth = 3
        lineChartDataSet.mode = .horizontalBezier
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.drawCirclesEnabled = false
        sparkLineView.xAxis.setLabelCount(5, force: true)
        let gradientColors = [UIColor(named: "715AFF")?.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
        let colorLocations: [CGFloat] = [1.0, 1.0] // Positioning of the gradient
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        lineChartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        lineChartDataSet.drawFilledEnabled = true
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        sparkLineView.data = lineChartData
    }
    // MARK: - Parse stocks Api

    static func parseStockData(object: [String: Any], view: UIView) -> NSMutableArray {
        var ids: String? = ""
        var symbol: String? = ""
        var name: String? = ""
        var status: String? = ""
        var price: String? = ""
        let plp: String? = ""
        var open: String? = "0"
        var high: String? = "0"
        var low: String? = "0"
        var volume: String? = "0"
        var isWatchlisted: Bool? = false
        let stocksArray: NSMutableArray = []
        if let object = object["assets"] as? [[String: Any]] {
            for dict in object {
                name = dict["name"] as? String
                name = name?.replacingOccurrences(of: "Class A Common Stock", with: "")
                name = name?.replacingOccurrences(of: "Common Stock", with: "")

                name = name?.replacingOccurrences(of: "Class C Capital Stock", with: "")
                symbol = dict["symbol"] as? String
                ids = dict["id"] as? String
                status = dict["status"] as? String
                isWatchlisted = dict["is_watchlisted"] as? Bool
                if let ticker = dict["ticker"] as? [String: Any] {
                    if let dailyBar = ticker["dailyBar"] as? [String: Any] {
                        let ope = dailyBar["o"] as? Double
                        let hig = dailyBar["h"] as? Double
                        let lowwer = dailyBar["l"] as? Double
                        let vol = dailyBar["v"] as? Double
                        open = String(format: "%.2f", ope ?? 100.00)
                        high = String(format: "%.2f", hig ?? 100.00)
                        low = String(format: "%.2f", lowwer ?? 100.00)
                        volume = String(format: "%.2f", vol ?? 100.00)
                    } else {
                        open = "100"
                        high = "100"
                        low = "100"
                        volume = "100"
                    }
                    if let latestTrade = ticker["latestTrade"] as? [String: Any] {
                        let pri = latestTrade["p"] as? Double

                        price = String(format: "%.2f", pri ?? 100.00)
                    } else {
                        price = "100"
                    }
                } else {
                    price = "100"
                    open = "100"
                    high = "100"
                    low = "100"
                    volume = "100"
                }
                let obj = StockTicker(ids: ids ?? "", symbol: symbol ?? "", name: name ?? "", status: status ?? "", price: price ?? "", plp: plp ?? "", open: open ?? "", high: high ?? "", low: low ?? "", volume: volume ?? "", isWatchlisted: isWatchlisted ?? false)
                stocksArray.add(obj)
            }
        } else {
            view.makeToast("Server Error")
        }
        return stocksArray
    }

    // MARK: - Parse search stocks Api

    static func parseSearchStockData(object: [[String: Any]], view: UIView) -> NSMutableArray {
        var ids: String? = ""
        var symbol: String? = ""
        var name: String? = ""
        var status: String? = ""
        let price: String? = ""
        let plp: String? = ""
        var isWatchlisted: Bool? = false
        let stocksArray: NSMutableArray = []
        for dict in object {
            name = dict["name"] as? String
            symbol = dict["symbol"] as? String
            ids = dict["id"] as? String
            status = dict["status"] as? String
            isWatchlisted = dict["is_watchlisted"] as? Bool
            let obj = StockTicker(ids: ids ?? "", symbol: symbol ?? "", name: name ?? "", status: status ?? "", price: price ?? "", plp: plp ?? "", open: "0", high: "0", low: "0", volume: "0", isWatchlisted: isWatchlisted ?? false)

            stocksArray.add(obj)
        }

        return stocksArray
    }

    // MARK: - Parse search assests Api

    static func parseAssestsData(object: [[String: Any]], view: UIView) -> NSMutableArray {
        var ids: String? = ""
        var symbol: String? = ""
        var name: String? = ""
        var status: String? = ""
        var price: String? = ""
        let plp: String? = ""
        var open: String? = "0"
        var high: String? = "0"
        var low: String? = "0"
        var volume: String? = "0"
        var isWatchlisted: Bool? = false
        let stocksArray: NSMutableArray = []
        for dict in object {
            name = dict["name"] as? String
            name = name?.replacingOccurrences(of: "Class A Common Stock", with: "")
            name = name?.replacingOccurrences(of: "Common Stock", with: "")
            name = name?.replacingOccurrences(of: "Class C Capital Stock", with: "")
            symbol = dict["symbol"] as? String
            ids = dict["id"] as? String
            status = dict["status"] as? String
            isWatchlisted = dict["is_watchlisted"] as? Bool
            if let ticker = dict["ticker"] as? [String: Any] {
                if let dailyBar = ticker["dailyBar"] as? [String: Any] {
                    let ope = dailyBar["o"] as? Double
                    let hig = dailyBar["h"] as? Double
                    let lowwer = dailyBar["l"] as? Double
                    let vol = dailyBar["v"] as? Double
                    open = String(format: "%.2f", ope ?? 100.00)
                    high = String(format: "%.2f", hig ?? 100.00)
                    low = String(format: "%.2f", lowwer ?? 100.00)
                    volume = String(format: "%.2f", vol ?? 100.00)
                } else {
                    open = "100"
                    high = "100"
                    low = "100"
                    volume = "100"
                }
                if let latestTrade = ticker["latestTrade"] as? [String: Any] {
                    let pri = latestTrade["p"] as? Double
                    price = String(format: "%.2f", pri ?? 100.00)
                } else {
                    price = "100"
                }
            } else {
                price = "100"
                open = "100"
                high = "100"
                low = "100"
                volume = "100"
            }
            let obj = StockTicker(ids: ids ?? "", symbol: symbol ?? "", name: name ?? "", status: status ?? "", price: price ?? "", plp: plp ?? "", open: open ?? "", high: high ?? "", low: low ?? "", volume: volume ?? "", isWatchlisted: isWatchlisted ?? false)
            stocksArray.add(obj)
        }

        return stocksArray
    }
}
