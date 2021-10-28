//
//  PlaidSuccessRouter.swift
//  Ribbit
//
//  Created by Ahsan Ali on 25/05/2021.
//

import UIKit

class PlaidSuccessRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let vController = UIStoryboard.home.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
            UIApplication.setRootView(vController, options: UIApplication.loginAnimation)
        }
    }
}
