//
//  IntroRouter.swift
//  Ribbit
//
//  Created by Ahsan Ali on 19/04/2021.
//

import UIKit

class IntroRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
            if let vController = UIStoryboard.main.instantiateViewController(withIdentifier: AccountLinkedResultVC.identifier) as? AccountLinkedResultVC {
                vController.modalPresentationStyle  = .fullScreen
                vController.fromSignup = (parameters as? NSDictionary)?["signup"] as? Bool ?? false
                context.present(vController, animated: animated)
        }
    }
}
