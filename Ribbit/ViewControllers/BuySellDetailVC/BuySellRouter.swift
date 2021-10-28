//
//  BuySellRouter.swift
//  Ribbit
//
//  Created by Rao Mudassar on 04/08/2021.
//

import UIKit

class BuySellRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let vController = UIStoryboard.portfolio.instantiateViewController(withIdentifier: BuyViewController.identifier) as? BuyViewController {
            vController.object = parameters as? StockTicker
            context.navigationController?.pushViewController(vController, animated: animated)
        }
    }
}
