//
//  Router.swift
//  Ribbit
//
//  Created by Rao Mudassar on 30/06/2021.
//

import UIKit

class WorkRoute: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let shareholderQuestionVC = UIStoryboard.main.instantiateViewController(withIdentifier: ShareholderQuestionVC.identifier) as? ShareholderQuestionVC {
                context.navigationController?.pushViewController(shareholderQuestionVC, animated: animated)
        }
    }
}
