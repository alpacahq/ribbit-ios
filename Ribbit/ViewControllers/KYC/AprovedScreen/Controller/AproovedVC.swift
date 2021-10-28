//
//  AproovedVC.swift
//  Ribbit
//
//  Created by Ahsan Ali on 28/05/2021.

// MARK: - Kyc approved/disapproved status

import UIKit

class AproovedVC: BaseVC {
    // MARK: - Outlerts
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var ICON: UIImageView!
    @IBOutlet var btnNext: UIButton!

    // MARK: - Vars
    var isAproved = false

    // MARK: - Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Actions
    @IBAction func contPressed(_ sender: Any) {
        if isAproved {
            UnderRevRouter().route(to: PlaidIntroVC.identifier, from: self, parameters: ["signup": true], animated: true)
        } else { // START OVER
            ReviewRouter().route(to: EmailVC.identifier, from: self, parameters: nil, animated: true)
        }
    }

    // MARK: - Helpers
    private func setView() {
        if isAproved == false {
            ICON.image = #imageLiteral(resourceName: "smiley")
            lblTitle.text = "KYC Not Approved"
            lblSubTitle.text = "We have emailed you a few\nreasons why. please submit again"
            btnNext.setTitle("START OVER", for: .normal)
            btnNext.backgroundColor = UIColor._715AFF_25
            btnNext.setTitleColor(UIColor._665BA7, for: .normal)
        }
    }
}
