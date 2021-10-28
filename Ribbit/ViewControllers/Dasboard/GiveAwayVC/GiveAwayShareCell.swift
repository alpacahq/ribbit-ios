//
// GiveAwayShareCell.swift
// Ribbit
//
// Created by Ahsan Ali on 29/03/2021.
//

import UIKit

class GiveAwayShareCell: UITableViewCell {
    @IBOutlet var lblURL: UILabel!

    var share:(() -> Void)?
    // MARK: - Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        if lblURL != nil {
            lblURL.text = USER.shared.sharelink
        }
    }

    @IBAction func share(_ sender: Any) {
        share!()
    }
}
