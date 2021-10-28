//
// CitizenVC.swift
// Ribbit
//
// Created by Adnan Asghar on 3/16/21.

// MARK: - Take citizen code from user.

import IQKeyboardManagerSwift
import SSSpinnerButton
import TweeTextField
import UIKit
class CitizenVC: BaseVC {
    // MARK: - IBOutlets
    @IBOutlet var txtCountry: TweeAttributedTextField!

    @IBOutlet var btnCont: SSSpinnerButton!
    // MARK: - Variables
    private var router: CitizenRouter!
    private var citizenViewModel: CitizenViewModel!
    private var cCode = ""

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        router = CitizenRouter()
        citizenViewModel = CitizenViewModel()
        setView(field: txtCountry)
        setDataOnView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
    }

    // MARK: - IBActions

    @IBAction func continuePressed(_ sender: SSSpinnerButton) {
        let validator = Validator()
        if let errorMsg = validator.validate(text: txtCountry.text!, with: [.notEmpty]) {
            txtCountry.showInfo(errorMsg)
            return
        }

        sender.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: {
            self.updateProfile(sender: sender)
        })
    }
    @IBAction func didBeiginEdit(_ sender: UITextField) {
        if sender == txtCountry {
            txtCountry.showInfo("")
            router.route(to: CountryListVC.identifier, from: self, parameters: nil, animated: true)
        }
    }
    fileprivate func setView(field: TweeAttributedTextField) {
        field.inputView = UIView()
        field.rightViewMode = .always
        field.rightView = UIImageView(image: UIImage(named: "down"))
    }

    private func updateProfile(sender: SSSpinnerButton) {
        citizenViewModel.updateProfile(country: txtCountry.text!, code: cCode)
        citizenViewModel.sender = sender
        citizenViewModel.bindViewModelToController = {
            sender.stopAnimate {
                self.router.route(to: VerifyIdentityVC.identifier, from: self, parameters: nil, animated: true)
            }
        }
    }

    private func setDataOnView() {
        txtCountry.text = USER.shared.details?.user?.country
        if txtCountry.text != "" {
            self.btnCont.setBackground(enable: true)
        }

        cCode = USER.shared.details?.user?.countryCode ?? ""
    }
}

// MARK: - Country list delegate

extension CitizenVC: CountryDelegate {
    func didSelectCountry(item: String, code: String, reqType: RequestType) {
        self.txtCountry.text = item
        cCode = code
        self.btnCont.setBackground(enable: true)
    }
}
