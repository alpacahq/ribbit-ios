//
//  EmailVC.swift
//  Ribbit
//
//  Created by Adnan Asghar on 3/13/21.
//

import SSSpinnerButton
import TweeTextField
import UIKit
class EmailVC: BaseVC {
    // MARK: - IBOutlets
    @IBOutlet var txtEmail: TweeAttributedTextField! {
        didSet {
            txtEmail.delegate = self
        }
    }
    @IBOutlet var btnCont: UIButton!
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBActions

    @IBAction func continuePressed(_ sender: UIButton) {
        // reset error
        txtEmail.showInfo("")

        // validate text field
        let validator = Validator()
        if let errorMsg = validator.validate(text: txtEmail.text!, with: [.notEmpty, .validateEmail]) {
            txtEmail.showInfo(errorMsg)
            return
        }

        EmailRouter().route(to: MagicLinkVC.identifier, from: self, parameters: txtEmail.text!, animated: true)
    }
}

extension EmailVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        let validator = Validator()
        if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty, .validateEmail]) {
            txtEmail.showInfo(errorMsg)
            btnCont.setBackground(enable: false)
        } else {
            btnCont.setBackground(enable: true)
            txtEmail.showInfo("")
        }

        return true
    }
}
