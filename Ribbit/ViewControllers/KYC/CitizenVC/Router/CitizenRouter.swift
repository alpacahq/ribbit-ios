//
//  CitizenRouter.swift
//  Ribbit
//
//  Created by Ahsan Ali on 08/04/2021.
//

import FittedSheets
import UIKit
class CitizenRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        switch routeID {
        case VerifyIdentityVC.identifier :
            if let vController = UIStoryboard.main.instantiateViewController(withIdentifier: VerifyIdentityVC.identifier) as? VerifyIdentityVC {
                context.navigationController?.pushViewController(vController, animated: animated)
            }
        default:
            if  let controller = UIStoryboard.main.instantiateViewController(withIdentifier: CountryListVC.identifier) as? CountryListVC {
                controller.countryCode = (parameters as? NSDictionary)?["country"] as? String ?? ""
                controller.stateCode = (parameters as? NSDictionary)?["state"] as? String ?? ""
                let sheet = SheetViewController(controller: controller, sizes: [.fixed(200), .marginFromTop(100)])
                controller.delegate = context as? CountryDelegate
                sheet.didDismiss = { _ in
                    context.view.endEditing(true)
                }
                context.present(sheet, animated: false, completion: nil)
            }
        }
    }
}
