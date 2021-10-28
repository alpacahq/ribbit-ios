//
//  ReviewRouter.swift
//  Ribbit
//
//  Created by Ahsan Ali on 09/04/2021.
//

import UIKit

class ReviewRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        switch routeID {
        case UnderReviewVC.identifier:
            if let vController = UIStoryboard.main.instantiateViewController(withIdentifier: UnderReviewVC.identifier) as? UnderReviewVC {
                context.navigationController?.pushViewController(vController, animated: animated)
            }
        case AproovedVC.identifier:
            if let vController = UIStoryboard.main.instantiateViewController(withIdentifier: AproovedVC.identifier) as? AproovedVC {
                vController.isAproved = (parameters as? NSDictionary)?["approved"] as? Bool ?? false
                context.navigationController?.pushViewController(vController, animated: animated)
            }
        default:
            for controller in context.navigationController!.viewControllers as Array {
                if controller.isKind(of: EmailVC.self) {
                    context.navigationController!.popToViewController(controller, animated: animated)
                    break
                }
            }
        }
    }
}
