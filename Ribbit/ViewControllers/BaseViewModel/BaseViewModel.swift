//
//  BaseViewModel.swift
//  Ribbit
//
//  Created by Ahsan Ali on 02/04/2021.
//

import SSSpinnerButton
import Toast_Swift
import UIKit

class BaseViewModel: NSObject, NetworkProxyDelegate {
    var bindViewModelToController: (() -> Void) = {}
    var bindErrorViewModelToController: ((String) -> Void) = { _ in }
    var proxy: NetworkProxy!
    var sender: SSSpinnerButton!
    private var loaderlayer: Loader  =  .fromNib()
    func requestDidBegin() {
        if (NetworkState().isInternetAvailable) == false {
            NetworkState.showNetworkErrorView()
            return
        }
        if loaderlayer.isAdded == false {
            loaderlayer.setView()
        }
    }
    func requestDidFinishedWithData(data: Any, reqType: RequestType) {
        loaderlayer.removeFromSuperview()
        loaderlayer.isAdded = false
    }

    func requestDidFailedWithError(error: String, reqType: RequestType) {
        if sender != nil {
            sender.stopAnimate(complete: nil)
        }
        loaderlayer.removeFromSuperview()
        loaderlayer.isAdded = false
        currentController()?.view.makeToast(error)
    }
}
