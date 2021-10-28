//
//  TransactionRouter.swift
//  Ribbit
//
//  Created by Ahsan Ali on 19/05/2021.
//

import UIKit

class TransactionRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        switch routeID {
        case PlaidIntroVC.identifier:
            if let vc = UIStoryboard.main.instantiateViewController(identifier: PlaidIntroVC.identifier) as? PlaidIntroVC {
                vc.modalPresentationStyle = .fullScreen
                context.present(vc, animated: animated)
            }

        case FundsAddedVC.identifier :
            guard let vc = UIStoryboard.portfolio.instantiateViewController(withIdentifier: FundsAddedVC.identifier) as? FundsAddedVC else {
                return
            }

            vc.amount = (parameters as? NSDictionary)?["amount"] as? String ?? ""
            vc.time = (parameters as? NSDictionary)?["time"] as? String ?? ""
            vc.status = (parameters as? NSDictionary)?["status"] as? String ?? ""
            context.navigationController?.pushViewController(vc, animated: animated)

        default:
            guard let vc = UIStoryboard.portfolio.instantiateViewController(withIdentifier: AddFundVC.identifier) as? AddFundVC else {
                return
            }
            context.navigationController?.pushViewController(vc, animated: animated)
        }
    }
}
