//
//  ForgetPasswordRouter.swift
//  Ribbit
//
//  Created by Rao Mudassar on 28/06/2021.
//

import UIKit

class ForgetPasswordRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let OTPVC = UIStoryboard.main.instantiateViewController(withIdentifier: OTPVC.identifier) as? OTPVC {
            let dic = parameters as? [String: Any]
            OTPVC.email = dic?["email"] as? String
            OTPVC.password = dic?["password"] as? String
            OTPVC.isSignUp = false
                context.navigationController?.pushViewController(OTPVC, animated: animated)
        }
    }
}
