//
//  EmployedVC.swift
//  Ribbit
//
//  Created by Ahsan Ali on 17/03/2021.

// MARK: - Choose option from multiple employed status.

import SSSpinnerButton
import UIKit
class EmployedVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet var  btnEmployed: UIButton!
    @IBOutlet var  btnUnEmployed: UIButton!
    @IBOutlet var btnRetired: UIButton!
    @IBOutlet var  btnStudent: UIButton!
    @IBOutlet var btnCont: SSSpinnerButton!
    // MARK: - variables
    private var lastSelectedbtn: UIButton?
    private var empViewModel: EmployedViewModel!

    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataOnView()
    }

    // MARK: - IBActions
    fileprivate func selecteButton(_ sender: UIButton) {
        if lastSelectedbtn != nil {
            lastSelectedbtn?.borderColorV = UIColor(named: "lightgray 50%")
        }
        sender.borderColorV = ._715AFF
        lastSelectedbtn = sender
        btnCont.setBackground(enable: true)
    }

    @IBAction func optionPressed(_ sender: UIButton) {
        selecteButton(sender)
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
        empViewModel = EmployedViewModel(tag: lastSelectedbtn!.tag)
        empViewModel.sender = sender
        empViewModel.bindViewModelToController = {
            sender.stopAnimate {
                if self.lastSelectedbtn!.tag == 0 {
                    let router = EmployedRouter()
                    router.routeToWork(to: WorkInfoVC.identifier, from: self, parameters: nil, animated: true)
                } else {
                    let router = EmployedRouter()
                    router.route(to: ShareholderQuestionVC.identifier, from: self, parameters: nil, animated: true)
                }
            }
        }
    }

    private func setDataOnView() {
        if  let status = USER.shared.details?.user?.employmentStatus, let statValue = EmploymentStatus(rawValue: status) {
            switch statValue {
            case .employed: selecteButton(btnEmployed)
            case .unemployed: selecteButton(btnEmployed)
            case .retired: selecteButton(btnRetired)
            default:
                selecteButton(btnStudent)
            }
        }
    }
}
