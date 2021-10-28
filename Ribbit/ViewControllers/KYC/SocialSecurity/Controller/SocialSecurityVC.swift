//
//  SocialSecurityVC.swift
//  Ribbit
//
//  Created by Ahsan Ali on 17/03/2021.

// MARK: - Take social security number

import SSSpinnerButton
import TweeTextField
import UIKit
class SocialSecurityVC: BaseVC {
    // MARK: - Outlets
    @IBOutlet var lblError: UILabel!
    @IBOutlet var txtS1: TweeAttributedTextField!
    @IBOutlet var txtS2: TweeAttributedTextField!
    @IBOutlet var txtS3: TweeAttributedTextField!
    @IBOutlet var btnCont: SSSpinnerButton!
    // MARK: - Vars

    private var ssnViewModel: SSNViewModel!
    private var comptextSSN = ""
    // MARK: - Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataOnView()
    }

    // MARK: - IBActions

    @IBAction func EYE(_ sender: UIButton) {
        sender.isSelected.toggle()

        txtS1.isSecureTextEntry = sender.isSelected
        txtS2.isSecureTextEntry = sender.isSelected
        txtS3.isSecureTextEntry = sender.isSelected
    }

    @IBAction func continuePressed(_ sender: SSSpinnerButton) {
        lblError.text = ""
        // validate text field
        let validator = Validator()
        if let errorMsg = validator.validate(text: txtS1.text!, with: [.notEmpty]) {
            lblError.text = errorMsg
            return
        } else if let errorMsg = validator.validate(text: txtS2.text!, with: [.notEmpty]) {
            lblError.text = errorMsg
            return
        } else if let errorMsg = validator.validate(text: txtS3.text!, with: [.notEmpty]) {
            lblError.text = errorMsg
            return
        }

        comptextSSN = txtS1.text! + txtS2.text! + txtS3.text!

        if let errorMsg = validator.validate(text: comptextSSN, with: [.validateSSN]) {
            lblError.text = errorMsg
            return
        }

        sender.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: {
            self.updateProfile(sender: sender)
        })
    }

    // MARK: - Helpers
    private func updateProfile(sender: SSSpinnerButton) {
        ssnViewModel = SSNViewModel(ssn: self.comptextSSN)
        ssnViewModel.sender = sender
        ssnViewModel.bindViewModelToController = {
            sender.stopAnimate {
                let router = SSNRouter()
                router.route(to: InvestingExperienceVC.identifier, from: self, parameters: nil, animated: true)
            }
        }
    }
    private func setDataOnView() {
        let ssn = USER.shared.details?.user?.taxID ?? ""
        if ssn.count == 9 {
            txtS1.text = String(ssn.prefix(3))
            // txtS2.text = ssn.substr(3, 2)
            // txtS3.text = ssn.substr(5, 4)
            btnCont.setBackground(enable: true)
        }
        txtS1.isSecureTextEntry = true
        txtS2.isSecureTextEntry = true
        txtS3.isSecureTextEntry = true
    }
}
// MARK: - Textfield Delegate
extension SocialSecurityVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    fileprivate func validateAfter() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            // validate if there is change
            self.comptextSSN = self.txtS1.text! + self.txtS2.text! + self.txtS3.text!
            consoleLog(self.comptextSSN)
            if let errorMsg = Validator().validate(text: self.comptextSSN, with: [.validateSSN]) {
                self.lblError.text = errorMsg
                self.btnCont.setBackground(enable: false)
            } else {
                self.btnCont.setBackground(enable: true)
                self.lblError.text = ""
            }
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        var flag = true

        consoleLog(updatedText.count)
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                if updatedText.count == 0 {
                    textField.text = ""
                    switch textField {
                    case txtS3:
                        txtS2.becomeFirstResponder()
                    case txtS2:
                        txtS1.becomeFirstResponder()
                    default:break
                    }
                    flag = false
                }
            } else {
                switch textField {
                case txtS1:
                    if updatedText.count >= 3 {
                        if updatedText.count == 3 {
                            textField.text = updatedText
                        } else {
                            flag = false
                        }
                        txtS2.becomeFirstResponder()
                    }
                case txtS2:
                    if updatedText.count >= 2 {
                        if updatedText.count == 2 {
                            textField.text = updatedText
                        } else {
                            flag = false
                        }
                        txtS3.becomeFirstResponder()
                    }
                default:
                    if updatedText.count >= 4 {
                        if updatedText.count == 4 {
                            textField.text = updatedText
                        } else {
                            flag = false
                        }
                        textField.resignFirstResponder()
                    }
                }
            }
        }

        if flag { validateAfter()
        }
        return flag
    }
}
