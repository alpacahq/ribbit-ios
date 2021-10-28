//
//  UnderRevRouter.swift
//  Ribbit
//
//  Created by Ahsan Ali on 19/04/2021.
//

import UIKit

class UnderRevRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if routeID == UnderReviewVC.identifier {
            if let vController = UIStoryboard.main.instantiateViewController(identifier: UnderReviewVC.identifier) as? UnderReviewVC {
                let navVC = NavigationVC(rootViewController: vController)
                navVC.modalPresentationStyle = .fullScreen
                context.present(navVC, animated: animated, completion: nil)
            }
        } else {
            if let vController = UIStoryboard.main.instantiateViewController(identifier: PlaidIntroVC.identifier) as? PlaidIntroVC {
                vController.modalPresentationStyle = .fullScreen
                vController.fromSignup = (parameters as? NSDictionary)?["signup"] as? Bool ?? false
                context.present(vController, animated: animated)
            }
        }
    }
}
