//
//  OTPRoute.swift
//  Ribbit
//
//  Created by Rao Mudassar on 29/06/2021.
//

import UIKit

class OTPRoute: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let changePasswordVC = UIStoryboard.main.instantiateViewController(withIdentifier: ChangePasswordVC.identifier) as? ChangePasswordVC {
            let dic = parameters as? [String: Any]
            changePasswordVC.email = dic?["email"] as? String
            changePasswordVC.token = dic?["token"] as? String
                context.navigationController?.pushViewController(changePasswordVC, animated: animated)
        }
    }
}
