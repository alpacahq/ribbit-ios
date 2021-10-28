//
//  EmployedRouter.swift
//  Ribbit
//
//  Created by Ahsan Ali on 08/04/2021.
//

import UIKit

class EmployedRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let vController = UIStoryboard.main.instantiateViewController(withIdentifier: ShareholderQuestionVC.identifier) as? ShareholderQuestionVC {
            context.navigationController?.pushViewController(vController, animated: animated)
        }
    }
    func routeToWork(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let vController = UIStoryboard.main.instantiateViewController(withIdentifier: WorkInfoVC.identifier) as? WorkInfoVC {
            context.navigationController?.pushViewController(vController, animated: animated)
        }
    }
}
