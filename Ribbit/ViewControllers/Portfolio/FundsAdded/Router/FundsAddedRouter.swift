//
//  FundsAddedRouter.swift
//  Ribbit
//
//  Created by Ahsan Ali on 20/05/2021.
//

import UIKit

class FundsAddedRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        context.navigationController?.popViewController(animated: true)
    }
    func routeToParent(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        context.navigationController?.popToRootViewController(animated: true)
    }
}
