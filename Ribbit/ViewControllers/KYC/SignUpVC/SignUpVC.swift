//
//  SignUpVC.swift
//  Ribbit
//
//  Created by Rao Mudassar on 28/06/2021.

// MARK: user register itself by using this.

import SSSpinnerButton
import TweeTextField
import UIKit
class SignUpVC: BaseVC {
    // MARK: Variables
    var iconClick = true
    var iconClickSecond = true

    // MARK: - Outlets
    @IBOutlet var eyeButtonFirst: UIButton!
    @IBOutlet var eyeButtonSecond: UIButton!
    @IBOutlet var emailTextField: TweeAttributedTextField! {
        didSet {
            emailTextField.delegate = self
        }
    }
    @IBOutlet var passwordTextField: TweeAttributedTextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }
    @IBOutlet var confirmPasswordTextField: TweeAttributedTextField! {
        didSet {
            confirmPasswordTextField.delegate = self
        }
    }
    private var signupViewModel: SignupViewModel!
    @IBOutlet var continueButton: SSSpinnerButton!

    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBActions

    @IBAction func continuePressed(_ sender: Any) {
        if confirmPasswordTextField.text! == passwordTextField.text! {
            confirmPasswordTextField.showInfo("")
            passwordTextField.showInfo("")
            self.callToViewModelForUIUpdate(password: self.passwordTextField.text!)
        } else {
            confirmPasswordTextField.showInfo("Passwords must be same")
        }
    }

    // MARK: - call apis models layers

    private func callToViewModelForUIUpdate(password: String) {
        continueButton.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: nil)
        self.signupViewModel = SignupViewModel(email: emailTextField.text!, password: Utils.encryptPassword(string: password), isLogin: false)
        self.signupViewModel.bindViewModelToController = {
            self.continueButton.stopAnimate(complete: nil)
            let obj = ["email": self.emailTextField.text!, "password": self.passwordTextField.text!] as [String: Any]
            SignUpVCRoute().routeOTP(to: OTPVC.identifier, from: self, parameters: obj, animated: true)
        }
        self.signupViewModel.bindErrorViewModelToController = { _ in
            self.continueButton.stopAnimate(complete: nil)
        }
    }
    @IBAction func login(_ sender: Any) {
        SignUpVCRoute().route(to: LoginVC.identifier, from: self, parameters: nil, animated: true)
    }
    @IBAction func showEyeFirst(_ sender: Any) {
        if iconClick == true {
            passwordTextField.isSecureTextEntry = false
            self.eyeButtonFirst.setBackgroundImage(UIImage(named: "eye"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            self.eyeButtonFirst.setBackgroundImage(UIImage(named: "eyeclose"), for: .normal)
        }

        iconClick.toggle()
    }
    @IBAction func showEyeSecond(_ sender: Any) {
        if iconClickSecond == true {
            confirmPasswordTextField.isSecureTextEntry = false
            self.eyeButtonSecond.setBackgroundImage(UIImage(named: "eye"), for: .normal)
        } else {
            confirmPasswordTextField.isSecureTextEntry = true
            self.eyeButtonSecond.setBackgroundImage(UIImage(named: "eyeclose"), for: .normal)
        }
        iconClickSecond.toggle()
    }
}

// MARK: - textfield delegates

extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            let validator = Validator()
            if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty, .validateEmail]) {
                emailTextField.showInfo(errorMsg)
            } else {
                emailTextField.showInfo("")
            }

            return true
        } else if textField == passwordTextField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            let validator = Validator()
            if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty, .validatePassword]) {
                if updatedText == "" {
                    passwordTextField.showInfo("")
                } else {
                    passwordTextField.showInfo(errorMsg)
                }
            } else {
                passwordTextField.showInfo("")
            }

            return true
        } else {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            let validator = Validator()
            if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty, .validatePassword]) {
                confirmPasswordTextField.showInfo(errorMsg)
                if updatedText == "" {
                    confirmPasswordTextField.showInfo("")
                } else {
                    confirmPasswordTextField.showInfo(errorMsg)
                }
                continueButton.setBackground(enable: false)
            } else {
                if self.passwordTextField.text! == updatedText {
                    continueButton.setBackground(enable: true)
                    passwordTextField.showInfo("")
                    confirmPasswordTextField.showInfo("")
                } else {
                    continueButton.setBackground(enable: false)
                    confirmPasswordTextField.showInfo("Passwords must be same")
                }
            }

            return true
        }
    }
}
