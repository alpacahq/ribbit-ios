//
//  BrokerageQuestionVC.swift
//  Ribbit
//
//  Created by Adnan Asghar on 3/17/21.

// MARK: - Ask from user about Brokerages.

import SSSpinnerButton
import UIKit
class BrokerageQuestionVC: UIViewController {
    // MARK: - IBOutlets

    // MARK: - Variables
    private var brokViewModel: BrokerageViewModel!
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        brokViewModel = BrokerageViewModel()
    }

    // MARK: - IBActions
    @IBAction func yesPressed(_ sender: SSSpinnerButton) {
        sender.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor._715AFF, spinnerSize: 20, complete: {
            self.brokViewModel.update(answere: "yes")
        })
        brokViewModel.sender = sender
        brokViewModel.bindViewModelToController = {
            sender.stopAnimate {
                let router = BrokerageRouter()
                router.routeToBrokerage(to: BrokerageInfoVC.identifier, from: self, parameters: nil, animated: true)
            }
        }
    }
    @IBAction func noPressed(_ sender: SSSpinnerButton) {
        sender.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: {
            self.brokViewModel.update(answere: "no")
        })

        brokViewModel.sender = sender
        brokViewModel.bindViewModelToController = {
            sender.stopAnimate {
                let router = BrokerageRouter()
                router.route(to: PreviewApplicationVC.identifier, from: self, parameters: nil, animated: true)
            }
        }
    }
}
