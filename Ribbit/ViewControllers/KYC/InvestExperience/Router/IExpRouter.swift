//
// IExpRouter.swift
// Ribbit
//
// Created by Ahsan Ali on 08/04/2021.
//
import UIKit
class IExpRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let vController = UIStoryboard.main.instantiateViewController(withIdentifier: FundingSourceVC.identifier) as? FundingSourceVC {
            context.navigationController?.pushViewController(vController, animated: animated)
        }
    }
}
