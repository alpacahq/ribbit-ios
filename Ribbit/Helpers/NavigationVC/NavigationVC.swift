//
//  NavigationVC.swift
//  Ribbit
//
//  Created by Adnan Asghar on 3/16/21.
//

import UIKit

class NavigationVC: UINavigationController {
    // MARK: - IBOutlets

    // MARK: - Variables

    // MARK: - Life Cycle

    var vController = UIViewController()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }

    // MARK: - IBActions

    @IBAction func backAction(_ sender: UIButton) {
        vController.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UINavigationControllerDelegate

extension NavigationVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.leftBarButtonItem = nil

        let backButton = UIButton(frame: CGRect(x: 30, y: 0, width: 17, height: 29))
            backButton.setImage(UIImage(named: "back.png"), for: .normal) // Image can be downloaded from here below link
            backButton.setTitle("", for: .normal)

            backButton.setTitleColor(backButton.tintColor, for: .normal) // You can change the TitleColor
            vController = viewController
            backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)

        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

//        let item = UIBarButtonItem(image: UIImage(named:"back"), style: .plain, target: self, action:nil)
//        item.tintColor = UIColor.init(named: "appColorDarkBlue")
//        viewController.navigationItem.backBarButtonItem = item
    }
}
