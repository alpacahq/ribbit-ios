//
// CitizenViewModel.swift
// Ribbit
//
// Created by Ahsan Ali on 07/04/2021.
//

import UIKit
class CitizenViewModel: BaseViewModel {
    private(set) var success: Bool! {
        didSet {
            self.bindViewModelToController()
        }
    }
    var countriesRetrievalToController : (() -> Void) = {}
    var stateNameBinding: ((_ state: String) -> Void)?
    override init() {
        super.init()
        proxy = NetworkProxy()
        proxy.delegate = self
    }

    func updateProfile(country: String, code: String) {
        proxy.requestForUpdateProfile(param: ["country_code": code, "country": country, "tax_id_type": code, "profile_completion": STEPS.citizenship.rawValue])
    }
    func getStateName() {
        proxy.requestForStateList(code: USER.shared.details?.user?.countryCode ?? "")
    }

    // MARK: - Delegate
    override func requestDidBegin() {
        super.requestDidBegin()
    }

    override func requestDidFinishedWithData(data: Any, reqType: RequestType) {
        super.requestDidFinishedWithData(data: data, reqType: reqType)
        switch reqType {
        case .stateList:
            if let res = data as? CountryModel {
                stateNameBinding!(   res.filter({ $0.shortCode == USER.shared.details?.user?.state }).first?.name ?? "")
            }
        default:
            success = true
        }
    }
    override func requestDidFailedWithError(error: String, reqType: RequestType) {
        super.requestDidFailedWithError(error: error, reqType: reqType)
        self.bindErrorViewModelToController(error) // If need error in View Controller
    }
}
