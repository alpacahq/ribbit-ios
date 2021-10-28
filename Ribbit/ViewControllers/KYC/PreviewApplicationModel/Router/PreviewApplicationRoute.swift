//
//  PreviewApplicationRoute.swift
//  Ribbit
//
//  Created by Rao Mudassar on 01/07/2021.
//
import UIKit
class PreviewApplicationRoute: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let vController = UIStoryboard.main.instantiateViewController(withIdentifier: ReviewVC.identifier) as? ReviewVC {
            context.navigationController?.pushViewController(vController, animated: animated)
        }
    }
}
