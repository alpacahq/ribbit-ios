//
//  ReferelRouter.swift
//  Ribbit
//
//  Created by Ahsan Ali on 03/06/2021.
//

import UIKit

class ReferelRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let vController = UIStoryboard.main.instantiateViewController(withIdentifier: NameVC.identifier) as? NameVC {
            context.navigationController?.pushViewController(vController, animated: animated)
        }
    }
}
