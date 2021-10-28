//
// VerifyIdentityVC.swift
// Ribbit
//
// Created by Ahsan Ali on 17/03/2021.

// MARK: - Take social security number

import SSSpinnerButton
import UIKit
class VerifyIdentityVC: UIViewController {
    // MARK: - Variables
    private var verifyIdentityViewModel: VidentityViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor._715AFF
    }

    // MARK: - IBActions

    @IBAction func continuePressed(_ sender: SSSpinnerButton) {
        sender.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor._715AFF, spinnerSize: 20, complete: {
            self.updateProfile(sender: sender)
        })
    }

    // MARK: - Helpers
    private func updateProfile(sender: SSSpinnerButton) {
        verifyIdentityViewModel = VidentityViewModel()
        verifyIdentityViewModel.sender = sender
        verifyIdentityViewModel.bindViewModelToController = {
            sender.stopAnimate {
                let router = VidentityRouter()
                router.route(to: SocialSecurityVC.identifier, from: self, parameters: nil, animated: true)
            }
        }
    }
}
