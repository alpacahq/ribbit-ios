//
//  NameVC.swift
//  Ribbit
//
//  Created by Adnan Asghar on 3/16/21.

// MARK: - Take the full name of a user

import SSSpinnerButton
import TweeTextField
import UIKit
class NameVC: BaseVC {
    // MARK: - IBOutlets
    @IBOutlet var txtFirstName: TweeAttributedTextField!
    @IBOutlet var txtLastName: TweeAttributedTextField!
    @IBOutlet var btnCont: SSSpinnerButton!
    // MARK: - Variables
    private var nameVM: NameViewModel!
    private var router: NameRouter!

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setDataOnView()
    }

    // MARK: - IBActions

    @IBAction func continuePressed(_ sender: SSSpinnerButton) {
        // reset error
        txtFirstName.showInfo("")
        txtLastName.showInfo("")

        // validate text field
        let validator = Validator()
        if let errorMsg = validator.validate(text: txtFirstName.text!, with: [.notEmpty]) {
            txtFirstName.showInfo(errorMsg)
        }
        if let errorMsg = validator.validate(text: txtLastName.text!, with: [.notEmpty]) {
            txtLastName.showInfo(errorMsg)
            return
        }

        sender.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: {
            self.updateProfile(sender: sender)
        })
    }

    // MARK: - Helpers

    private func updateProfile(sender: SSSpinnerButton) {
        self.nameVM = NameViewModel(firstName: txtFirstName.text!, lastName: txtLastName.text!)
        self.nameVM.sender = sender
        self.nameVM.bindViewModelToController = {
            sender.stopAnimate {
                self.openPhoneVC()
            }
        }
    }

    private func openPhoneVC() {
        router = NameRouter()
        router.route(to: PhoneVC.identifier, from: self, parameters: nil, animated: true)
    }

    private func setDataOnView() {
        if let fName = USER.shared.details?.user?.firstName, let lName = USER.shared.details?.user?.lastName, lName != "" {
            txtFirstName.text = fName
            txtLastName.text = lName
            btnCont.setBackground(enable: true)
        }
    }
}

// MARK: - Textfield Delegate

extension NameVC: UITextFieldDelegate {
    private func noError () -> Bool {
        return (txtFirstName.infoLabel.text == "" && txtLastName.infoLabel.text == "") || (txtFirstName.infoLabel.text == nil && txtLastName.infoLabel.text == nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFirstName {
            txtLastName.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        let validator = Validator()
        if textField == txtFirstName {
            if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty]) {
                txtFirstName.showInfo(errorMsg)
                btnCont.setBackground(enable: false)
            } else {
                txtFirstName.showInfo("")
                if noError() {
                    btnCont.setBackground(enable: true)
                }
            }
        } else {
            if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty]) {
                txtLastName.showInfo(errorMsg)
                btnCont.setBackground(enable: false)
            } else {
                txtLastName.showInfo("")
                if noError() {
                    btnCont.setBackground(enable: true)
                }
            }
        }

        return true
    }
}
