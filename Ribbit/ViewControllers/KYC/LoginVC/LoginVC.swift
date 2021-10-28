//
//  LoginVC.swift
//  Ribbit
//
//  Created by Rao Mudassar on 28/06/2021.

// MARK: User Login Interface class

import SSSpinnerButton
import SwiftyRSA
import TweeTextField
import UIKit

class LoginVC: BaseVC {
    // MARK: Outlets

    var iconClick = true

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
    private var signupViewModel: SignupViewModel!
    @IBOutlet var continueButton: SSSpinnerButton!
    @IBOutlet var eyeButton: UIButton!

    // MARK: Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showPassword(_ sender: Any) {
        if iconClick == true {
            passwordTextField.isSecureTextEntry = false
            self.eyeButton.setBackgroundImage(UIImage(named: "eye"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            self.eyeButton.setBackgroundImage(UIImage(named: "eyeclose"), for: .normal)
        }

        iconClick.toggle()
    }

    // MARK: IBActions

    @IBAction func signUp(_ sender: Any) {
        LoginVCRoute().route(to: SignUpVC.identifier, from: self, parameters: nil, animated: true)
    }

    @IBAction func forgotPWD(_ sender: Any) {
        LoginVCRoute().forgotRoute(to: ForgetPasswordVC.identifier, from: self, parameters: nil, animated: true)
    }

    @IBAction func continuePressed(_ sender: Any) {
        self.callToViewModelForUIUpdate(email: emailTextField.text!)
    }

    // MARK: call api models layers

    private func callToViewModelForUIUpdate(email: String) {
        continueButton.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: nil)
        self.signupViewModel = SignupViewModel(email: emailTextField.text!, password: Utils.encryptPassword(string: self.passwordTextField.text!), isLogin: true)
        self.signupViewModel.bindViewModelToController = {
            self.continueButton.stopAnimate(complete: nil)
            MagicLinkRouter().route(to: USER.shared.details?.user?.profileCompletion ?? STEPS.referral.rawValue, from: self, parameters: nil, animated: true)
        }
        self.signupViewModel.bindErrorViewModelToController = { _ in
            self.continueButton.stopAnimate(complete: nil)
        }
    }
}

// MARK: textfield delegates

extension LoginVC: UITextFieldDelegate {
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
        } else {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            let validator = Validator()
            if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty, .validatePassword]) {
                passwordTextField.showInfo(errorMsg)
                continueButton.setBackground(enable: false)
            } else {
                continueButton.setBackground(enable: true)
                passwordTextField.showInfo("")
            }

            return true
        }
    }
}
