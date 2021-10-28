//
//  ShareholderQuestionVC.swift
//  Ribbit
//
//  Created by Adnan Asghar on 3/17/21.

// MARK: - Ask from user about shareholder.

import SSSpinnerButton
import UIKit
class ShareholderQuestionVC: UIViewController {
    // MARK: - IBOutlets

    // MARK: - Variables
    var shareHViewModel: ShareHolderViewModel!
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        shareHViewModel = ShareHolderViewModel()
    }

    // MARK: - IBActions
    @IBAction func yesPressed(_ sender: SSSpinnerButton) {
        sender.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor._715AFF, spinnerSize: 20, complete: {
            self.shareHViewModel.update(answere: "yes")
        })

        shareHViewModel.sender = sender
        shareHViewModel.bindViewModelToController = {
            sender.stopAnimate {
                let router = ShareHolderRouter()
                router.routeToCompany(to: ShareholderQuestionVC.identifier, from: self, parameters: nil, animated: true)
            }
        }
    }

    @IBAction func noPressed(_ sender: SSSpinnerButton) {
        sender.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: {
            self.shareHViewModel.update(answere: "no")
        })

        shareHViewModel.sender = sender
        shareHViewModel.bindViewModelToController = {
            sender.stopAnimate {
                let router = ShareHolderRouter()
                router.route(to: ShareholderQuestionVC.identifier, from: self, parameters: nil, animated: true)
            }
        }
    }
}
