//
//  BankVC.swift
//  Ribbit
//
//  Created by Ahsan Ali on 18/03/2021.
//

import UIKit

class BankVC: UIViewController {
    @IBOutlet var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.backgroundImage = UIImage()
    }

    @IBAction func contAction(_ sender: Any) {
        if let vController = UIStoryboard.home.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
            UIApplication.setRootView(vController, options: UIApplication.loginAnimation)
        }
    }
}

extension BankVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: BankCell.identifier) as? BankCell else {
            return UITableViewCell()
        }
        return cell
    }
}
