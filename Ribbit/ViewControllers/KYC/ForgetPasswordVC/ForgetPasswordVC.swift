//
//  ForgetPasswordVC.swift
//  Ribbit
//
//  Created by Rao Mudassar on 28/06/2021.

// MARK: Purpose of this class to Recover password.

import SSSpinnerButton
import TweeTextField
import UIKit

class ForgetPasswordVC: BaseVC {
    // MARK: Outlets

    @IBOutlet var txtEmail: TweeAttributedTextField! {
        didSet {
            txtEmail.delegate = self
        }
    }
    @IBOutlet var btnContinue: SSSpinnerButton!

    // MARK: Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: IBActions

    @IBAction func sendLink(_ sender: Any) {
        self.btnContinue.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: nil)
        self.getPassword()
    }

    // MARK: Call api layers

    func getPassword() {
        let url = EndPoint.kServerBase + EndPoint.forgotPassword
        let params = ["email": self.txtEmail.text!] as [String: Any]
        print(url)
        print(params)
        NetworkUtil.requestWithOutHeaders(apiMethod: url, parameters: params, requestType: .post, showProgress: true, view: self.view, onSuccess: { resp -> Void in
            print(resp!)
            self.btnContinue.stopAnimate(complete: nil)
            if (resp as? [String: Any]) != nil {
                if SwiftParseUtils.parseForgotPasswordData(object: resp as? [String: Any] ?? ["": ""], view: self.view) == "OTP sent." {
                    let obj = ["email": self.txtEmail.text!, "password": ""] as [String: Any]
                    ForgetPasswordRouter().route(to: OTPVC.identifier, from: self, parameters: obj, animated: true)
                } else {
                    self.view.makeToast("User doesn't exist.")
                }
            } else {
                self.view.makeToast("User doesn't exist.")
            }
        }) { error in
            print(error)
            self.view.makeToast(error)
            self.btnContinue.stopAnimate(complete: nil)
        }
    }
}
// MARK: textfield delegates
extension ForgetPasswordVC: UITextFieldDelegate {
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
            btnContinue.setBackground(enable: false)
        } else {
            btnContinue.setBackground(enable: true)
            txtEmail.showInfo("")
        }
        return true
    }
}
