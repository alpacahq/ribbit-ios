//
// MagicLinkVC.swift
// Ribbit
//
// Created by Adnan Asghar on 3/15/21.
//

import UIKit
// import MagicSDK
import SSSpinnerButton
class MagicLinkVC: BaseVC {
    // MARK: - IBOutlets

    @IBOutlet var btnOpenMail: SSSpinnerButton!
    // MARK: - Variables
    var email = ""
    private var signupViewModel: SignupViewModel!
    private var router: MagicLinkRouter!

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }

    // MARK: - IBActions

    @IBAction func openMailPressed(_ sender: SSSpinnerButton) {
        if let mailURL = URL(string: "message:") {
            if UIApplication.shared.canOpenURL(mailURL) {
                self.btnOpenMail.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: nil)

                UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
            }
        }
    }

    // MARK: - Helpers
    private func setView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.btnOpenMail.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
                self.btnOpenMail.stopAnimate(complete: nil)
            }
        }
    }
}

extension MagicLinkVC: BackPressedDelegte {
    func backPressed() {
    }
}
