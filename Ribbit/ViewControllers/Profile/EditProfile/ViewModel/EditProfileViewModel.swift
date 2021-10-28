//
//  EditProfileViewModel.swift
//  Ribbit
//
//  Created by Ahsan Ali on 02/06/2021.
//

import UIKit

class EditProfileViewModel: BaseViewModel {
    override init() {
        super.init()
        proxy = NetworkProxy()
        proxy.delegate = self
    }

    func updateProfile(username: String? = "", bio: String? = "", fab: String? = "", insta: String? = "", twiter: String? = "", publicPortfolio: String? = "") {
        proxy.requestForUpdateProfile(param: ["username": username!, "bio": bio!, "instagram_url": insta!, "twitter_url": twiter!, "facebook_url": fab!, "public_portfolio": publicPortfolio!])
    }
    // MARK: - Delegate
    override func requestDidBegin() {
        super.requestDidBegin()
    }

    override func requestDidFinishedWithData(data: Any, reqType: RequestType) {
        super.requestDidFinishedWithData(data: data, reqType: reqType)
        bindViewModelToController()
    }
    override func requestDidFailedWithError(error: String, reqType: RequestType) {
        super.requestDidFailedWithError(error: error, reqType: reqType)
        self.bindErrorViewModelToController(error) // If need error in View Controller
    }
}
