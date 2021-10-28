//
//  Loader.swift
//  Ribbit
//
//  Created by Ahsan Ali on 04/06/2021.
//

import UIKit

class Loader: UIView {
    @IBOutlet var animator: UIActivityIndicatorView!
    var isAdded = false
    func setView(hasLoader: Bool? = false) {
        isAdded = true
       frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        if hasLoader! {
            backgroundColor = UIColor(red: 0.196, green: 0.164, blue: 0.237, alpha: 0.26)
            animator.isHidden = false
        } else {
            animator.isHidden = true
           backgroundColor = UIColor(red: 0.196, green: 0.164, blue: 0.237, alpha: 0)
        }
        UIApplication.shared.windows.first!.addSubview(self)
    }
}
