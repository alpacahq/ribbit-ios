//
//  PortfolioRouter.swift
//  Ribbit
//
//  Created by Ahsan Ali on 21/04/2021.
//

import UIKit

class PortfolioRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        switch routeID {
        case TransactionsVC.identifier:
            if let vController = UIStoryboard.portfolio.instantiateViewController(withIdentifier: TransactionsVC.identifier) as? TransactionsVC {
                vController.hidesBottomBarWhenPushed = true
                context.navigationController?.pushViewController(vController, animated: animated)
            }
        default:
            if let vController = UIStoryboard.portfolio.instantiateViewController(withIdentifier: BuySellVC.identifier) as? BuySellVC {
                vController.object = parameters as? StockTicker
                context.navigationController?.pushViewController(vController, animated: animated)
            }
        }
    }
}
