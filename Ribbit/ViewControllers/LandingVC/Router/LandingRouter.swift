//
//  LandingRouter.swift
//  Ribbit
//
//  Created by Ahsan Ali on 08/04/2021.
//

import UIKit

class LandingRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let loginVC = UIStoryboard.main.instantiateViewController(withIdentifier: LoginVC.identifier) as? LoginVC {
            context.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    func routeSignUp(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let signUpVC = UIStoryboard.main.instantiateViewController(withIdentifier: SignUpVC.identifier) as? SignUpVC {
            context.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
}
