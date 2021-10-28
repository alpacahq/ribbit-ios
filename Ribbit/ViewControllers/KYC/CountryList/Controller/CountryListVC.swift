//
//  CountryListVC.swift
//  Ribbit
//
//  Created by Ahsan Ali on 23/03/2021.

// MARK: - Take user country from country list.

import UIKit

class CountryListVC: BaseVC {
    // MARK: - IBOutlets
    @IBOutlet var countryTV: UITableView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    // MARK: - Variables
    weak var delegate: CountryDelegate?
    private var countryViewModel: CountryViewModel!
    private var dataSource: CountryTableViewDataSource<CountryCell, CountryModelElement>!

    var countryCode = ""
    var stateCode = ""
    private var reqType = RequestType.countryList

    // MARK: - lifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        countryTV.tableFooterView = UIView()
        callToViewModelForUIUpdate()
    }

    // MARK: - Helpers
    func callToViewModelForUIUpdate() {
        if countryCode == "" {
            reqType = .countryList
            self.countryViewModel = CountryViewModel(reqType: .countryList)
        } else if stateCode != "" {
            reqType = .cityList
            self.countryViewModel = CountryViewModel(reqType: .cityList, countryCode: countryCode, stateCode: stateCode)
        } else {
            reqType = .stateList
            self.countryViewModel = CountryViewModel(reqType: .stateList, countryCode: countryCode)
        }

        self.countryViewModel.bindViewModelToController = {
            self.updateDataSource()
        }
    }

    func updateDataSource() {
        self.dataSource = CountryTableViewDataSource(cellIdentifier: CountryCell.identifier, items: self.countryViewModel.countries, configureCell: { cell, cvm in
            cell.lblname.text = cvm.name
        })

        DispatchQueue.main.async {
            self.countryTV.dataSource = self.dataSource
            self.indicatorView.isHidden = true
            self.countryTV.isHidden = false
            self.countryTV.reloadData()
        }
    }
}

// MARK: - Textfield Delegate
extension CountryListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegate != nil {
            delegate?.didSelectCountry(item: self.countryViewModel.countries[indexPath.row].name, code: self.countryViewModel.countries[indexPath.row].shortCode ?? "", reqType: reqType)
        }

        sheetViewController?.dismiss(animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - Countrylist delegate

protocol CountryDelegate: AnyObject {
    func didSelectCountry(item: String, code: String, reqType: RequestType)
}
