//
//  AddressVC.swift
//  Ribbit
//
//  Created by Adnan Asghar on 3/16/21.

// MARK: - Take Residential info of a user.

import IQKeyboardManagerSwift
import SSSpinnerButton
import TweeTextField
import UIKit
class AddressVC: BaseVC {
    // MARK: - IBOutlets
    @IBOutlet var addressField: TweeAttributedTextField! {
        didSet {
            addressField.delegate = self
        }
    }

    @IBOutlet var txtState: TweeAttributedTextField! {
        didSet {
            txtState.delegate = self
        }
    }

    @IBOutlet var txtCity: TweeAttributedTextField! {
        didSet {
            txtCity.delegate = self
        }
    }

    @IBOutlet var zipCode: TweeAttributedTextField! {
        didSet {
            zipCode.delegate = self
        }
    }
    @IBOutlet var txtAppartment: TweeAttributedTextField! {
        didSet {
            txtAppartment.delegate = self
        }
    }

    @IBOutlet var btnCont: SSSpinnerButton!
    @IBOutlet var locBtn: UIButton!
    // MARK: - Variables
    private var addressViewModel: AddressViewModel!
    private let router = AddressRouter()
    private var city = ""
    private var state = ""
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addressViewModel = AddressViewModel()
        addressViewModel.bindAddressViewModelToController = { addrss in
            self.addressField.text = addrss
            self.addressField.showInfo("")
            if self.state != "" && self.city != "" {
                self.btnCont.setBackground(enable: true)
            }
        }
        setView(field: txtState)
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
        // reset error
        addressField.showInfo("")

        // validate text field
        let validator = Validator()
        if let errorMsg = validator.validate(text: addressField.text!, with: [.notEmpty]) {
            addressField.showInfo(errorMsg)
            return
        }

        if let errorMsg = validator.validate(text: txtState.text!, with: [.notEmpty]) {
            txtState.showInfo(errorMsg)
            return
        }
        if let errorMsg = validator.validate(text: txtCity.text!, with: [.notEmpty]) {
            txtCity.showInfo(errorMsg)
            return
        }

        sender.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: {
            self.updateProfile(sender: sender)
        })
    }
    // MARK: - Helpers

    @IBAction func getAddress(_ sender: UIButton) {
        addressViewModel.getAddress()
    }

    private func updateProfile(sender: SSSpinnerButton) {
        addressViewModel.updateProfile(address: addressField.text ?? "", state: self.state, city: self.txtCity.text ?? "", zipCode: self.zipCode.text ?? " ", apartment: self.txtAppartment.text ?? "")
        addressViewModel.sender = sender
        addressViewModel.bindViewModelToController = {
            sender.stopAnimate {
                self.openCitizenVC()
            }
        }
    }

    private func openCitizenVC() {
        router.route(to: CitizenVC.identifier, from: self, parameters: nil, animated: true)
    }

    fileprivate func setView(field: TweeAttributedTextField) {
        field.inputView = UIView()
        field.rightViewMode = .always
        field.rightView = UIImageView(image: UIImage(named: "down"))
    }

    private func setDataOnView() {
        if let adderss = USER.shared.details?.user?.address, adderss != "", let stateCode = USER.shared.details?.user?.state, stateCode != "" {
            addressField.text = adderss
            txtAppartment.text = USER.shared.details?.user?.apartment
            txtCity.text = USER.shared.details?.user?.city
            txtState.text = USER.shared.details?.user?.state

            self.zipCode.text = USER.shared.details?.user?.zipCode ?? " "
            self.btnCont.setBackground(enable: true)
            addressViewModel.getStateName()
            addressViewModel.stateNameBinding = { name in
                self.txtState.text = name
                self.state = stateCode
                self.btnCont.setBackground(enable: true)
            }
        }
    }
}

// MARK: - Textfield Delegate

extension AddressVC: UITextFieldDelegate {
    @IBAction func didBeiginEdit(_ sender: UITextField) {
        if sender == txtState {
            txtState.showInfo("")
            router.route(to: CountryListVC.identifier, from: self, parameters: ["country": "USA"], animated: true)
        } else {
            txtCity.showInfo("")
            router.route(to: CountryListVC.identifier, from: self, parameters: ["country": "USA", "state": state], animated: true)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // validate text field
        if textField == addressField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            let validator = Validator()
            if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty]) {
                addressField.showInfo(errorMsg)
                btnCont.setBackground(enable: false)
            } else {
                addressField.showInfo("")
                if addressField.text != "" && txtCity.text != "" && txtState.text != "" && zipCode.text != "" {
                    btnCont.setBackground(enable: true)
                }
            }
            return true
        } else if textField == txtState {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            let validator = Validator()
            if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty]) {
                txtState.showInfo(errorMsg)
                btnCont.setBackground(enable: false)
            } else {
                txtState.showInfo("")
                if addressField.text != "" && txtCity.text != "" && txtState.text != "" && zipCode.text != "" {
                    btnCont.setBackground(enable: true)
                }
            }
            return true
        } else if textField == txtCity {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            let validator = Validator()
            if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty]) {
                txtCity.showInfo(errorMsg)
                btnCont.setBackground(enable: false)
            } else {
                txtCity.showInfo("")
                if addressField.text != "" && txtCity.text != "" && txtState.text != "" && zipCode.text != "" {
                    btnCont.setBackground(enable: true)
                }
            }
            return true
        } else if textField == zipCode {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            let validator = Validator()
            if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty, .validateZip]) {
                zipCode.showInfo(errorMsg)
                btnCont.setBackground(enable: false)
            } else {
                zipCode.showInfo("")
                if addressField.text != "" && txtCity.text != "" && txtState.text != "" && zipCode.text != "" {
                    btnCont.setBackground(enable: true)
                }
            }
            return true
        } else {
            return true
        }
    }
}

class TextFieldWithPadding: TweeAttributedTextField {
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 5,
        bottom: 0,
        right: 35
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
extension AddressVC: CountryDelegate {
    func didSelectCountry(item: String, code: String, reqType: RequestType) {
        self.btnCont.setBackground(enable: false)

        switch reqType {
        case .stateList:
            self.txtState.text = item
            self.state = code
        default:
            self.btnCont.setBackground(enable: true)
        }
    }
}
