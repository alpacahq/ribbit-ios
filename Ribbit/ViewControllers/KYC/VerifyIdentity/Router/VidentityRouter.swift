//
// VidentityRouter.swift
// Ribbit
//
// Created by Ahsan Ali on 15/04/2021.
//
import UIKit
class VidentityRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let vController = UIStoryboard.main.instantiateViewController(withIdentifier: SocialSecurityVC.identifier) as? SocialSecurityVC {
            context.navigationController?.pushViewController(vController, animated: animated)
        }
    }
}
