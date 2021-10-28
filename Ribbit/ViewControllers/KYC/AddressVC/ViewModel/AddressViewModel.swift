//
//  AddressViewModel.swift
//  Ribbit
//
//  Created by Ahsan Ali on 04/04/2021.
//

import CoreLocation
import Foundation
class AddressViewModel: BaseViewModel {
    // MARK: - Variables
    private var locationManager: CLLocationManager!
    private(set) var success: Bool! {
        didSet {
            self.bindViewModelToController()
        }
    }
    var bindAddressViewModelToController: ((String) -> Void) = { _ in }
    var stateNameBinding: ((_ state: String) -> Void)?
    // MARK: - Cycle
    override init() {
        super.init()
        self.proxy = NetworkProxy()
        proxy.delegate = self
    }

    func updateProfile(address: String, state: String, city: String, zipCode: String, apartment: String) {
        proxy.requestForUpdateProfile(param: ["address": address, "state": state, "city": city, "unit_apt": apartment, "zip_code": zipCode, "profile_completion": STEPS.address.rawValue])
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
                stateNameBinding!(res.filter({ $0.shortCode == USER.shared.details?.user?.state }).first?.name ?? "")
            }
        default:
            success = true
        }
    }

    override func requestDidFailedWithError(error: String, reqType: RequestType) {
        super.requestDidFailedWithError(error: error, reqType: reqType)
        self.bindErrorViewModelToController(error) // If need error in View Controller
    }

    // MARK: - Helpers
    func getStateName() {
        proxy.requestForStateList(code: "USA")
    }

    func getAddress() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
}

extension AddressViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { placemarks, error in
            if error != nil {
                consoleLog("error in reverseGeocode")
            }
            if let placemark = placemarks {
                if placemark.count > 0 {
                    let placemark = placemarks![0]
                    let completeAddress = "\(placemark.locality ?? placemark.subLocality ?? ""), \(placemark.administrativeArea ?? placemark.subAdministrativeArea ?? ""), \(placemark.country ?? "")"
                    self.bindAddressViewModelToController(completeAddress)
                    self.locationManager.stopUpdatingLocation()
                    consoleLog(completeAddress)
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        consoleLog("FAILED TO GET LOCATION")
    }
}
