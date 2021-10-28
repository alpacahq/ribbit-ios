//
//  AddressCell.swift
//  Ribbit
//
//  Created by Rao Mudassar on 28/07/2021.
//

import UIKit

class AddressCell: UITableViewCell {
    @IBOutlet var street: UILabel!

    @IBOutlet var apartment: UILabel!

    @IBOutlet var starte: UILabel!

    @IBOutlet var address: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
