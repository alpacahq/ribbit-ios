//
//  SignUpVCRoute.swift
//  Ribbit
//
//  Created by Rao Mudassar on 28/06/2021.
//
import UIKit
class SignUpVCRoute: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let loginVC = UIStoryboard.main.instantiateViewController(withIdentifier: LoginVC.identifier) as? LoginVC {
                context.navigationController?.pushViewController(loginVC, animated: animated)
        }
    }
    func routeOTP(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let OTPVC = UIStoryboard.main.instantiateViewController(withIdentifier: OTPVC.identifier) as? OTPVC {
            let dic = parameters as? [String: Any]
            OTPVC.email = dic?["email"] as? String
            OTPVC.password = dic?["password"] as? String
            OTPVC.isSignUp = true
                context.navigationController?.pushViewController(OTPVC, animated: animated)
        }
    }
}
