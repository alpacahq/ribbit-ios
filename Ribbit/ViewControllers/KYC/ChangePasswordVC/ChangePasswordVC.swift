//
//  ChangePasswordVC.swift
//  Ribbit
//
//  Created by Rao Mudassar on 29/06/2021.
// MARK: Purpose of this class to change previous password.

import SSSpinnerButton
import TweeTextField
import UIKit

class ChangePasswordVC: BaseVC {
    // MARK: Outlets

    @IBOutlet var txtPassword: TweeAttributedTextField! {
        didSet {
            txtPassword.delegate = self
        }
    }
    @IBOutlet var txtConfirm: TweeAttributedTextField! {
        didSet {
            txtConfirm.delegate = self
        }
    }

    // MARK: Varables

    var email: String! = ""
    var token: String! = ""
    @IBOutlet var btnContinue: SSSpinnerButton!
    @IBOutlet var btnConfirm: UIButton!

    // MARK: Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: IBActions

    @IBAction func continuePressed(_ sender: Any) {
        if txtConfirm.text! == txtPassword.text! {
            txtConfirm.showInfo("")
            txtPassword.showInfo("")
            self.btnConfirm.alpha = 1
            btnContinue.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: nil)
            self.changePassword()
        } else {
            self.btnConfirm.alpha = 0
            txtConfirm.showInfo("Passwords must be same")
        }
    }

    // MARK: call api layers

    func changePassword() {
        let url = EndPoint.kServerBase + EndPoint.changePassword
        let params = ["email": self.email ?? "", "password": Utils.encryptPassword(string: self.txtPassword.text!), "confrim_password": Utils.encryptPassword(string: self.txtPassword.text!), "otp": self.token ?? ""] as [String: Any]
        print(url)
        print(params)
        NetworkUtil.requestWithOutHeaders(apiMethod: url, parameters: params, requestType: .post, showProgress: true, view: self.view, onSuccess: { resp -> Void in
            print(resp!)
            self.btnContinue.stopAnimate(complete: nil)
            if (resp as? [String: Any]) != nil {
                let dict = resp as? NSDictionary
                if (dict?["message"] as? String) != "Invalid OTP" {
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: LoginVC.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                } else {
                    let alert = UIAlertController(title: "Error", message: "Your otp is invalid.Please try again.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { _ -> Void in
                        self.navigationController?.popViewController(animated: true)
                    })))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Your otp is invalid.Please try again.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { _ -> Void in
                    self.navigationController?.popViewController(animated: true)
                })))

                self.present(alert, animated: true, completion: nil)
            }
        }) { error in
            print(error)

            self.view.makeToast(error)
            self.btnContinue.stopAnimate(complete: nil)
        }
    }
}

// MARK: textfield delegates

extension ChangePasswordVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.btnConfirm.alpha = 0
        if textField == txtPassword {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            let validator = Validator()
            if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty, .validatePassword]) {
                if updatedText == "" {
                    txtPassword.showInfo("")
                } else {
                    txtPassword.showInfo(errorMsg)
                }
            } else {
                txtPassword.showInfo("")
            }
            return true
        } else {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            let validator = Validator()
            if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty, .validatePassword]) {
                if updatedText == "" {
                    txtConfirm.showInfo("")
                } else {
                    txtConfirm.showInfo(errorMsg)
                }
                btnContinue.setBackground(enable: false)
            } else {
                if self.txtPassword.text! == updatedText {
                    btnContinue.setBackground(enable: true)
                    txtPassword.showInfo("")
                    txtConfirm.showInfo("")
                    self.btnConfirm.alpha = 1
                } else {
                    btnContinue.setBackground(enable: false)
                    self.btnConfirm.alpha = 0
                    txtConfirm.showInfo("Passwords must be same")
                }
            }
            return true
        }
    }
}
