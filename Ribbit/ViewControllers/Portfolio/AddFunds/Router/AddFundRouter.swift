//
//  AddFundRouter.swift
//  Ribbit
//
//  Created by Ahsan Ali on 03/05/2021.
//

import UIKit

class AddFundRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        guard let vc = UIStoryboard.portfolio.instantiateViewController(withIdentifier: FundsAddedVC.identifier) as? FundsAddedVC else {
            return
        }

        vc.amount = (parameters as? NSDictionary)?["amount"] as? String ?? ""
        vc.time = (parameters as? NSDictionary)?["time"] as? String ?? ""
        vc.status = (parameters as? NSDictionary)?["status"] as? String ?? ""
        context.navigationController?.pushViewController(vc, animated: animated)
    }
}
