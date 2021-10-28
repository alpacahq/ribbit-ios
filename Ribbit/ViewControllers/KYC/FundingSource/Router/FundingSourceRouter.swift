//
//  FundingSourceRouter.swift
//  Ribbit
//
//  Created by Ahsan Ali on 03/05/2021.
//

import UIKit

class FundingSourceRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let vController = UIStoryboard.main.instantiateViewController(withIdentifier: EmployedVC.identifier) as? EmployedVC {
            context.navigationController?.pushViewController(vController, animated: animated)
        }
    }
}
