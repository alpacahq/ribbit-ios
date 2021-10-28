//
//  BrokerageRouter.swift
//  Ribbit
//
//  Created by Ahsan Ali on 09/04/2021.
//

import UIKit

class BrokerageRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let vController = UIStoryboard.main.instantiateViewController(withIdentifier: PreviewApplicationVC.identifier) as? PreviewApplicationVC {
            context.navigationController?.pushViewController(vController, animated: animated)
        }
    }
    func routeToBrokerage(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let vController = UIStoryboard.main.instantiateViewController(withIdentifier: BrokerageInfoVC.identifier) as?  BrokerageInfoVC {
            context.navigationController?.pushViewController(vController, animated: animated)
        }
    }
}
