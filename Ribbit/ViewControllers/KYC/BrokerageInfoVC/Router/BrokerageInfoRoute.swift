//
//  BrokerageInfoRoute.swift
//  Ribbit
//
//  Created by Rao Mudassar on 30/06/2021.
//

import UIKit

class BrokerageInfoRoute: Router {
func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
    if let vController = UIStoryboard.main.instantiateViewController(withIdentifier: PreviewApplicationVC.identifier) as? PreviewApplicationVC {
        context.navigationController?.pushViewController(vController, animated: animated)
    }
  }
}
