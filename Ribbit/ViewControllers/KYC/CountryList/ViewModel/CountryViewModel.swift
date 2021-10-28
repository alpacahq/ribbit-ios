//
//  CountryViewModel.swift
//  Ribbit
//
//  Created by Ahsan Ali on 07/04/2021.
//

import UIKit

class CountryViewModel: BaseViewModel {
    private(set) var countries: CountryModel! {
        didSet {
            self.bindViewModelToController()
        }
    }
    init(reqType: RequestType, countryCode: String = "", stateCode: String = "") {
        super.init()
        proxy = NetworkProxy()
        proxy.delegate = self
        if reqType == .stateList {
            proxy.requestForStateList(code: countryCode)
        } else if reqType == .cityList {
            proxy.requestForCityList(code: countryCode, state: stateCode)
        } else {
            proxy.requestForCountryList()
        }
    }
    // MARK: - Delegate
    override func requestDidBegin() {
        super.requestDidBegin()
    }

    override func requestDidFinishedWithData(data: Any, reqType: RequestType) {
        super.requestDidFinishedWithData(data: data, reqType: reqType)
        if let res = data as? CountryModel {
            self.countries = res
        }
    }

    override func requestDidFailedWithError(error: String, reqType: RequestType) {
        super.requestDidFailedWithError(error: error, reqType: reqType)
        self.bindErrorViewModelToController(error) // If need error in View Controller
    }
}
