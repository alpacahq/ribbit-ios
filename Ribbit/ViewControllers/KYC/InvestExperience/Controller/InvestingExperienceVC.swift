//
// InvestingExperienceVC.swift
// Ribbit
//
// Created by Ahsan Ali on 17/03/2021.

// MARK: - choose option from multiple Investing experience options

import SSSpinnerButton
import UIKit
class InvestingExperienceVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet var  btnNone: UIButton!
    @IBOutlet var  btnNotMuch: UIButton!
    @IBOutlet var  btnKnow: UIButton!
    @IBOutlet var  btnExpert: UIButton!
    @IBOutlet var btnCont: SSSpinnerButton!
    private var lastSelectedbtn: UIButton?
    private var ieViewModel: IEViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setDataOnView()
    }
    // MARK: - IBActions
    fileprivate func selectButton(_ sender: UIButton) {
        if lastSelectedbtn != nil {
            lastSelectedbtn?.borderColorV = UIColor(named: "lightgray 50%")
        }
        sender.borderColorV = ._715AFF
        lastSelectedbtn = sender
        btnCont.setBackground(enable: true)
    }
    @IBAction func optionPressed(_ sender: UIButton) {
        selectButton(sender)
    }
    @IBAction func continuePressed(_ sender: SSSpinnerButton) {
        if lastSelectedbtn != nil {
            sender.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: {
                self.updateProfile(sender: sender)
            })
        }
    }
    // MARK: - Helpers
    private func updateProfile(sender: SSSpinnerButton) {
        ieViewModel = IEViewModel(investingExperience: lastSelectedbtn!.title(for: .normal)!)
        ieViewModel.sender = sender
        ieViewModel.bindViewModelToController = {
            sender.stopAnimate {
                let router = IExpRouter()
                router.route(to: FundingSourceVC.identifier, from: self, parameters: nil, animated: true)
            }
        }
    }
    private func setDataOnView() {
        if  let exp = USER.shared.details?.user?.investingExperience, exp != "" {
            if exp.contains("doing") {
                selectButton(btnKnow)
            } else {
                switch exp {
                case "None": selectButton(btnNone)
                case "Not Much":  selectButton(btnNotMuch)
                default:selectButton(btnExpert)
                }
            }
        }
    }
}
