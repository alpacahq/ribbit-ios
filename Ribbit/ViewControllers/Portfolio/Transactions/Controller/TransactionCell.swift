//
//  TransactionCell.swift
//  Ribbit
//
//  Created by Ahsan Ali on 19/05/2021.
//

import UIKit

class TransactionCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet var icon: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var lblAmount: UILabel!

    // MARK: - Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
