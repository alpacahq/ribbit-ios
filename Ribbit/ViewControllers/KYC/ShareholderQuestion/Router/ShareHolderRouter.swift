//
//  ShareHolderRouter.swift
//  Ribbit
//
//  Created by Ahsan Ali on 08/04/2021.
//

import UIKit

class ShareHolderRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let vController = UIStoryboard.main.instantiateViewController(withIdentifier: BrokerageQuestionVC.identifier) as? BrokerageQuestionVC {
            context.navigationController?.pushViewController(vController, animated: animated)
        }
    }

    func routeToCompany(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let vController = UIStoryboard.main.instantiateViewController(withIdentifier: CompanyInfoVC.identifier) as? CompanyInfoVC {
            context.navigationController?.pushViewController(vController, animated: animated)
        }
    }
}
