//
//  PhoneVC.swift
//  Ribbit
//
//  Created by Adnan Asghar on 3/16/21.

// MARK: - Take the phone number of a user

import SSSpinnerButton
import TweeTextField
import UIKit
class PhoneVC: BaseVC {
    // MARK: - IB-Outlets
    @IBOutlet var txtPhone: TweeAttributedTextField!
    @IBOutlet var btnCont: SSSpinnerButton!
    // MARK: - Variables
    private var phoneVM: PhoneViewModel!
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setDataOnView()
    }

    // MARK: - IBActions
    @IBAction func continuePressed(_ sender: SSSpinnerButton) {
        // reset error
        txtPhone.showInfo("")
        let num = txtPhone.text?.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "") ?? ""
        // validate text field
        let validator = Validator()
        if let errorMsg = validator.validate(text: num, with: [.notEmpty, .validatePhone]) {
            txtPhone.showInfo(errorMsg)
            return
        }

        sender.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: {
            self.updateProfile(sender: sender)
        })
    }

    // MARK: - Helpers
    private func updateProfile(sender: SSSpinnerButton) {
        let num = txtPhone.text?.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "") ?? ""
        phoneVM = PhoneViewModel(phone: num)
        phoneVM.sender = sender
        phoneVM.bindViewModelToController = {
            sender.stopAnimate {
                self.openDOB()
            }
        }
    }
    private func openDOB() {
        let router = PhoneRouter()
        router.route(to: DOBVC.identifier, from: self, parameters: nil, animated: true)
    }

    private func setDataOnView() {
        txtPhone.delegate = self
        if let phone = USER.shared.details?.user?.mobile, phone != "" {
            txtPhone.text = phone.replacingOccurrences(of: "+1", with: "").applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            btnCont.setBackground(enable: true)
        }
    }
}

extension PhoneVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let charsLimit = 14

        let startingLength = text.count
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace

        let flag = newLength <= charsLimit
        if flag {
            txtPhone.showInfo("")
            textField.text = text.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
        }

        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        let num = updatedText.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
        // validate text field
        let validator = Validator()
        if let errorMsg = validator.validate(text: num, with: [.notEmpty, .validatePhone]) {
            txtPhone.showInfo(errorMsg)
            btnCont.setBackground(enable: false)
        } else {
            txtPhone.showInfo("")
            btnCont.setBackground(enable: true)
        }

        return flag
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
