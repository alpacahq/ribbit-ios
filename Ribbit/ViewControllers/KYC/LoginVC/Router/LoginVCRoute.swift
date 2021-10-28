//
//  LoginVCRoute.swift
//  Ribbit
//
//  Created by Rao Mudassar on 28/06/2021.
//

import UIKit

class LoginVCRoute: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let signUpVC = UIStoryboard.main.instantiateViewController(withIdentifier: SignUpVC.identifier) as? SignUpVC {
                context.navigationController?.pushViewController(signUpVC, animated: animated)
        }
    }

    func forgotRoute(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let forgetPasswordVC = UIStoryboard.main.instantiateViewController(withIdentifier: ForgetPasswordVC.identifier) as? ForgetPasswordVC {
                context.navigationController?.pushViewController(forgetPasswordVC, animated: animated)
        }
    }
}
