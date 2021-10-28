//
// HomeRouter.swift
// Ribbit
//
// Created by Ahsan Ali on 25/05/2021.
//

import UIKit
class HomeRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        switch routeID {
        case NotificationsVC.identifier:
            if let viewController = UIStoryboard.home.instantiateViewController(withIdentifier: NotificationsVC.identifier) as? NotificationsVC {
                context.navigationController?.pushViewController(viewController, animated: true)
            }
        default:
            if let viewController = UIStoryboard.home.instantiateViewController(withIdentifier: "GiveAwayVC") as? UINavigationController {
                viewController.modalPresentationStyle = .fullScreen
                context.present(viewController, animated: animated, completion: nil)
            }
        }
    }

    func routeToSearch(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let viewController = UIStoryboard.home.instantiateViewController(withIdentifier: StockerTickerViewController.identifier) as? StockerTickerViewController {
            context.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
