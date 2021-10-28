//
//  BaseVC.swift
//  Ribbit
//
//  Created by Ahsan Ali on 23/03/2021.
//

import UIKit

class BaseVC: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet var allTextObject: [UITextField] = []
    // MARK: - Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        navigationController?.interactivePopGestureRecognizer?.delegate = self

        for textField in allTextObject {
            textField.textColor = .black
        }
    }
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    @objc func popToParentViewController() {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func dismissPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
