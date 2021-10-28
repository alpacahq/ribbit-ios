//
// DOBVC.swift
// Ribbit
//
// Created by Adnan Asghar on 3/16/21.

// MARK: - Take the Date of birth of a user

import SSSpinnerButton
import TweeTextField
import UIKit
class DOBVC: BaseVC {
    // MARK: - IBOutlets
    @IBOutlet var txtD1: TweeAttributedTextField! {
        didSet {
            txtD1.delegate = self
        }
    }
    @IBOutlet var txtD2: TweeAttributedTextField!
    @IBOutlet var txtM1: TweeAttributedTextField!
    @IBOutlet var txtM2: TweeAttributedTextField!
    @IBOutlet var txtY1: TweeAttributedTextField!
    @IBOutlet var txtY2: TweeAttributedTextField!
    @IBOutlet var lblError: UILabel!
    @IBOutlet var btnCont: SSSpinnerButton!
    // MARK: - Variables

    @IBOutlet var lblError2: UILabel!

    private var dobVM: DOBViewModel!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setDataOnView()
    }
    // MARK: - IBActions

    @IBAction func continuePressed(_ sender: SSSpinnerButton) {
        let validator = Validator()
        if let errorMsg = validator.validate(text: txtD1.text!, with: [.notEmpty]) {
            lblError.text = errorMsg
            return
        }
        validateDateLimit(txtD1.text!)
        if lblError.text == "" {
            sender.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: {
                self.updateProfile(sender: sender)
            })
        }
    }

    // MARK: - Helpers
    private func updateProfile(sender: SSSpinnerButton) {
        let serverFormat = txtD1.text?.formattedServerDate ?? ""
        dobVM = DOBViewModel(dob: serverFormat)
        dobVM.sender = sender
        dobVM.bindViewModelToController = {
            sender.stopAnimate {
                self.openAddress()
            }
        }
    }

    private func openAddress() {
        let router = DOBRouter()
        router.route(to: AddressVC.identifier, from: self, parameters: nil, animated: true)
    }

    private func setDataOnView() {
        if let dateStr = USER.shared.details?.user?.dob?.replacingOccurrences(of: "-", with: "/"), dateStr != "" {
            self.txtD1.text = dateStr.formattedServerToAppDate
            self.btnCont.setBackground(enable: true)
        }
    }
}
// MARK: - Textfield Delegate

extension DOBVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    fileprivate func validateDateLimit(_ textField: String) {
        // Apply age limit
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        consoleLog("date to be validate", textField)
        if let date = dateFormatter.date(from: textField) {
            print(date)
            let min = Calendar.current.date(byAdding: .year, value: -18, to: Date())
            let max = Calendar.current.date(byAdding: .year, value: -150, to: Date())

            if date.isBetween(min!, and: max!) {
                lblError.text = ""
                lblError2.alpha = 0
                btnCont.setBackground(enable: true)
            } else {
                btnCont.setBackground(enable: false)
                lblError.text = "We do not support accounts for those under 18 years of age."
                lblError2.alpha = 1
            }
        } else {
            btnCont.setBackground(enable: false)
            lblError.text = "Invalid Date Format"
            lblError2.alpha = 0
            print("Date is Invalid") // if this prints date is invalid
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let charsLimit = 10
        let startingLength = text.count
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace

        let flag = newLength <= charsLimit

        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        if flag {
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if isBackSpace != -92 {
                    let newText = updatedText.applyPatternOnNumbers(pattern: "##/##/####", replacementCharacter: "#")
                    if newText.count <= charsLimit {
                        textField.text = newText
                        validateDateLimit(textField.text!)
                    } else {
                        textField.text = text.applyPatternOnNumbers(pattern: "##/##/####", replacementCharacter: "#")
                        validateDateLimit(textField.text!)
                    }
                    return false
                } else {
                    validateDateLimit(updatedText)
                    return true
                }
            }
            // validate text field
            let validator = Validator()
            if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty]) {
                lblError.text = errorMsg
                lblError2.alpha = 1
                btnCont.setBackground(enable: false)
            }

            validateDateLimit(updatedText)
            return false
        }

        validateDateLimit(text)
        return flag
    }
}
