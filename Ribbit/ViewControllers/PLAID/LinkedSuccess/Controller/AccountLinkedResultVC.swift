//
//  AccountLinkedResultVC.swift
//  Ribbit
//
//  Created by Ahsan Ali on 19/04/2021.
//

import UIKit

class AccountLinkedResultVC: BaseVC {
    // MARK: - LifeCycles
    var fromSignup = false
    override func viewDidLoad() {
        super.viewDidLoad()
        USER.shared.accountAdded = true
    }
    // MARK: - IBActions
    @IBAction func contPressed(_ sender: Any) {
        if fromSignup {
            PlaidSuccessRouter().route(to: HomeVC.identifier, from: self, parameters: nil, animated: true)
        } else {
            NotificationCenter.default.post(name: Notification.bankConnected, object: nil)
            self.presentingViewController?
                .presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
