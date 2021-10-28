//
//  CompanyInfoRoute.swift
//  Ribbit
//
//  Created by Rao Mudassar on 30/06/2021.
//

import UIKit

class CompanyInfoRoute: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let brokerageQuestionVC = UIStoryboard.main.instantiateViewController(withIdentifier: BrokerageQuestionVC.identifier) as? BrokerageQuestionVC {
                context.navigationController?.pushViewController(brokerageQuestionVC, animated: animated)
        }
    }
}
