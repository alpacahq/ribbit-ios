//
//  OTPVC.swift
//  Ribbit
//
//  Created by Rao Mudassar on 28/06/2021.

// MARK: - Purpose of this class to verify OTP.

import KWVerificationCodeView
import SSSpinnerButton
import TweeTextField
import UIKit

class OTPVC: BaseVC {
    // MARK: - outlets

    @IBOutlet var txtEmail: UILabel!
    @IBOutlet var btnContinue: SSSpinnerButton!
    private var signupViewModel: SignupViewModel!
    var isSignUp = true
    private  let loader: Loader = .fromNib()
    @IBOutlet var btnResend: UIButton!
    @IBOutlet var verificationCodeView: KWVerificationCodeView!

    // MARK: - variables

    var email: String! = ""
    var password: String! = ""

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        verificationCodeView.delegate = self

        self.txtEmail.text = email

        if self.isSignUp == true {
            btnResend.alpha = 0
        } else {
            btnResend.alpha = 1
        }
    }

    // MARK: - IBActions

    @IBAction func continuePressed(_ sender: Any) {
        btnContinue.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: nil)
        if self.isSignUp == true {
            self.OTPVerification()
        } else {
            let str = String(self.verificationCodeView.getVerificationCode())
            let obj = ["email": self.email ?? "", "token": str] as [String: Any]
            OTPRoute().route(to: ChangePasswordVC.identifier, from: self, parameters: obj, animated: true)
            self.btnContinue.stopAnimate(complete: nil)
        }
    }

    // MARK: - Call api layer

    func OTPVerification() {
        let str = String(self.verificationCodeView.getVerificationCode())
        let url = EndPoint.kServerBase + EndPoint.otp + str
        print(url)
        NetworkUtil.requestWithOutHeaders(apiMethod: url, parameters: nil, requestType: .get, showProgress: true, view: self.view, onSuccess: { resp -> Void in
            print(resp!)
            self.btnContinue.stopAnimate(complete: nil)
            if (resp as? [String: Any]) != nil {
                let dict = resp as? NSDictionary
                if (dict?["message"] as? String) == nil {
                    MagicLinkRouter().route(to: USER.shared.details?.user?.profileCompletion ?? STEPS.referral.rawValue, from: self, parameters: nil, animated: true)
                    self.btnContinue.stopAnimate(complete: nil)
                } else {
                    self.view.makeToast("Invalid OTP,Try Again")
                }
            } else {
                self.view.makeToast("Invalid OTP,Try Again")
            }
        }) { error in
            print(error)
            self.view.makeToast(error)
            self.btnContinue.stopAnimate(complete: nil)
        }
    }
    @IBAction func resend(_ sender: Any) {
        if self.isSignUp == true {
        } else {
            self.getPassword()
        }
    }
    @IBAction func emailPressed(_ sender: Any) {
        if let mailURL = URL(string: "message:") {
            if UIApplication.shared.canOpenURL(mailURL) {
                UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
            }
        }
    }
    func getPassword() {
        loader.setView(hasLoader: true)
        let url = EndPoint.kServerBase + EndPoint.forgotPassword
        let params = ["email": self.email ?? ""] as [String: Any]
        print(url)
        print(params)
        NetworkUtil.requestWithOutHeaders(apiMethod: url, parameters: params, requestType: .post, showProgress: true, view: self.view, onSuccess: { resp -> Void in
            self.btnContinue.stopAnimate(complete: nil)
            if (resp as? [String: Any]) != nil {
                self.loader.removeFromSuperview()
                let dict = resp as? NSDictionary
                if (dict?["message"] as? String) == "OTP sent." {
                    self.view.makeToast("OTP Code Sent.")
                } else {
                    self.view.makeToast("User doesn't exist.")
                }
            } else {
                self.view.makeToast("User doesn't exist.")
            }
        }) { error in
            print(error)
            self.loader.removeFromSuperview()
            self.view.makeToast(error)
        }
    }
}

// MARK: - KWVerificationCode delegtes

extension OTPVC: KWVerificationCodeViewDelegate {
    func didChangeVerificationCode() {
        if verificationCodeView.hasValidCode() {
            btnContinue.setBackground(enable: true)
        }
    }
}
