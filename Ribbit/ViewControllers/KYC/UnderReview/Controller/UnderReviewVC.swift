//
//  UnderReviewVC.swift
//  Ribbit
//
//  Created by Ahsan Ali on 18/03/2021.

// MARK: - All filled data view of kyc flow

import UIKit

class UnderReviewVC: UIViewController {
    // MARK: - Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    @IBAction func contPressed(_ sender: Any) {
        // UnderRevRouter().route(to: PlaidIntroVC.identifier, from: self, parameters: ["signup":true], animated: true)
    }
}
