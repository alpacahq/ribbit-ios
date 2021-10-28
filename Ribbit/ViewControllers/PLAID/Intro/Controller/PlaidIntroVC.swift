//
//  PlaidIntroVC.swift
//  Ribbit
//
//  Created by Ahsan Ali on 18/03/2021.
//

import LinkKit
import SSSpinnerButton
import UIKit
class PlaidIntroVC: UIViewController {
    // MARK: - Variables
    private var plaidViewModel: IntroViewModel!
    var fromSignup = false
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        plaidViewModel = IntroViewModel()
    }
    // MARK: - IBActions

    @IBAction func contPressed(_ sender: SSSpinnerButton) {
        self.plaidViewModel.sender = sender
        sender.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: {
            self.plaidViewModel.linkBank(context: self)
        })

        plaidViewModel.bindViewModelToController = {
            sender.stopAnimate(complete: {})
            if self.plaidViewModel.success {
                IntroRouter().route(to: AccountLinkedResultVC.identifier, from: self, parameters: ["signup": self.fromSignup], animated: true)
            }
        }
    }

    @IBAction func skipPressed(_ sender: UIButton) {
        if fromSignup {
            PlaidSuccessRouter().route(to: HomeVC.identifier, from: self, parameters: nil, animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
