//
//  ProfileRouter.swift
//  Ribbit
//
//  Created by Ahsan Ali on 01/06/2021.
//

import UIKit

class ProfileRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let vController = UIStoryboard.profile.instantiateViewController(withIdentifier: "editprofile") as? UINavigationController {
            vController.modalPresentationStyle = .fullScreen
            context.present(vController, animated: true, completion: nil)
        }
    }
}
