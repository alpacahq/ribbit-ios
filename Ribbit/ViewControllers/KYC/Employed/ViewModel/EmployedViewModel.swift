//
//  EmployedViewModel.swift
//  Ribbit
//
//  Created by Ahsan Ali on 08/04/2021.
//

import UIKit

class EmployedViewModel: BaseViewModel {
    private(set) var success: Bool! {
        didSet {
            self.bindViewModelToController()
        }
    }

    init(tag: Int) {
        super.init()
        proxy = NetworkProxy()
        proxy.delegate = self
        var status = ""
        switch tag {
        case 0:
            status = EmploymentStatus.employed.rawValue // Employed
        case 1:
            status = EmploymentStatus.unemployed.rawValue // UNEmployed
        case 2:
            status = EmploymentStatus.retired.rawValue // Retired
        default:
            status = EmploymentStatus.student.rawValue // Student
        }
        proxy.requestForUpdateProfile(param: ["employment_status": status, "profile_completion": STEPS.employed.rawValue])
    }
    // MARK: - Delegate
    override func requestDidBegin() {
        super.requestDidBegin()
    }
    override func requestDidFinishedWithData(data: Any, reqType: RequestType) {
        super.requestDidFinishedWithData(data: data, reqType: reqType)
        success = true
    }
    override func requestDidFailedWithError(error: String, reqType: RequestType) {
        super.requestDidFailedWithError(error: error, reqType: reqType)
        self.bindErrorViewModelToController(error) // If need error in View Controller
    }
}
