//
//  EmailRouter.swift
//  Ribbit
//
//  Created by Ahsan Ali on 07/04/2021.
//

import UIKit

class EmailRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let magicLinkVC = UIStoryboard.main.instantiateViewController(withIdentifier: MagicLinkVC.identifier) as? MagicLinkVC {
                magicLinkVC.email = parameters as? String ?? ""
                context.navigationController?.pushViewController(magicLinkVC, animated: animated)
        }
    }
}
